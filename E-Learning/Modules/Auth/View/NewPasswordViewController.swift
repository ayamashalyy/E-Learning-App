//
//  NewPasswordViewController.swift
//  E-Learning
//
//  Created by aya on 25/11/2024.
//

import UIKit
import MaterialComponents

class NewPasswordViewController: UIViewController, UITextFieldDelegate {
    
    var newPasswordTextField: MDCTextField!
    var newPasswordController: MDCTextInputControllerOutlined!
    var eyeButton: UIButton!
    var confireEyeButton: UIButton!
    var confirmNewPasswordTextField: MDCTextField!
    var confirmNewPasswordController: MDCTextInputControllerOutlined!
    var saveButton: UIButton!
    var tenantViewModel = TenantViewModel.shared
    var backButtonImage: UIImage!
    var isPasswordVisible = true
    var isConfirePasswordVisible = true
    var viewModel = ResetPasswordViewModel()
    var email: String = ""
    var otp: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        newPasswordTextField.delegate = self
        confirmNewPasswordTextField.delegate = self
        self.navigationItem.title = "New password".localized
        
        backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        
        if let backButtonImage = backButtonImage {
            let tintedImage = backButtonImage.withTintColor(tenantViewModel.primaryColor ?? .blue, renderingMode: .alwaysOriginal)
            let backButton = UIBarButtonItem(image: tintedImage, style: .plain, target: self, action: #selector(cancelTapped))
            self.navigationItem.leftBarButtonItem = backButton
        }
    }
    
    func setupViews() {
        
        newPasswordTextField = MDCTextField()
        newPasswordTextField.font = UIFont(name: "Roboto-Medium", size: 14)
        newPasswordTextField.textColor = .lightGray
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newPasswordTextField)
        
        
        newPasswordController = MDCTextInputControllerOutlined(textInput: newPasswordTextField)
        newPasswordController.placeholderText = "New password".localized
        newPasswordController.normalColor = .lightGray
        newPasswordController.activeColor = .lightGray
        newPasswordController.floatingPlaceholderActiveColor = .black
        newPasswordController.floatingPlaceholderScale = 0.8
        newPasswordController.borderRadius = 8
        
        confirmNewPasswordTextField = MDCTextField()
        confirmNewPasswordTextField.font = UIFont(name: "Roboto-Medium", size: 14)
        confirmNewPasswordTextField.textColor = .lightGray
        confirmNewPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmNewPasswordTextField)
        
        
        confirmNewPasswordController = MDCTextInputControllerOutlined(textInput: confirmNewPasswordTextField)
        confirmNewPasswordController.placeholderText = "Confirm new password".localized
        confirmNewPasswordController.normalColor = .lightGray
        confirmNewPasswordController.activeColor = .lightGray
        confirmNewPasswordController.floatingPlaceholderActiveColor = .black
        confirmNewPasswordController.floatingPlaceholderScale = 0.8
        confirmNewPasswordController.borderRadius = 8
        
        eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(named: "view")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        eyeButton.tintColor = tenantViewModel.primaryColor ?? .red
        newPasswordTextField.rightView = eyeButton
        newPasswordTextField.rightViewMode = .always
        
        confireEyeButton = UIButton(type: .custom)
        confireEyeButton.setImage(UIImage(named: "view")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        confireEyeButton.translatesAutoresizingMaskIntoConstraints = false
        confireEyeButton.addTarget(self, action: #selector(toggleConfirePasswordVisibility), for: .touchUpInside)
        confireEyeButton.tintColor = tenantViewModel.primaryColor ?? .red
        confirmNewPasswordTextField.rightView = confireEyeButton
        confirmNewPasswordTextField.rightViewMode = .always
        
        
        saveButton = UIButton(type: .system)
        saveButton.setTitle("Save".localized, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.backgroundColor = tenantViewModel.primaryColor
        saveButton.layer.cornerRadius = 25
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            newPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newPasswordTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            newPasswordTextField.widthAnchor.constraint(equalToConstant: 340),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 60)
            
        ])
        
        NSLayoutConstraint.activate([
            confirmNewPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmNewPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 20),
            confirmNewPasswordTextField.widthAnchor.constraint(equalToConstant: 340),
            confirmNewPasswordTextField.heightAnchor.constraint(equalToConstant: 60)
            
        ])
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: confirmNewPasswordTextField.bottomAnchor, constant: 60),
            saveButton.widthAnchor.constraint(equalToConstant: 340),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func saveButtonTapped() {
        guard let newPassword = newPasswordTextField.text, !newPassword.isEmpty,
              let confirmPassword = confirmNewPasswordTextField.text, !confirmPassword.isEmpty else {
            
            if newPasswordTextField.text?.isEmpty ?? true {
                newPasswordController.setErrorText("Please enter a new password.", errorAccessibilityValue: nil)
            }
            if confirmNewPasswordTextField.text?.isEmpty ?? true {
                confirmNewPasswordController.setErrorText("Please confirm your new password.", errorAccessibilityValue: nil)
            }
            
            return
        }
        
        if newPassword.count < 8 {
            newPasswordController.setErrorText("Password must be at least 8 characters.", errorAccessibilityValue: nil)
            return
        }
        
        if !viewModel.validatePasswords(password: newPassword, confirmPassword: confirmPassword) {
            confirmNewPasswordController.setErrorText("Passwords do not match.", errorAccessibilityValue: nil)
            return
        }
        
        UserDefaults.standard.set(email, forKey: UserDefaultsKeys.rememberEmail)
        UserDefaults.standard.set(newPassword, forKey: UserDefaultsKeys.newPassword)
        
        viewModel.resetPassword(email: email, otp: otp, password: newPassword, passwordConfirmation: confirmPassword) { [weak self] message in
            guard let self = self else { return }
            
            if let message = message {
                print(message)
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self.navigateToNextScreen()
                    })
                    self.present(alert, animated: true)
                }
            } else {
                self.showAlert(title: "Error", message: "Failed to reset password. Please try again.")
            }
        }
    }
    
    private func navigateToNextScreen() {
        let nextViewController = LoginViewController()
        nextViewController.modalPresentationStyle = .fullScreen
        present(nextViewController, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == newPasswordTextField {
            newPasswordController.setErrorText(nil, errorAccessibilityValue: nil)
        } else if textField == confirmNewPasswordTextField {
            confirmNewPasswordController.setErrorText(nil, errorAccessibilityValue: nil)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        
        newPasswordTextField.isSecureTextEntry = !isPasswordVisible
        print("Password visibility: \(isPasswordVisible)")
        let iconName = isPasswordVisible ? "view" : "hide"
        let iconImage = UIImage(named: iconName)
        eyeButton.setImage(iconImage, for: .normal)
    }
    
    
    @objc func toggleConfirePasswordVisibility() {
        isConfirePasswordVisible.toggle()
        
        confirmNewPasswordTextField.isSecureTextEntry = !isConfirePasswordVisible
        print("Password visibility: \(isPasswordVisible)")
        let iconName = isConfirePasswordVisible ? "view" : "hide"
        let iconImage = UIImage(named: iconName)
        confireEyeButton.setImage(iconImage, for: .normal)
    }
    
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
