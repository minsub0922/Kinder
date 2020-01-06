//
//  ViewController.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/02.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private static let topStackView = TopNavigationStackView()
    
    private static let bottonsStackView = HomeBottomControlsStackView()
    
    private let overallStackView: UIStackView = {
        let blueView = UIView()
        blueView.backgroundColor = .blue
        
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, blueView, bottonsStackView])
        overallStackView.axis = .vertical
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        return overallStackView
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        activateAutolayouts()
    }
    
    // MARK:- Fileprivate
    fileprivate func addSubViews() {
        view.addSubview(overallStackView)
    }
    
    fileprivate func activateAutolayouts() {
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: view.trailingAnchor)
    }
}

