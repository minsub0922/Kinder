//
//  UserDetailsController.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/10.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit
import SDWebImage

class UserDetailsController: UIViewController {
    
    // sould create a different ViewModel Object for UserDetails
    // is UserDetailsViewModel
    var cardViewModel: CardViewModel! {
        didSet {
            infoLabel.attributedText = cardViewModel.attributedString
            guard
                let firstImageUrl = cardViewModel.imageUrls.first,
                let url = URL(string: firstImageUrl) else {return}
            imageView.sd_setImage(with: url)
        }
    }
    
    let dismissButton: UIButton = {
        let  button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "dismiss_down_arrow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return button
    }()

    
    lazy var scrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "kelly1"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let infoLabel: UILabel = {
        let lb = UILabel()
        lb.text = "User name 30 \n"
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var dislikeButton = self.createButton(image: #imageLiteral(resourceName: "dismiss_circle"), selector: #selector(handleDislike))
    lazy var superlikeButton = self.createButton(image: #imageLiteral(resourceName: "super_like_circle"), selector: #selector(handleSuperLike))
    lazy var likeButton = self.createButton(image: #imageLiteral(resourceName: "like_circle"), selector: #selector(handleLike))
    
    @objc fileprivate func handleDislike() {
        
    }
    @objc fileprivate func handleSuperLike() {
        
    }
    @objc fileprivate func handleLike() {
        
    }
    
    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupLayout()
        setupVisualBlurEffectView()
        setupBottomControls()
    }
    
    fileprivate func setupLayout() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(imageView)
        
        // why frame instead of auto layout
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: imageView.bottomAnchor,
                         leading: scrollView.leadingAnchor,
                         bottom: nil,
                         trailing: scrollView.trailingAnchor,
                         padding: .init(top: 16, left: 16, bottom: 0, right: 0))
        
        scrollView.addSubview(dismissButton)
        dismissButton.anchor(top: imageView.bottomAnchor,
                             leading: nil,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             padding: .init(top: -25, left: 0, bottom: 0, right: 24),
                             size: .init(width: 50, height: 50))
    }
    
    fileprivate func setupBottomControls() {
        let stackView = UIStackView(arrangedSubviews: [dislikeButton, superlikeButton, likeButton])
        stackView.distribution = .fillEqually
        stackView.spacing = -30
        view.addSubview(stackView)
        stackView.anchor(top: nil,
                         leading: nil,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         trailing: nil,
                         padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                         size: .init(width: 300, height: 80))
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupVisualBlurEffectView() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor,
                                leading: view.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.topAnchor,
                                trailing: view.trailingAnchor)
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }
}

extension UserDetailsController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let changeY = -scrollView.contentOffset.y
        let width = max(view.frame.width,
                    view.frame.width + changeY * 2)
        let x = min(0, -changeY)
        let y = min(0, -changeY)
        imageView.frame = CGRect(x: x,
                                 y: y,
                                 width: width,
                                 height: width)
    }
}
