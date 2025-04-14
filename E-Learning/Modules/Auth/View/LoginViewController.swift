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
    var emailTextField: FloatingLabelTextFieldView!
    var passwordTextField: FloatingLabelTextFieldView!
    var goToYourOrganizationButton: UIButton!
    var eyeButton: UIButton!
    var rememberMeCheckbox: UIButton!
    var rememberMeLabel: UILabel!
    var forgetPasswordButton: UIButton!
    var loginViewModel = LoginViewModel()
    private let refreshTokenViewModel = RefreshTokenViewModel()
    
    var isPasswordVisible = false
    var tenantViewModel = TenantViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        checkRememberedUser()
    }
    
    func setupViews() {
        organizationNameText = UILabel()
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
        
        emailTextField = FloatingLabelTextFieldView()
        emailTextField.setLabelText("Email".localized)
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.onTextFieldShouldReturn = { [weak self] in
            print("emailTextField should return")
            self?.passwordTextField.textField.becomeFirstResponder()
            return true
        }
        
        
        let emailClearButton = UIButton(type: .custom)
        emailClearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        emailClearButton.tintColor = .lightGray
        emailClearButton.addTarget(self, action: #selector(clearTextField(_:)), for: .touchUpInside)
        emailClearButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let isRTL = UIView.userInterfaceLayoutDirection(for: view.semanticContentAttribute) == .rightToLeft
        if isRTL {
            emailTextField.textField.leftView = emailClearButton
            emailTextField.textField.leftViewMode = .whileEditing
        } else {
            emailTextField.textField.rightView = emailClearButton
            emailTextField.textField.rightViewMode = .whileEditing
        }
        
        view.addSubview(emailTextField)
        
        passwordTextField = FloatingLabelTextFieldView()
        passwordTextField.setLabelText("Password".localized)
        passwordTextField.textField.isSecureTextEntry = true
        passwordTextField.textField.keyboardType = .default
        passwordTextField.textField.autocapitalizationType = .none
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField.onTextFieldShouldReturn = { [weak self] in
            guard let self = self else { return true }
            print("passwordTextField should return called")
            if let email = emailTextField.textField.text, !email.isEmpty,
               let password = passwordTextField.textField.text, !password.isEmpty {
                print("Both fields filled, calling goToYourOrganizationButtonTapped")
                passwordTextField.textField.resignFirstResponder()
                goToYourOrganizationButtonTapped()
            } else {
                print("Fields empty, resigning first responder")
                passwordTextField.textField.resignFirstResponder()
            }
            return true
        }
        
        let passwordClearButton = UIButton(type: .custom)
        passwordClearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        passwordClearButton.tintColor = .lightGray
        passwordClearButton.addTarget(self, action: #selector(clearTextField(_:)), for: .touchUpInside)
        passwordClearButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        if isRTL {
            passwordTextField.textField.leftView = passwordClearButton
            passwordTextField.textField.leftViewMode = .whileEditing
        } else {
            passwordTextField.textField.rightView = passwordClearButton
            passwordTextField.textField.rightViewMode = .whileEditing
        }
        view.addSubview(passwordTextField)
        
        eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(named: "hide")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        eyeButton.tintColor = tenantViewModel.primaryColor ?? .red
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        passwordTextField.textField.rightView = eyeButton
        passwordTextField.textField.rightViewMode = .always
        
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
        
        goToYourOrganizationButton = UIButton(type: .system)
        goToYourOrganizationButton.setTitle("Login".localized, for: .normal)
        goToYourOrganizationButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        goToYourOrganizationButton.setTitleColor(UIColor.white, for: .normal)
        goToYourOrganizationButton.backgroundColor = tenantViewModel.primaryColor
        goToYourOrganizationButton.layer.cornerRadius = 25
        goToYourOrganizationButton.translatesAutoresizingMaskIntoConstraints = false
        goToYourOrganizationButton.addTarget(self, action: #selector(goToYourOrganizationButtonTapped), for: .touchUpInside)
        view.addSubview(goToYourOrganizationButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            organizationNameText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            organizationNameText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
            emailTextField.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 340),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56)
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
            goToYourOrganizationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToYourOrganizationButton.topAnchor.constraint(equalTo: forgetPasswordButton.bottomAnchor, constant: 50),
            goToYourOrganizationButton.widthAnchor.constraint(equalToConstant: 340),
            goToYourOrganizationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func goToYourOrganizationButtonTapped() {
        print("goToYourOrganizationButtonTapped called")
        guard let email = emailTextField.textField.text, !email.isEmpty,
              let password = passwordTextField.textField.text, !password.isEmpty else {
            print("Validation failed")
            if emailTextField.textField.text?.isEmpty == true && passwordTextField.textField.text?.isEmpty == true {
                showAlert(message: "Please enter your email address & password.")
            } else if emailTextField.textField.text?.isEmpty == true {
                showAlert(message: "Please enter your email address.")
            } else if passwordTextField.textField.text?.isEmpty == true {
                showAlert(message: "Please enter your password.")
            }
            return
        }
        
        guard loginViewModel.isValidEmail(email) else {
            print("Invalid email")
            showAlert(message: "Invalid email address.")
            return
        }
        
        guard loginViewModel.isValidPassword(password) else {
            print("Invalid password")
            showAlert(message: "Password must be at least 8 characters.")
            return
        }
        
        print("Validation passed, proceeding with login")
        if rememberMeCheckbox.isSelected {
            UserDefaults.standard.set(email, forKey: UserDefaultsKeys.userEmail)
            UserDefaults.standard.set(password, forKey: UserDefaultsKeys.newPassword)
        } else {
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userEmail)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.newPassword)
        }
        
        loginViewModel.email = email
        loginViewModel.password = password
        
        loginViewModel.login { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let token = response?.token, let role = response?.role {
                    UserDefaults.standard.set(token, forKey: UserDefaultsKeys.userToken)
                    UserSessionManager.shared.token = token
                    UserCredentialsManager.shared.newPassword = password
                    UserCredentialsManager.shared.confirmPassword = password
                    let alert = UIAlertController(title: "Success", message: response?.message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        if role == "learner" {
                            self.navigateToLearnerScreen()
                        } else if role == "manager" {
                            self.navigateToManagerScreen()
                        }
                    })
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.showAlert(message: "Login failed: \(response?.message ?? "")")
                }
            }
        }
    }
    
    func checkRememberedUser() {
        if let savedEmail = UserDefaults.standard.string(forKey: UserDefaultsKeys.userEmail),
           let savedPassword = UserDefaults.standard.string(forKey: UserDefaultsKeys.newPassword),
           rememberMeCheckbox.isSelected {
            emailTextField.textField.text = savedEmail
            passwordTextField.textField.text = savedPassword
        } else {
            emailTextField.textField.text = ""
            passwordTextField.textField.text = ""
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
        let managerViewController = CourseManagerViewController()
        let navigationController = UINavigationController(rootViewController: managerViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        passwordTextField.textField.isSecureTextEntry = !isPasswordVisible
        let iconName = isPasswordVisible ? "view" : "hide"
        if let iconImage = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate) {
            eyeButton.setImage(iconImage, for: .normal)
        }
    }
    
    @objc func toggleRememberMe() {
        rememberMeCheckbox.isSelected.toggle()
    }
    
    @objc func forgetPasswordTapped() {
        print("Forget Password? tapped")
        let nextViewController = ForgetPasswordViewController()
        let navigationController = UINavigationController(rootViewController: nextViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func clearTextField(_ sender: UIButton) {
        if sender == emailTextField.textField.leftView || sender == emailTextField.textField.rightView {
            emailTextField.textField.text = ""
        } else if sender == passwordTextField.textField.leftView || sender == passwordTextField.textField.rightView {
            passwordTextField.textField.text = ""
        }
    }
}
