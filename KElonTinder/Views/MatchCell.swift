//
//  MatchCell.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/28.
//  Copyright © 2020 최민섭. All rights reserved.
//

import LBTATools

class MatchCell: LBTAListCell<Match> {
    
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Username Here",
                                font: .systemFont(ofSize: 15, weight: .semibold),
                                textColor: #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1),
                                textAlignment: .center,
                                numberOfLines: 2)
    
    override var item: Match! {
        didSet {
            usernameLabel.text = item.name
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius  = 80 / 2
        stack(stack(profileImageView, alignment: .center),
              usernameLabel)
    }
}

class MatchesHeader: UICollectionReusableView {
    let newMatchesLabel = UILabel(text: "New Matches",
                                  font: .boldSystemFont(ofSize: 18),
                                  textColor: #colorLiteral(red: 0.9932715297, green: 0.4267289042, blue: 0.1743455827, alpha: 1))
    let matchesHorizontalController = MatchesHorizontalController()
    let messagesLabel = UILabel(text: "Message",
                                  font: .boldSystemFont(ofSize: 18),
                                  textColor: #colorLiteral(red: 0.9932715297, green: 0.4267289042, blue: 0.1743455827, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stack(stack(newMatchesLabel).padLeft(20),
              matchesHorizontalController.view,
              stack(messagesLabel).padLeft(20),
              spacing: 20).withMargins(.init(top: 20, left: 20, bottom: 8, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
