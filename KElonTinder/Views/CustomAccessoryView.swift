//
//  CustomAccessoryView.swift
//  KElonTinder
//
//  Created by 최민섭 on 2020/01/26.
//  Copyright © 2020 최민섭. All rights reserved.
//

import LBTATools


class CustomInputAccessoryView: UIView {
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    let textView = UITextView()
    let sendButton = UIButton(title: "SEND",
                              titleColor: .black,
                              font: .boldSystemFont(ofSize: 14),
                              target: nil,
                              action: nil)
    let placeholderLabel = UILabel(text: "Enter Message",
                                   font: .systemFont(ofSize: 16),
                                   textColor: .lightGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //let redView = CustomInputAccessView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        backgroundColor = .white
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
        autoresizingMask = .flexibleHeight
        
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        hstack(textView,
               sendButton.withSize(.init(width: 60, height: 60)),
               alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: nil,
                                leading: leadingAnchor,
                                bottom: nil,
                                trailing: sendButton.leadingAnchor,
                                padding: .init(top: 0, left: 18, bottom: 0, right: 0))
        placeholderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
    }
    
    deinit {
        // prevent Retain Cycle
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func handleTextChange() {
        placeholderLabel.isHidden = textView.text.count != 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
