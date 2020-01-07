//
//  CardView.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/06.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var cardViewModel: CardViewModel! {
        didSet {
            // accessimg index 0 will crash if imageNames.count == 0
            let imageName = cardViewModel.imageNames.first ?? ""
            imageview.image = UIImage(named: imageName)
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { _ in
                let barView = UIView()
                barView.backgroundColor = barDeSelectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
        }
    }
    
    fileprivate let barDeSelectedColor = UIColor(white: 0, alpha: 0.1)
    
    // Encapsulation
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let imageview = UIImageView(image: #imageLiteral(resourceName: "lady5c"))
    fileprivate let informationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 34, weight: .heavy)
        return label
    } ()
    
    // Configurations
    fileprivate let threshold: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
    
    fileprivate var imageIndex = 0
    @objc fileprivate func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2
        if shouldAdvanceNextPhoto {
            imageIndex = min(imageIndex + 1, cardViewModel.imageNames.count - 1)
        } else {
            imageIndex = max(imageIndex - 1, 0)
        }
        
        let imageName = cardViewModel.imageNames[imageIndex]
        imageview.image = UIImage(named: imageName)
        barsStackView.arrangedSubviews.forEach { v in
            v.backgroundColor = barDeSelectedColor
        }
        barsStackView.arrangedSubviews[imageIndex].backgroundColor = .white
    }
    
    fileprivate func setupLayout() {
        // custom drawing code
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageview.contentMode = .scaleAspectFill
        addSubview(imageview)
        imageview.fillSuperview()
        
        setupBarsStackView()

        // add a gradient later somehow
        setupFradientLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
    }
    
    fileprivate let barsStackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    fileprivate func setupBarsStackView() {
        addSubview(barsStackView)
        barsStackView.anchor(top: topAnchor,
                              leading: leadingAnchor,
                              bottom: nil,
                              trailing: trailingAnchor,
                              padding: .init(top: 8, left: 8, bottom: 0, right: 8),
                              size: .init(width: 0, height: 4))
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        // some dummy bars for now
        
    }
    
    fileprivate func setupFradientLayer() {
        // draw a gradient
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        // self.frame is actually zero frame
        layer.addSublayer(gradientLayer)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ subview in
                // prevent animation being corrupt when Gesture Interruption is occur at same time
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChagned(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    override func layoutSubviews() {
        // we can know CardView Frame will be
        gradientLayer.frame = self.frame
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
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
