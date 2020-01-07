//
//  RegistrationViewModel.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/07.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    //replace both of them
    //var image: UIImage? { didSet { imageObserver?(image) } }
    //var imageObserver: ((UIImage?) -> ())?

    var fullName: String? { didSet { checkFormValidty() } }
    var email: String? { didSet { checkFormValidty() } }
    var password: String? { didSet { checkFormValidty() } }
    
    fileprivate func checkFormValidty() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
        //isFormValidObserver?(isFormValid)
    }
    
    var bindableIsFormValid = Bindable<Bool>()
    // Reactive Programming
    //var isFormValidObserver: ((Bool) -> ())?
}
