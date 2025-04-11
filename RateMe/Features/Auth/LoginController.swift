//
//  LoginController.swift
//  RateMe
//
//  Created by Shamil Bayramli on 11.04.25.
//

import UIKit

class LoginController: UIViewController {
    
    private let headerView = AuthHeaderView(title: "Rate Me", subTitle: "Sign in to your account")
    
    private let emailField = AuthTextField(fieldType: .email)
    private let passwordField = AuthTextField(fieldType: .password)
    
    private let signInButton = AuthButton(title: "Sign In", hasBackground: true, fontSize: .big)
    private let newUserButton = AuthButton(title: "New User? Create Account.", fontSize: .med)
    private let forgotPasswordButton = AuthButton(title: "Forgot Password?", fontSize: .small)
    
    private let googleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.title = "Sign in with Google"
            config.image = UIImage(named: "google_logo")
            config.imagePadding = 10
            config.imagePlacement = .leading
            config.baseBackgroundColor = .white
            config.baseForegroundColor = .black
            config.cornerStyle = .medium
            
            button.configuration = config
        } else {
            // Fallback for iOS < 15
            button.setTitle("Sign in with Google", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.setImage(UIImage(named: "google_logo"), for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            button.backgroundColor = .white
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.cgColor
        }

        return button
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.setupUI()
        
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
        self.forgotPasswordButton.addTarget(self, action: #selector(didTapForgetPassword), for: .touchUpInside)
        self.googleSignInButton.addTarget(self, action: #selector(didTapGoogleSignIn), for: .touchUpInside)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        emailField.delegate = self
        emailField.tag = 0
        
        passwordField.delegate = self
        passwordField.tag = 1
        
        createDismissKeyboardTapGesture()
    }
    
    private func setupUI()
    {
        self.view.addSubview(headerView)
        
        // Text Fields
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        
        // Buttons
        self.view.addSubview(signInButton)
        self.view.addSubview(newUserButton)
        self.view.addSubview(forgotPasswordButton)
        
        self.view.addSubview(googleSignInButton)

        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Text Fields
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        // Buttons
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        newUserButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 270),
            
            self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.emailField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            self.passwordField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
            self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 55),
            self.signInButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 11),
            self.newUserButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.newUserButton.heightAnchor.constraint(equalToConstant: 44),
            self.newUserButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 1),
            self.forgotPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: 44),
            self.forgotPasswordButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.googleSignInButton.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 15),
            self.googleSignInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.googleSignInButton.heightAnchor.constraint(equalToConstant: 50),
            self.googleSignInButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85)

        ])
    }
    
    
    
    // Selectors
    @objc private func didTapSignIn()
    {
        let loginUserRequest = LoginUserRequest(email: emailField.text ?? "",
                                                password: passwordField.text ?? "")
        
        if loginUserRequest.email.isEmpty
        {
            presentMHAlertOnMainThread(title: "Invalid Email", message: "Email is not valid. Please try again.", buttonTitle: "Ok")
            return
        }
        
        if loginUserRequest.password.isEmpty
        {
            presentMHAlertOnMainThread(title: "Invalid Password", message: "Password is not valid. Please try again.", buttonTitle: "Ok")
            return
        }
        
        showLoadingView()
        AuthService.shared.signIn(with: loginUserRequest) { [weak self] error in
            guard let self = self else { return }
            if error != nil
            {
                presentMHAlertOnMainThread(title: "Login Error", message: "Login failed. Please try again.", buttonTitle: "Ok")
                self.dismissLoadingView()
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
            {
                DispatchQueue.main.async { [weak self] in
                    guard self != nil else { return }
                    sceneDelegate.checkAuth()
                }
            }
            
            self.dismissLoadingView()
        }
    }
    
    @objc private func didTapNewUser()
    {
        let vc = RegisterController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapForgetPassword()
    {
        let vc = ForgotPasswordController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapGoogleSignIn() {
        print("Google sign in button tapped")
        showLoadingView()
        
        Task {
            do {
                let success = await AuthService.shared.signInWithGoogle()
                if success {
                    if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                        DispatchQueue.main.async {
                            sceneDelegate.checkAuth()
                        }
                    }
                } else {
                    presentMHAlertOnMainThread(title: "Sign In Error", message: "Failed to sign in with Google. Please try again.", buttonTitle: "Ok")
                }
            } catch {
                presentMHAlertOnMainThread(title: "Sign In Error", message: "An error occurred during Google sign in. Please try again.", buttonTitle: "Ok")
            }
            dismissLoadingView()
        }
    }

    
    func createDismissKeyboardTapGesture()
    {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
           nextField.becomeFirstResponder()
        } else {

           textField.resignFirstResponder()
            didTapSignIn()
        }

        return false
    }
}

