//
//  MatchesMessagesController.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/26.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit
import LBTATools

class MatchCell: LBTAListCell<UIColor> {
    
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Username Here",
                                font: .systemFont(ofSize: 15, weight: .semibold),
                                textColor: #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1),
                                textAlignment: .center,
                                numberOfLines: 2)
    
    override var item: UIColor! {
        didSet {
            backgroundColor = item
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


class MatchesMessagesController: LBTAListController<MatchCell, UIColor>, UICollectionViewDelegateFlowLayout {

    let customNavBar = MatchesNavBar()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: 120)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = [
            .red, .blue, .green
        ]
        
        //collectionView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellWithReuseIdentifier: <#T##String#>)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            leading: view.leadingAnchor,
                            bottom: nil,
                            trailing: view.trailingAnchor,
                            size: .init(width: 0, height: 150))
        
        collectionView.contentInset.top = 150
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
