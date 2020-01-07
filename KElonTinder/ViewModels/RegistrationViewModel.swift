//
//  RegistrationViewModel.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/07.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    var fullName: String? { didSet { checkFormValidty() }}
    var email: String? { didSet { checkFormValidty() }}
    var password: String? { didSet { checkFormValidty() }}
    
    fileprivate func checkFormValidty() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
    
    // Reactive Programming
    var isFormValidObserver: ((Bool) -> ())?
}
