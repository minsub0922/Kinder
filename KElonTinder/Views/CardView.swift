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
    
    fileprivate func handleEnded() {
        UIView.animate(withDuration: 0.75,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut,
                       animations: {
                        self.transform = .identity
        }) { _ in
            
        }
    }
    
    fileprivate func handleChagned(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        self.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handleChagned(gesture)
        case .ended:
            handleEnded()
        default:
            ()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
