//
//  UIViewExt.swift
//  FirebaseApp
//
//  Created by Roman Litvinovich on 08/11/2023.
//

import UIKit

extension UIView {
    func cornerRadius () {
        layer.cornerRadius = 25
        layer.masksToBounds = true
    }
    
    func capsuleCornerRadius() {
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
    }
    
    func setShadow() {
        let shadowContainerView = UIView(frame: frame)
        shadowContainerView.backgroundColor = UIColor.clear
        shadowContainerView.layer.cornerRadius = layer.cornerRadius
        shadowContainerView.layer.shadowColor = UIColor.black.cgColor
        shadowContainerView.layer.shadowOpacity = 0.5
        shadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        shadowContainerView.layer.shadowRadius = 5
        
        superview?.insertSubview(shadowContainerView, belowSubview: self)
        shadowContainerView.addSubview(self)
    }
}
