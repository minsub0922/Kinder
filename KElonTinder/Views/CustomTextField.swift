//
//  CustomTextField.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/07.
//  Copyright © 2020 최민섭. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
    
    private let padding: CGFloat
    
    init(padding: CGFloat) {
        self.padding = padding
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // input space padding
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
}
