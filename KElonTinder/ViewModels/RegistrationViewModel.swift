//
//  RegistrationViewModel.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/07.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    // Reactive Programming
    var bindableIsRegistering = Bindable<Bool>()
    var bindableIsFormValid = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()

    var fullName: String? { didSet { checkFormValidty() } }
    var email: String? { didSet { checkFormValidty() } }
    var password: String? { didSet { checkFormValidty() } }
    
    func performregistration(completion: @escaping (Error?) -> ()) {
        guard
            let email = email,
            let password = password
            else { return }
        
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email,
                               password: password) { (res, err) in
                                if let err = err {
                                    print(err)
                                    completion(err)
                                    return
                                }
                                
                                print("Successfully registered user: \(res?.user.uid ?? "")")
                                self.saveImageToFirebase(completion: completion)
        }
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        
        ref.putData(imageData,
                    metadata: nil) { (_, err) in
                        
                        if let err = err {
                            completion(err)
                            return
                        }
                        
                        print("Finished uploading image to storage")
                        ref.downloadURL { (url, err) in
                            if let err = err {
                                completion(err)
                                return
                            }
                            
                            self.bindableIsRegistering.value = false
                            print("Download url of our image is : \(url?.absoluteURL)")
                            
                            let imageUrl = url?.absoluteString ?? ""
                            self.saveInfoToFiresotre(imageUrl: imageUrl,completion: completion)
                        }
        }
    }
    
    fileprivate func saveInfoToFiresotre(imageUrl: String, completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let documentData = ["fullName": fullName ?? "",
                            "uid": uid,
                            "imageUrl1": imageUrl,
                            "minSeekingAge": 0,
                            "maxSeekingAge": 100] as [String : Any]
        Firestore.firestore().collection("users").document(uid).setData(documentData) { err in
            if let err = err {
                completion(err)
                return
            }
            
            print("Success save user info to firestore")
            completion(nil)
        }
    }
    
    func checkFormValidty() {
        let isFormValid = fullName?.isEmpty == false
            && email?.isEmpty == false
            && password?.isEmpty == false
            && bindableImage.value != nil
        bindableIsFormValid.value = isFormValid
    }
}
