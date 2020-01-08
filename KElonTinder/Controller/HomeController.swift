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
            self.fetchUsersFromFirestore()
        }
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore() {
        guard
            let minAge = user?.minSeekingAge,
            let maxAge = user?.maxSeekingAge
            else { return }
        
        let query = Firestore.firestore().collection("users")
            .whereField("age", isGreaterThanOrEqualTo: minAge)
            .whereField("age", isLessThanOrEqualTo: maxAge)
            //.order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 3)
            //.whereField("age", isLessThan: 29)
        query.getDocuments { (snapshot, err) in
            self.hud.dismiss()
            
            if let err = err {
                print(err)
                return
            }
            
            snapshot?.documents.forEach({ documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCardFromUser(user: user)
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardDeckView.addSubview(cardView)
        cardView.fillSuperview()
    }
    
    fileprivate func setupDummyCards() {
        cardViewModels.forEach { cardViewModel in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardViewModel
            cardDeckView.addSubview(cardView)
            cardDeckView.sendSubviewToBack(cardView)
            cardView.fillSuperview()
        }
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
