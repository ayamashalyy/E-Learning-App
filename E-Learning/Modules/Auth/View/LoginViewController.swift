//
//  LoginViewController.swift
//  E-Learning
//
//  Created by aya on 24/11/2024.
//

import UIKit
import MaterialComponents

class LoginViewController: UIViewController , UITextFieldDelegate{
    
    var organizationNameText: UILabel!
    var welcomeBackText: UILabel!
    var emailTextField: MDCTextField!
    var emailController: MDCTextInputControllerOutlined!
    var passwordTextField: MDCTextField!
    var passwordController: MDCTextInputControllerOutlined!
    var goToYourOrgaizationButton: UIButton!
    var eyeButton: UIButton!
    var rememberMeCheckbox: UIButton!
    var rememberMeLabel: UILabel!
    var forgetPasswordButton: UIButton!
    var alreadyHaveAccountLabel: UILabel!
    var loginButton: UIButton!
    var loginViewModel = LoginViewModel()
    private let refreshTokenViewModel = RefreshTokenViewModel()
    
    var isPasswordVisible = true
    var tenantViewModel = TenantViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        checkRememberedUser()
    }
    
    
    func setupViews() {
        
        organizationNameText = UILabel()
        //organizationNameText.text = "Vinsys Academy".localized
        organizationNameText.text = tenantViewModel.organizationName
        organizationNameText.font = UIFont(name: "Roboto-Bold", size: 24)
        organizationNameText.textColor = tenantViewModel.primaryColor
        organizationNameText.textAlignment = .center
        organizationNameText.numberOfLines = 0
        organizationNameText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(organizationNameText)
        
        welcomeBackText = UILabel()
        welcomeBackText.text = "Welcome back!".localized
        welcomeBackText.font = UIFont(name: "Roboto-Medium", size: 16)
        welcomeBackText.textColor = tenantViewModel.secondaryColor
        welcomeBackText.textAlignment = .center
        welcomeBackText.numberOfLines = 0
        welcomeBackText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeBackText)
        
        emailTextField = MDCTextField()
        emailTextField.font = UIFont(name: "Roboto-Medium", size: 14)
        emailTextField.textColor = .lightGray
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextField)
        
        
        emailController = MDCTextInputControllerOutlined(textInput: emailTextField)
        emailController.placeholderText = "Email".localized
        emailController.normalColor = .lightGray
        emailController.activeColor = .lightGray
        emailController.floatingPlaceholderActiveColor = .black
        emailController.floatingPlaceholderScale = 0.8
        emailController.borderRadius = 8
        
        
        passwordTextField = MDCTextField()
        passwordTextField.font = UIFont(name: "Roboto-Medium", size: 14)
        passwordTextField.textColor = .lightGray
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)
        
        
        passwordController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        passwordController.placeholderText = "Password".localized
        passwordController.normalColor = .lightGray
        passwordController.activeColor = .lightGray
        passwordController.floatingPlaceholderActiveColor = .black
        passwordController.floatingPlaceholderScale = 0.8
        passwordController.borderRadius = 8
        
        
        eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(named: "view")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.tintColor = tenantViewModel.primaryColor ?? .red
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        passwordTextField.rightView = eyeButton
        passwordTextField.rightViewMode = .always
        
        rememberMeCheckbox = UIButton(type: .custom)
        rememberMeCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
        rememberMeCheckbox.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        rememberMeCheckbox.tintColor = tenantViewModel.secondaryColor
        rememberMeCheckbox.translatesAutoresizingMaskIntoConstraints = false
        rememberMeCheckbox.addTarget(self, action: #selector(toggleRememberMe), for: .touchUpInside)
        view.addSubview(rememberMeCheckbox)
        
        rememberMeLabel = UILabel()
        rememberMeLabel.text = "Remember me".localized
        rememberMeLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        rememberMeLabel.textColor = .darkGray
        rememberMeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rememberMeLabel)
        
        forgetPasswordButton = UIButton(type: .system)
        forgetPasswordButton.setTitle("Forget Password?".localized, for: .normal)
        forgetPasswordButton.setTitleColor(tenantViewModel.primaryColor, for: .normal)
        forgetPasswordButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 12)
        forgetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgetPasswordButton.addTarget(self, action: #selector(forgetPasswordTapped), for: .touchUpInside)
        view.addSubview(forgetPasswordButton)
        
        
        goToYourOrgaizationButton = UIButton(type: .system)
        goToYourOrgaizationButton.setTitle("Login".localized, for: .normal)
        goToYourOrgaizationButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        goToYourOrgaizationButton.setTitleColor(UIColor.white, for: .normal)
        goToYourOrgaizationButton.backgroundColor = tenantViewModel.primaryColor
        goToYourOrgaizationButton.layer.cornerRadius = 25
        goToYourOrgaizationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goToYourOrgaizationButton)
        goToYourOrgaizationButton.addTarget(self, action: #selector(goToYourOrgaizationButtonTapped), for: .touchUpInside)
        
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
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            emailController.setErrorText(nil, errorAccessibilityValue: nil)
        } else if textField == passwordTextField {
            passwordController.setErrorText(nil, errorAccessibilityValue: nil)
        }
    }
    
    @objc func goToYourOrgaizationButtonTapped() {
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            if emailTextField.text?.isEmpty == true && passwordTextField.text?.isEmpty == true {
                showAlert(message: "Please enter your email address & password.")
            } else if emailTextField.text?.isEmpty == true {
                showAlert(message: "Please enter your email address.")
            } else if passwordTextField.text?.isEmpty == true {
                showAlert(message: "Please enter your password.")
            }
            return
        }
        
        guard loginViewModel.isValidEmail(email) else {
            emailController.setErrorText("Invalid email address.", errorAccessibilityValue: nil)
            return
        }
        
        guard loginViewModel.isValidPassword(password) else {
            passwordController.setErrorText("Password must be at least 8 characters.", errorAccessibilityValue: nil)
            return
        }
        
        if rememberMeCheckbox.isSelected {
            UserDefaults.standard.set(email, forKey: UserDefaultsKeys.userEmail)
            UserDefaults.standard.set(password, forKey: UserDefaultsKeys.newPassword)
        }else {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userEmail)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.newPassword)
        }
        
        loginViewModel.email = email
        loginViewModel.password = password
        
        loginViewModel.login { [weak self] response in
            print("Response: \(String(describing: response))")
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let token = response?.token, let role = response?.role {
                    UserDefaults.standard.set(token, forKey: UserDefaultsKeys.userToken)
                    UserSessionManager.shared.token = token
                    print("DEBUG: Role received from API = \(role)")
                    let alert = UIAlertController(title: "Success", message: response?.message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        print("DEBUG: Checking role condition, role = \(role)")
                        if role == "learner" {
                            print("DEBUG: Navigating to Learner Screen")
                            self.navigateToLearnerScreen()
                        } else if role == "manager" {
                            print("DEBUG: Navigating to Manager Screen")
                            self.navigateToManagerScreen()
                        } else {
                            print("DEBUG: Unknown role: \(role)")
                        }
                    })
                    print("Login successful, token: \(token), role: \(role)")
                    self.present(alert, animated: true, completion: nil)
                }else {
                    self.showAlert(message: "Login failed: \(response?.message ?? "")")
                }
            }
        }
    }
    
    
    
    func checkRememberedUser() {
        if let savedEmail = UserDefaults.standard.string(forKey: UserDefaultsKeys.userEmail),
           let savedPassword = UserDefaults.standard.string(forKey: UserDefaultsKeys.newPassword),
           rememberMeCheckbox.isSelected {
            emailTextField.text = savedEmail
            passwordTextField.text = savedPassword
        } else {
            emailTextField.text = ""
            passwordTextField.text = ""
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToLearnerScreen() {
        let learnerViewController = TabBarViewController()
        learnerViewController.modalPresentationStyle = .fullScreen
        present(learnerViewController, animated: true, completion: nil)
    }
    
    private func navigateToManagerScreen() {
        print("DEBUG: Inside navigateToManagerScreen")
        let managerViewController = CourseManagerViewController()
        let navigationController = UINavigationController(rootViewController: managerViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        print("Password visibility: \(isPasswordVisible)")
        let iconName = isPasswordVisible ? "view" : "hide"
        if let iconImage = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate) {
            eyeButton.setImage(iconImage, for: .normal)
            
        }
    }
    
    @objc func toggleRememberMe() {
        rememberMeCheckbox.isSelected.toggle()
        print("Remember Me: \(rememberMeCheckbox.isSelected)")
    }
    
    @objc func forgetPasswordTapped() {
        print("Forget Password? tapped")
        
        let nextViewController = ForgetPasswordViewController()
        let navigationController = UINavigationController(rootViewController: nextViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

