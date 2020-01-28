//
//  MessageNavBar.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/28.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit
import LBTATools

class MessagesNavBar: UIView {
    
    let userProfileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "jane2"))
    let nameLabel = UILabel(text: "USERNAME", font: .systemFont(ofSize: 13))
    let backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
    let flagButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
    fileprivate let match: Match
    init(match: Match) {
        self.match = match
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        backgroundColor = .white
        setupShadow(opacity: 0.2,
                    radius: 8,
                    offset: .init(width: 0, height: 10),
                    color: .init(white: 0, alpha: 0.3))
        
        nameLabel.text = match.name
        userProfileImageView.sd_setImage(with: URL(string: match.profileImageUrl))
        
        let middleStack = hstack(
            stack(
                userProfileImageView,
                nameLabel,
                spacing: 8,
                alignment: .center),
            alignment: .center)
        
        hstack(backButton,
               middleStack,
               flagButton).padLeft(16).padRight(16)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
