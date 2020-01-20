//
//  CardView.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/06.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
}

class CardView: UIView {
    var delegate: CardViewDelegate?
    
    var cardViewModel: CardViewModel! {
        didSet {
            
            
            
            swipingPhotosController.cardViewModel = self.cardViewModel
            
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageUrls.count).forEach { _ in
                let barView = UIView()
                barView.backgroundColor = barDeSelectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    
    fileprivate let barDeSelectedColor = UIColor(white: 0, alpha: 0.1)
    
    fileprivate func setupImageIndexObserver() {
        // prevent retain cycle
        cardViewModel.imageIndexObserver = { [unowned self] (idx, imageUrl) in
            if let url = URL(string: imageUrl ?? "") {
//                self.swipingPhotosController.view!.sd_setImage(with: url,
//                                           placeholderImage: #imageLiteral(resourceName: "photo_placeholder"),
//                                           options: .continueInBackground)
            }
            
            self.barsStackView.arrangedSubviews.forEach { v in
                v.backgroundColor = self.barDeSelectedColor
            }
            self.barsStackView.arrangedSubviews[idx].backgroundColor = .white
        }
    }
    
    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
    
    // Encapsulation
    fileprivate let gradientLayer = CAGradientLayer()
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
        backgroundColor = .white
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
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.tintColor = .white
        button.setImage(#imageLiteral(resourceName: "info_icon"), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: cardViewModel)
    }
    
    fileprivate func setupLayout() {
        // custom drawing code
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let swipingPhotosView = swipingPhotosController.view!
        
        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()
        
//        setupBarsStackView()

        // add a gradient later somehow
        setupGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil,
                              leading: nil,
                              bottom: bottomAnchor,
                              trailing: trailingAnchor,
                              padding: .init(top: 0, left: 0, bottom: 16, right: 16),
                              size: .init(width: 44, height: 44))
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
    
    fileprivate func setupGradientLayer() {
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
