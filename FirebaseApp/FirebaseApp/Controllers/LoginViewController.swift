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
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle!

    
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak private var loginSubView: UIView!
    @IBOutlet weak private var passwordSubView: UIView!
    @IBOutlet weak private var subView: UIView!
    @IBOutlet weak var animationSub: UIView!
    @IBOutlet weak var registrationSub: UIView!
    @IBOutlet weak private var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        firebaseConfig()
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func loginButtonAction() {
        guard let email = emailTextField.text, !email.isEmpty,
              let pass = passwordTextField.text, !pass.isEmpty
        else {
            displayWarning(withText: "Info is incorect")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] user, error in
            if let error = error {
                self?.displayWarning(withText: "SignIn was incorect \n \n \(error)")
            } else if let _ = user {
            } else {
                self?.displayWarning(withText: "No such user")
            }
        }
    }
    
    @IBAction func registrationButtonAction(){
        let registrationVC = RegistrationViewController()
        self.present(registrationVC, animated: true, completion: nil)
    }
    
    private func firebaseConfig() {
        ref = Database.database().reference(withPath: "users")
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({[weak self] _, user in
            guard let _ = user  else { return }
            self?.performSegue(withIdentifier: "goToTasksTVC", sender: nil)
        })
    }
    
    private func displayWarning(withText text: String) {
        let alertController = UIAlertController(title: "Warning", message: text, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Back", style: .cancel)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    //MARK: - setupUI
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
    //MARK: - keyaboard config
    @objc private func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = 0
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y -= (keyboardSize.height / 2)
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
