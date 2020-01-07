//
//  CardView.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/06.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit

class CardView: UIView {
    fileprivate let imageview = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    
    // Configurations
    fileprivate let threshold: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // custom drawing code
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageview)
        imageview.fillSuperview()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        addGestureRecognizer(panGesture)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handleChagned(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChagned(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        
        // rotation
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        //move x, y
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        //determine dismiss card or not
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        UIView.animate(withDuration: 0.75,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut,
                       animations: {
                        if shouldDismissCard {
                            self.center = CGPoint(x: 1000 * translationDirection, y: 0)
                        } else {
                            self.transform = .identity
                        }
        }) { (_) in
            self.transform = .identity
            self.frame = CGRect(x: 0,
                                y: 0,
                                width: self.superview!.frame.width,
                                height: self.superview!.frame.height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
