//
//  SendMessageButton.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/25.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit

class SendMessageButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 1, green: 0.1311001712, blue: 0.5815496575, alpha: 1)
        let rightColor = #colorLiteral(red: 0.7966074486, green: 0.382223887, blue: 0.1641962757, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        gradientLayer.frame = rect
    }
}
