//
//  MatchView.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/25.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit

class MatchView: UIView {
    
    fileprivate let itsMatchImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.text = "You and X have linked each other"
        lb.textAlignment = .center
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.numberOfLines = 0
        return lb
    }()
    
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "jane2"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    fileprivate let cardUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly2"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    fileprivate let sendMessageButton: UIButton = {
        let bt = SendMessageButton(type: .system)
        bt.setTitle("SEND MESSAGE", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        return bt
    }()
    
    fileprivate let keepSwipingButton: UIButton = {
        let bt = KeepSwipingButton(type: .system)
        bt.setTitle("Keep Swiping", for: .normal)
        bt.setTitleColor(.white, for: .normal)        
        return bt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurView()
        
        setupLayout()
        
        setupAnimations()
    }
    
    let imageWidth: CGFloat = 140
    
    fileprivate func setupAnimations() {
        let angle = 30 * CGFloat.pi / 180
        
        // set starting position
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
            .concatenating(CGAffineTransform(translationX: 200, y: 0))
        cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
        .concatenating(CGAffineTransform(translationX: -200, y: 0))
        sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        // keyframe animation for segmented animation
        UIView.animateKeyframes(withDuration: 1.3,
                                delay: 0,
                                options: .calculationModeCubic,
                                animations: {
                                    // animation 1 - translation back to original position
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                                        self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                                        self.cardUserImageView.transform = CGAffineTransform(rotationAngle: angle)
                                    }
                                    // animation 2 - rotation
                                    UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                                        self.currentUserImageView.transform = .identity
                                        self.cardUserImageView.transform = .identity
                                    }
        }, completion: { _ in
            
        })
        
        UIView.animate(withDuration: 0.6,
                       delay: 0.6 * 1.3,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut,
                       animations: {
                        self.sendMessageButton.transform = .identity
                        self.keepSwipingButton.transform = .identity
        },
                       completion: { _ in
        })
    }
    
    fileprivate func setupLayout() {
        addSubview(itsMatchImageView)
        addSubview(descriptionLabel)
        addSubview(sendMessageButton)
        addSubview(keepSwipingButton)
        addSubview(currentUserImageView)
        addSubview(cardUserImageView)
        
        itsMatchImageView.anchor(top: nil,
                                 leading: nil,
                                 bottom: descriptionLabel.topAnchor,
                                 trailing: nil,
                                 padding: .init(top: 0, left: 0, bottom: 16, right: 0),
                                 size: .init(width: 300, height: 80))
        itsMatchImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        descriptionLabel.anchor(top: nil,
                                leading: leadingAnchor,
                                bottom: currentUserImageView.topAnchor,
                                trailing: trailingAnchor,
                                padding: .init(top: 0, left: 0, bottom: 32, right: 0),
                                size: .init(width: 0, height: 50))
        
        currentUserImageView.anchor(top: nil,
                                    leading: nil,
                                    bottom: nil,
                                    trailing: centerXAnchor,
                                    padding: .init(top: 0, left: 0, bottom: 0, right: 16),
                                    size: .init(width: imageWidth, height: imageWidth))
        currentUserImageView.layer.cornerRadius = imageWidth/2
        currentUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        cardUserImageView.anchor(top: nil,
                                    leading: centerXAnchor,
                                    bottom: nil,
                                    trailing: nil,
                                    padding: .init(top: 0, left: 16, bottom: 0, right: 0),
                                    size: .init(width: imageWidth, height: imageWidth))
        cardUserImageView.layer.cornerRadius = imageWidth/2
        cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor,
                                 leading: leadingAnchor,
                                 bottom: nil,
                                 trailing: trailingAnchor,
                                 padding: .init(top: 32, left: 48, bottom: 0, right: 48),
                                 size: .init(width: 0, height: 60))
        
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor,
                                 leading: sendMessageButton.leadingAnchor,
                                 bottom: nil,
                                 trailing: sendMessageButton.trailingAnchor,
                                 padding: .init(top: 16, left: 0, bottom: 0, right: 0),
                                 size: .init(width: 0, height: 60))
        
    }
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    fileprivate func setupBlurView() {
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.visualEffectView.alpha = 1
        },
                       completion: { _ in
                        
        })
    }
    
    @objc fileprivate func handleTapDismiss() {
        UIView.animate(withDuration: 0.5,
                             delay: 0,
                             usingSpringWithDamping: 1,
                             initialSpringVelocity: 1,
                             options: .curveEaseOut,
                             animations: {
                              self.alpha = 0
              },
                             completion: { _ in
                                self.removeFromSuperview()

              })
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
