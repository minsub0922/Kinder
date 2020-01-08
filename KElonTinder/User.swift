//
//  User.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/07.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit

struct User: ProducesCardViewModel {
    // defining our properties for our model layer
    var name: String?
    var age: Int?
    var profession: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    
    init(dictionary: [String: Any]) {
        
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"]  as? String
        self.imageUrl2 = dictionary["imageUrl2"]  as? String
        self.imageUrl3 = dictionary["imageUrl3"]  as? String
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let ageString: String = age != nil ? "\(age!)" : "N\\A"
        let professionString: String = profession != nil ? profession! : "Not available"
        
        attributedText.append(NSAttributedString(string: " \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .light)]))
        
        var imageUrls = [String]()
        if let url = imageUrl1 { imageUrls.append(url) }
        if let url = imageUrl2 { imageUrls.append(url) }
        if let url = imageUrl3 { imageUrls.append(url) }
        
        return CardViewModel(imageNames: imageUrls,
                             attributedString: attributedText,
                             textAlignment: .left)
    }
}
