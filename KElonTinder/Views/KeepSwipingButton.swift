//
//  KeepSwipingButton.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/25.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit

class KeepSwipingButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 1, green: 0.1311001712, blue: 0.5815496575, alpha: 1)
        let rightColor = #colorLiteral(red: 0.7966074486, green: 0.382223887, blue: 0.1641962757, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // apply a mask using a small rectangle inside the gradient
        let cornerRadius = rect.height / 2
        let maskLayer = CAShapeLayer()
        
        let maskPath = CGMutablePath()
        maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
        
        // 가운데 를 잘라버리자
        maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerRadius: cornerRadius).cgPath)
        
        maskLayer.path = maskPath
        //중첩 뽑아내서 테두리를 만들자
        maskLayer.fillRule = .evenOdd
        
        gradientLayer.mask = maskLayer
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.addSublayer(gradientLayer)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        gradientLayer.frame = rect
    }
}
