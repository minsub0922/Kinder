//
//  UserDetailsController.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/10.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit

class UserDetailsController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.backgroundColor = .green
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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
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
