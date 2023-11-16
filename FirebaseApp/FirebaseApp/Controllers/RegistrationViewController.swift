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

class RegistrationViewController: BaseAuthViewController {
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var emailSubView: UIView!
    @IBOutlet weak var passwordSubView: UIView!
    @IBOutlet weak var animationSubView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupUI()
    }

    @IBAction func registrationButtonAction() {
        guard let email = emailTextField.text, !email.isEmpty,
              let pass = passwordTextField.text, !pass.isEmpty
        else {
            displayWarning(withText: "Info is incorect")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: pass) { [weak self] user, error in
            if let error = error {
                self?.displayWarning(withText: "Registration was is incorect \n \n \(error) \n ")
            } else if let user = user {
                let userRef = self?.ref.child(user.user.uid)
                userRef?.setValue(["email": user.user.email])
            }
        }
        
    }

    
    private func setupUI(){
        setupLottieAnimation(forView: animationSubView, animationName: "pencil", animationSpeed: 0.2)
        subView.cornerRadius()
        subView.setShadow()
        emailSubView.capsuleCornerRadius()
        passwordSubView.capsuleCornerRadius()
        registrationButton.capsuleCornerRadius()
    }
    
}



