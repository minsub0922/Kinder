//
//  ViewController.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/02.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let topStackView = TopNavigationStackView()
    private let bottonsStackView = HomeBottomControlsStackView()
    private let cardDeckView = UIView()
    private let overallStackView: UIStackView = {
        let overallStackView = UIStackView()
        overallStackView.axis = .vertical
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        return overallStackView
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupDummyCards()
    }
    
    // MARK:- Fileprivate
    fileprivate func setupDummyCards() {
        let cardview = CardView(frame: .zero)
        cardDeckView.addSubview(cardview)
        cardview.fillSuperview()
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

