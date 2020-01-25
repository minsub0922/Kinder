//
//  ViewController.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/02.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
    private let topStackView = TopNavigationStackView()
    private let bottomControls = HomeBottomControlsStackView()
    private let cardDeckView = UIView()
    
    private let overallStackView: UIStackView = {
        let overallStackView = UIStackView()
        overallStackView.axis = .vertical
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        return overallStackView
    }()
    
    var cardViewModels = [CardViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings(_:)), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        setupLayout()
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navController = UINavigationController(rootViewController: registrationController)
            present(navController, animated: true)
        }
    }
    
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFirestore()
    }

    @objc fileprivate func handleSettings(_: Any) {
        let settingController = SettingsController()
        settingController.delegate = self
        let navigationController = UINavigationController(rootViewController: settingController)
        present(navigationController, animated: true)
    }
    
    var topCardView: CardView?
    
    @objc func handleDislike() {
        saveSwipeFirestore(didLike: 0)
        performSwipeAnimation(translation: -700, angle: -15)
    }
    
    @objc func handleLike() {
        saveSwipeFirestore(didLike: 1)
        performSwipeAnimation(translation: 700, angle: 15)
    }
    
    fileprivate func saveSwipeFirestore(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let cardUID = topCardView?.cardViewModel.uid else { return }
        let documentData: [String: Any] = [cardUID: didLike]
        
        Firestore.firestore()
            .collection("swipes")
            .document(uid)
            .getDocument { (snapshot, err) in
                if let err = err {
                    print("Fail to save swipe data: ", err)
                    return
                }
                
                if snapshot?.exists == true {
                    Firestore.firestore()
                        .collection("swipes")
                        .document(uid)
                        .updateData(documentData) { err in
                            if let err = err {
                                print("Fail to save swipe data: ", err)
                                return
                            }
                            
                            print("successfully saved swiped..")
                            self.checkIfMatchExists(cardUID: cardUID)
                    }
                } else {
                    Firestore.firestore()
                        .collection("swipes")
                        .document(uid)
                        .setData(documentData) { err in
                            if let err = err {
                                print("Fail to save swipe data: ", err)
                                return
                            }
                            
                            print("successfully saved swiped..")
                            self.checkIfMatchExists(cardUID: cardUID)
                    }
                }
        }
    }
    
    fileprivate func checkIfMatchExists(cardUID: String) {
        // How to detect our match between two users
        Firestore.firestore()
        .collection("swipes")
        .document(cardUID)
            .getDocument { (snapshot, err) in
                if let err  = err {
                    print("Failed to fetch document for card user: ", err)
                    return
                }
                
                guard let data = snapshot?.data() else { return }
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let hasMatched = data[uid] as? Int == 1
                if hasMatched {
                    print("Has matched")
                    let hud = JGProgressHUD(style: .dark)
                    hud.textLabel.text = "Found a match"
                    hud.show(in: self.view)
                    hud.dismiss(afterDelay: 4)
                }
        }
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
            
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    // MARK:- Fileprivate
    
    fileprivate var hud = JGProgressHUD(style: .dark)
    fileprivate var user: User?
    
    fileprivate func fetchCurrentUser() {
        hud.textLabel.text = "Loading"
        hud.show(in: view)
        cardDeckView.subviews.forEach ({ $0.removeFromSuperview()})
        
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                self.hud.dismiss()
                return
            }
            
            self.user = user
            
            self.fetchSwipes()
        }
    }
    
    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore()
        .collection("swipes")
        .document(uid)
            .getDocument { (snapshot, err) in
                if let err = err {
                    print("Failed to fetch swipes info for currently logge in user: ", err)
                    return
                }
                
                print("Swipes: ", snapshot?.data() ?? "")
                guard let data = snapshot?.data() as? [String: Int] else { return }
                self.swipes = data
                self.fetchUsersFromFirestore()
        }
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        let query = Firestore.firestore().collection("users")
        self.topCardView = nil
        if
            let minAge = user?.minSeekingAge,
            let maxAge = user?.maxSeekingAge {
            query
            .whereField("age", isGreaterThanOrEqualTo: minAge)
            .whereField("age", isLessThanOrEqualTo: maxAge)
            //.order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 3)
            //.whereField("age", isLessThan: 29)
        }
            
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            
            if let err = err {
                print(err)
                return
            }
            
            // setup the nextCardView relationship for all cards
            var previousCardView: CardView?
            
            // Get User From FB
            snapshot?.documents.forEach({ documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                let hasNotSwipeBefore = self.swipes[user.uid!] == nil
                if  isNotCurrentUser && hasNotSwipeBefore {
                    let cardView = self.setupCardFromUser(user: user)
                    // use LinkedList Data Structure
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    if self.topCardView == nil { self.topCardView = cardView }
                }
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    fileprivate func setupLayout() {
        view.addSubview(overallStackView)
        
        [topStackView, cardDeckView, bottomControls].forEach { view in
            overallStackView.addArrangedSubview(view)
        }
        
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: view.trailingAnchor)
        
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.bringSubviewToFront(cardDeckView)
    }
}

extension HomeController: SettingsControllerDelegate {
    func didSaveSettings() {
        fetchCurrentUser()
    }
}

extension HomeController: LoginControllerDelegate {
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
}

extension HomeController: CardViewDelegate {
    func didRemoveCard(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsController = UserDetailsController()
        userDetailsController.cardViewModel = cardViewModel
        userDetailsController.modalPresentationStyle = .fullScreen
        present(userDetailsController, animated: true)
    }
}
