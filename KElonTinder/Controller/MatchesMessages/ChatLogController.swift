//
//  ChatLogController.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/26.
//  Copyright © 2020 최민섭. All rights reserved.
//

import LBTATools
import Firebase

class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var customNavBar = MessagesNavBar(match: match)
    fileprivate let navBarHeight: CGFloat = 120
    fileprivate let match: Match
    fileprivate var currentUser: User?
    // input accessory view for chatting\
    lazy var customInputView: CustomInputAccessoryView = {
        let civ = CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        civ.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return civ
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return customInputView
        }
    }
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    deinit {
        print("\(self.className) is destroying itsel properly, no retain cycles or any other memory related issues. Meemory being reclaimed properly")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        collectionView.keyboardDismissMode = .interactive
        collectionView.alwaysBounceVertical = true
        
        fetchCurrentUser()
        fetchMessages()
        setupLayout()
    }
   
    @objc fileprivate func handleSend() {
        saveToFromMessages()
        saveToFromRecentMessages()
    }
    
    fileprivate func fetchCurrentUser() {
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                print("Failed to fetch user:", err)
                return
            }
            
            self.currentUser = user
        }
    }
    
    fileprivate func saveToFromRecentMessages() {
        guard let currentUser = currentUser else { return }
        
        (0..<2).forEach { i in
            let currentuserUid = i == 0 ? currentUser.uid! : match.uid
            let matcherUid = i != 0 ? currentUser.uid! : match.uid
            
            let data = [
                "text": customInputView.textView.text ?? "",
                "name": i == 0 ? match.name : currentUser.name!,
                "profileImageUrl": i == 0 ? match.profileImageUrl : currentUser.imageUrl1!,
                "timestamp": Timestamp(date: Date()),
                "uid": matcherUid] as [String: Any]
            
            Firestore.firestore()
                .collection("matches_messages")
                .document(currentuserUid)
                .collection("recent_messages")
                .document(matcherUid)
                .setData(data) { err in
                    if let err = err {
                        print("Failed to upload recent messages :", err)
                        return
                    }
            }
        }
    }
    
    fileprivate func saveToFromMessages() {
        guard let currentUserId = currentUser?.uid else { return }
        
        (0..<2).forEach { i in
            let currentuserUid = i == 0 ? currentUserId : match.uid
            let matcherUid = i != 0 ? currentUserId : match.uid
            
            let collection = Firestore.firestore()
                .collection("matches_messages")
                .document(currentuserUid)
                .collection(matcherUid)
            
            let data = ["text": customInputView.textView.text ?? "",
                        "fromId": currentuserUid,
                        "told": matcherUid,
                        "timestamp": Timestamp(date: Date())] as [String: Any]
            
            collection.addDocument(data: data) { err in
                if let err = err {
                    print("Failed to save message: ",err)
                    return
                }
                
                if i == 0 { return }
                self.customInputView.textView.text = nil
                self.customInputView.placeholderLabel.isHidden = false
            }
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    fileprivate func fetchMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        let query = Firestore.firestore()
            .collection("matches_messages")
            .document(currentUserId)
            .collection(match.uid)
            .order(by: "timestamp")
        
        // get chat data with realtime
        // use weak rc for preventing retain cycle
        query.addSnapshotListener { [unowned self] (querySnapshot, err) in
            if let err = err {
                print("Filed to fetch messages: ", err)
                return
            }
            
            querySnapshot?.documentChanges.forEach { change in
                if change.type == .added {
                    self.items.append(.init(dictionary: change.document.data()))
                }
            }
            
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.items.count - 1], at: .bottom, animated: true)
        }
    }
    
    @objc fileprivate func handleKeyboardShow() {
        self.collectionView.scrollToItem(at: [0, items.count - 1], at: .bottom, animated: true)
    }
    
    fileprivate func setupLayout() {
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            leading: view.leadingAnchor,
                            bottom: nil,
                            trailing: view.trailingAnchor,
                            size: .init(width: 0, height: navBarHeight))
        
        collectionView.contentInset.top = navBarHeight
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // estimated sizing
        let estimatedSizeCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedSizeCell.item = self.items[indexPath.item]
        estimatedSizeCell.layoutIfNeeded()
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}
