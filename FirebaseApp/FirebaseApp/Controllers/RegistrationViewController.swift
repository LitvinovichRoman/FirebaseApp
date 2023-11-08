//
//  RegistrationViewController.swift
//  FirebaseApp
//
//  Created by Roman Litvinovich on 08/11/2023.
//

import UIKit
import Lottie
import FirebaseDatabaseInternal
import FirebaseAuth

class RegistrationViewController: UIViewController {

    var ref: DatabaseReference!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var emailSubView: UIView!
    @IBOutlet weak var passwordSubView: UIView!
    @IBOutlet weak var animationSubView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "users")
        setupUI()
    }

    @IBAction func registrationButtonAction() {
        guard let email = emailTextField.text,
              let pass = passwordTextField.text,
              !email.isEmpty,
              !pass.isEmpty
        else { return }
        
        Auth.auth().createUser(withEmail: email, password: pass) { [weak self] user, error in
            if let error = error {
                print(error)
            } else if let user = user {
                let userRef = self?.ref.child(user.user.uid)
                userRef?.setValue(["email": user.user.email])
            }
        }
    }
    
    private func setupUI(){
        setupLottieAnimation()
        subView.cornerRadius()
        subView.setShadow()
        emailSubView.capsuleCornerRadius()
        passwordSubView.capsuleCornerRadius()
        registrationButton.capsuleCornerRadius()
    }
    
    private func setupLottieAnimation() {
        let lottieView = LottieAnimationView()
        let animation = LottieAnimation.named("pancil")
        lottieView.animation = animation
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 0.1
        lottieView.backgroundColor  = .clear

        lottieView.frame = animationSubView.bounds
        lottieView.play()
        view.addSubview(lottieView)
        
        let imageView = UIImageView(frame: animationSubView.bounds)
        imageView.addSubview(lottieView)
        
        animationSubView.addSubview(imageView)
        lottieView.play()
    }
    

}
