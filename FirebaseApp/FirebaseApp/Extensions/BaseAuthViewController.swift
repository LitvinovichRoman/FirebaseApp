//
//  RegistrationVCExt.swift
//  FirebaseApp
//
//  Created by Roman Litvinovich on 09/11/2023.
//

import UIKit
import Lottie
import FirebaseDatabaseInternal
import FirebaseAuth

class BaseAuthViewController: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle!
    
    func displayWarning(withText text: String) {
        let alertController = UIAlertController(title: "Warning", message: text, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Back", style: .cancel)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func setupLottieAnimation(forView view: UIView, animationName: String, animationSpeed: CGFloat) {
        let lottieView = LottieAnimationView()
        let animation = LottieAnimation.named(animationName)
        lottieView.animation = animation
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        lottieView.animationSpeed = animationSpeed
        lottieView.backgroundColor = .clear
        
        lottieView.frame = view.bounds
        lottieView.play()
        view.addSubview(lottieView)
    }
    

}
