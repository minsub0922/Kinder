//
//  Firebase+Utils.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/08.
//  Copyright © 2020 최민섭. All rights reserved.
//


import Firebase

extension Firestore {
    func fetchCurrentUser(completion: @escaping (User?, Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            
            // fetched our user here
            guard let dictionary = snapshot?.data() else {
                let error = NSError(domain: "com.lbta.swipematch", code: 500, userInfo: [NSLocalizedDescriptionKey: "No user found in Firestore"])
                completion(nil, error)
                return
            }
            let user = User(dictionary: dictionary)
            completion(user, nil)
        }
    }
}
