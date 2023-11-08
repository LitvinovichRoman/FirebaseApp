//
//  LoginViewController.swift
//  FirebaseApp
//
//  Created by Roman Litvinovich on 08/11/2023.
//

import UIKit
import Lottie
import FirebaseDatabaseInternal
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    var ref: DatabaseReference!

    
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak private var loginSubView: UIView!
    @IBOutlet weak private var passwordSubView: UIView!
    @IBOutlet weak private var subView: UIView!
    @IBOutlet weak var animationSub: UIView!
    @IBOutlet weak var registrationSub: UIView!
    @IBOutlet weak private var loginButton: UIButton!
    @IBOutlet weak private var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "users")

        setupUI()
    }
    
    @IBAction func registrationButtonAction(){
        let registrationVC = RegistrationViewController()
        self.present(registrationVC, animated: true, completion: nil)
    }
    
    private func setupUI() {
        setupLottieAnimation()
        loginSubView.capsuleCornerRadius()
        passwordSubView.capsuleCornerRadius()
        registrationSub.cornerRadius()
        registrationSub.setShadow()
        subView.cornerRadius()
        subView.setShadow()
        loginButton.capsuleCornerRadius()
    }
    
    private func setupLottieAnimation() {
        let lottieView = LottieAnimationView()
        let animation = LottieAnimation.named("note")
        lottieView.animation = animation
        lottieView.contentMode = .scaleAspectFit
        lottieView.loopMode = .loop
        lottieView.animationSpeed = 0.1
        lottieView.backgroundColor  = .clear

        lottieView.frame = animationSub.bounds
        lottieView.play()
        view.addSubview(lottieView)
        
        let imageView = UIImageView(frame: animationSub.bounds)
        imageView.addSubview(lottieView)
        
        animationSub.addSubview(imageView)
        lottieView.play()
    }

}
