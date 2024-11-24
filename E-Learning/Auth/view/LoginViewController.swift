//
//  LoginViewController.swift
//  E-Learning
//
//  Created by aya on 24/11/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    var organizationNameText: UILabel!
    var welcomeBackText: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var goToYourOrgaizationButton: UIButton!
    var eyeButton: UIButton!
    var rememberMeCheckbox: UIButton!
    var rememberMeLabel: UILabel!
    var forgetPasswordButton: UIButton!
    var alreadyHaveAccountLabel: UILabel!
    var loginButton: UIButton!
    
    
    var isPasswordVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        
    }
    
    
    func setupViews() {
        
        organizationNameText = UILabel()
        organizationNameText.text = "Vinsys Academy"
        organizationNameText.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        organizationNameText.textColor = UIColor(named: "myCustom")
        organizationNameText.textAlignment = .center
        organizationNameText.numberOfLines = 0
        organizationNameText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(organizationNameText)
        
        welcomeBackText = UILabel()
        welcomeBackText.text = " Welcome back!"
        welcomeBackText.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        welcomeBackText.textColor = UIColor(named: "second")
        welcomeBackText.textAlignment = .center
        welcomeBackText.numberOfLines = 0
        welcomeBackText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeBackText)
        
        emailTextField = UITextField()
        emailTextField.placeholder = "   Enter your email"
        emailTextField.font = UIFont.systemFont(ofSize: 14)
        emailTextField.borderStyle = .roundedRect
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextField)
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "   Enter your password"
        passwordTextField.font = UIFont.systemFont(ofSize: 14)
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.isSecureTextEntry = true
        view.addSubview(passwordTextField)
        
        eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        passwordTextField.rightView = eyeButton
        eyeButton.frame = CGRect(x: 50, y: 0, width: 100, height: 100)
        passwordTextField.rightViewMode = .always
        
        rememberMeCheckbox = UIButton(type: .custom)
        rememberMeCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
        rememberMeCheckbox.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        rememberMeCheckbox.tintColor = UIColor(named: "second")
        rememberMeCheckbox.translatesAutoresizingMaskIntoConstraints = false
        rememberMeCheckbox.addTarget(self, action: #selector(toggleRememberMe), for: .touchUpInside)
        view.addSubview(rememberMeCheckbox)
        
        rememberMeLabel = UILabel()
        rememberMeLabel.text = "Remember me"
        rememberMeLabel.font = UIFont.systemFont(ofSize: 14)
        rememberMeLabel.textColor = .darkGray
        rememberMeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rememberMeLabel)
        
        forgetPasswordButton = UIButton(type: .system)
        forgetPasswordButton.setTitle("Forget Password?", for: .normal)
        forgetPasswordButton.setTitleColor(UIColor(named: "myCustom"), for: .normal)
        forgetPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        forgetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgetPasswordButton.addTarget(self, action: #selector(forgetPasswordTapped), for: .touchUpInside)
        view.addSubview(forgetPasswordButton)
        
        
        goToYourOrgaizationButton = UIButton(type: .system)
        goToYourOrgaizationButton.setTitle("Login", for: .normal)
        goToYourOrgaizationButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        goToYourOrgaizationButton.setTitleColor(UIColor.white, for: .normal)
        goToYourOrgaizationButton.backgroundColor = UIColor(named: "myCustom")
        goToYourOrgaizationButton.layer.cornerRadius = 25
        goToYourOrgaizationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goToYourOrgaizationButton)
        goToYourOrgaizationButton.addTarget(self, action: #selector(goToYourOrgaizationButtonTapped), for: .touchUpInside)
        
        alreadyHaveAccountLabel = UILabel()
        alreadyHaveAccountLabel.text = "Already have an account?"
        alreadyHaveAccountLabel.font = UIFont.systemFont(ofSize: 14)
        alreadyHaveAccountLabel.textColor = .gray
        alreadyHaveAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alreadyHaveAccountLabel)
        
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Log in", for: .normal)
        loginButton.setTitleColor(UIColor(named: "myCustom"), for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            organizationNameText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            organizationNameText.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            organizationNameText.widthAnchor.constraint(equalToConstant: 300)
            
        ])
        
        NSLayoutConstraint.activate([
            welcomeBackText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeBackText.topAnchor.constraint(equalTo: organizationNameText.bottomAnchor, constant: 15),
            welcomeBackText.widthAnchor.constraint(equalToConstant: 300)
            
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: welcomeBackText.bottomAnchor, constant: 40),
            emailTextField.widthAnchor.constraint(equalToConstant: 340),
            emailTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 340),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            rememberMeCheckbox.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            rememberMeCheckbox.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            rememberMeCheckbox.widthAnchor.constraint(equalToConstant: 20),
            rememberMeCheckbox.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            rememberMeLabel.leadingAnchor.constraint(equalTo: rememberMeCheckbox.trailingAnchor, constant: 10),
            rememberMeLabel.centerYAnchor.constraint(equalTo: rememberMeCheckbox.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            forgetPasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            forgetPasswordButton.centerYAnchor.constraint(equalTo: rememberMeCheckbox.centerYAnchor)
        ])
        
        
        
        
        NSLayoutConstraint.activate([
            goToYourOrgaizationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToYourOrgaizationButton.topAnchor.constraint(equalTo: forgetPasswordButton.bottomAnchor, constant: 30),
            goToYourOrgaizationButton.widthAnchor.constraint(equalToConstant: 340),
            goToYourOrgaizationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            alreadyHaveAccountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alreadyHaveAccountLabel.topAnchor.constraint(equalTo: goToYourOrgaizationButton.bottomAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: alreadyHaveAccountLabel.trailingAnchor, constant: 5),
            loginButton.centerYAnchor.constraint(equalTo: alreadyHaveAccountLabel.centerYAnchor)
        ])
        
        
    }
    
    @objc func goToYourOrgaizationButtonTapped() {
        let nextViewController = ViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        let iconName = isPasswordVisible ? "eye" : "eye.slash"
        let iconImage = UIImage(systemName: iconName)
        eyeButton.setImage(iconImage?.withTintColor(UIColor(named: "myCustom") ?? .red), for: .normal)
    }
    
    @objc func toggleRememberMe() {
        rememberMeCheckbox.isSelected.toggle()
        print("Remember Me: \(rememberMeCheckbox.isSelected)")
    }
    
    @objc func forgetPasswordTapped() {
        print("Forget Password? tapped")
        
    }
    
    @objc func loginButtonTapped() {
        print("Log in button tapped")
        //        let nextViewController = ViewController()
        //        navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    
    
    
    
}

