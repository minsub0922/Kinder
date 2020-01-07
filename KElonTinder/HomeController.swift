//
//  ViewController.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/02.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    private let topStackView = TopNavigationStackView()
    private let bottonsStackView = HomeBottomControlsStackView()
    private let cardDeckView = UIView()
    private let overallStackView: UIStackView = {
        let overallStackView = UIStackView()
        overallStackView.axis = .vertical
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        return overallStackView
    } ()

    let users = [
        User(name: "Kelly", age: 23, profession: "Music DJ", imageName: "lady5c"),
        User(name: "Jane", age: 18, profession: "Teacher", imageName: "lady4c")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupDummyCards()
    }
    
    // MARK:- Fileprivate
    fileprivate func setupDummyCards() {
        users.forEach { user in
            let cardview = CardView(frame: .zero)
            cardview.imageview.image = UIImage(named: user.imageName)
            cardview.informationLabel.text = "\(user.name) \(user.age)\n\(user.profession)"
            
            let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
            attributedText.append(NSAttributedString(string: " \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
            attributedText.append(NSAttributedString(string: "\n\(user.profession)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
            cardview.informationLabel.attributedText = attributedText
            
            cardDeckView.addSubview(cardview)
            cardview.fillSuperview()
        }
    }
    
    fileprivate func setupLayout() {
        view.addSubview(overallStackView)
        
        [topStackView, cardDeckView, bottonsStackView].forEach { view in
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

