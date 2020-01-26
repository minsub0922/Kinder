//
//  ChatLogController.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/26.
//  Copyright © 2020 최민섭. All rights reserved.
//

import LBTATools

struct Message {
    let text: String
    let isFromCurrentLoggedUser: Bool
}

class MessageCell: LBTAListCell<Message> {
    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let bubbleContainer = UIView(backgroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
    
    override var item: Message! {
        didSet {
            backgroundColor = .white
            textView.text = item.text

            anchoredConstraints.trailing?.isActive = item.isFromCurrentLoggedUser
            anchoredConstraints.leading?.isActive = !item.isFromCurrentLoggedUser
            bubbleContainer.backgroundColor = item.isFromCurrentLoggedUser ? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            textView.textColor = item.isFromCurrentLoggedUser ? .white : .black
        }
    }
    
    var anchoredConstraints: AnchoredConstraints!
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(bubbleContainer)
        
        bubbleContainer.layer.cornerRadius = 12
        anchoredConstraints = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        anchoredConstraints.leading?.constant = 20
        anchoredConstraints.trailing?.constant = -20
        
        // seperate user side
        anchoredConstraints.trailing?.isActive = false
        
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: frame.width * 4/5).isActive = true
        bubbleContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
    }
}

class MessagesNavBar: UIView {
    
    let userProfileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "jane2"))
    let nameLabel = UILabel(text: "USERNAME", font: .systemFont(ofSize: 13))
    let backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
    let flagButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
    fileprivate let match: Match
    init(match: Match) {
        self.match = match
        super.init(frame: .zero)
        
        
       
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        backgroundColor = .white
        setupShadow(opacity: 0.2,
                    radius: 8,
                    offset: .init(width: 0, height: 10),
                    color: .init(white: 0, alpha: 0.3))
        
        nameLabel.text = match.name
        userProfileImageView.sd_setImage(with: URL(string: match.profileImageUrl))
        
        let middleStack = hstack(
            stack(
                userProfileImageView,
                nameLabel,
                spacing: 8,
                alignment: .center),
            alignment: .center)
        
        hstack(backButton,
               middleStack,
               flagButton).padLeft(16).padRight(16)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {

    fileprivate lazy var customNavBar = MessagesNavBar(match: match)
    
    fileprivate let navBarHeight: CGFloat = 120
    
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // input accessory view for chatting
    override var inputAccessoryView: UIView? {
        get {
            return CustomInputAccessoryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.keyboardDismissMode = .interactive
        
        collectionView.alwaysBounceVertical = true
        
        // dummy datas
        items = [
            .init(text: "Hello everyone i want to say something for you. I am Iron ManHello everyone i want to say something for you. I am Iron ManHello everyone i want to say something for you. I am Iron ManHello everyone i want to say something for you. I am Iron ManHello everyone i want to say something for you. I am Iron ManHello everyone i want to say something for you. I am Iron ManHello everyone i want to say something for you.", isFromCurrentLoggedUser: true),
            .init(text: "Hello from the Tinder Course", isFromCurrentLoggedUser: false),
            .init(text: "Hey, What a nice day, Today", isFromCurrentLoggedUser: true)
        ]
        
        setupLayout()
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
