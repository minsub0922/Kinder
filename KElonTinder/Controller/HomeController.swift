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
    
    let cardViewModels: [CardViewModel] = {
        let producers: [ProducesCardViewModel] = [
            User(name: "Jane",
                 age: 18,
                 profession: "Teacher",
                 imageNames: ["jane1", "jane2", "jane3"]),
            Advertiser(title: "Slide Out Menu",
                       brandName: "Korean Elon",
                       posterPhotoName: "slide_out_menu_poster"),
            User(name: "Kelly",
                          age: 23,
                          profession: "Music DJ",
                          imageNames: ["kelly1", "kelly2", "kelly3"])
        ]
        
        let viewModels = producers.map({ $0.toCardViewModel() })
        return viewModels
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings(_:)), for: .touchUpInside)
        setupLayout()
        setupDummyCards()
    }

    @objc fileprivate func handleSettings(_: Any) {
        let registrationController = RegistrationController()
        present(registrationController, animated: true)
    }
    
    // MARK:- Fileprivate
    fileprivate func setupDummyCards() {
        cardViewModels.forEach { cardViewModel in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardViewModel
            cardDeckView.addSubview(cardView)
            cardView.fillSuperview()
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

