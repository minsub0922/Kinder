//
//  ViewController.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/02.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let stackView: UIStackView = {
        let redView = UIView()
        redView.backgroundColor = .red
        redView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        let blueView = UIView()
        blueView.backgroundColor = .blue
        let yellowView = UIView()
        yellowView.backgroundColor = .yellow
        yellowView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [redView, blueView, yellowView])
        stackView.frame = .init(x: 0, y: 0, width: 300, height: 300)
        //stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        activateAutolayouts()
    }
    
    private func addSubViews() {
        view.addSubview(stackView)
    }
    
    private func activateAutolayouts() {
        stackView.fillSuperview()
    }
}

