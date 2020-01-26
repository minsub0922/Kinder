//
//  MatchesNavBar.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/26.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit
import LBTATools

class MatchesNavBar: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        backgroundColor = .white
        
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysTemplate),
                                        contentMode: .scaleAspectFit)
        iconImageView.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        let messageLabel = UILabel(text: "Messages",
                                   font: .boldSystemFont(ofSize: 20),
                                   textColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
                                   textAlignment: .center)
        let feedLabel = UILabel(text: "Feed",
                                font: .boldSystemFont(ofSize: 20),
                                textColor: .gray,
                                textAlignment: .center)
        
        setupShadow(opacity: 0.2,
                    radius: 8,
                    offset: .init(width: 0, height: 10),
                    color: .init(white: 0, alpha: 0.3))
        
        stack(iconImageView.withHeight(44),
              hstack(messageLabel,
                     feedLabel,
                     distribution: .fillEqually)).padTop(10)
        
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor,
                          leading: leadingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 12, left: 16, bottom: 0, right: 0),
                          size: .init(width: 34, height: 34))
    }
    
    let backButton = UIButton(image: #imageLiteral(resourceName: "app_icon"), tintColor: .lightGray)
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
