//
//  NewPasswordViewController.swift
//  E-Learning
//
//  Created by aya on 25/11/2024.
//

import UIKit

class NewPasswordViewController: UIViewController, UITextFieldDelegate {
    
    var newPasswordTextField: FloatingLabelTextFieldView!
    var confirmNewPasswordTextField: FloatingLabelTextFieldView!
    var eyeButton: UIButton!
    var confireEyeButton: UIButton!
    var saveButton: UIButton!
    var tenantViewModel = TenantViewModel.shared
    var backButtonImage: UIImage!
    var isPasswordVisible = false
    var isConfirePasswordVisible = false
    var viewModel = ResetPasswordViewModel()
    var email: String = ""
    var otp: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        self.navigationItem.title = "New password".localized
        
        backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        
        if let backButtonImage = backButtonImage {
            let tintedImage = backButtonImage.withTintColor(tenantViewModel.primaryColor ?? .blue, renderingMode: .alwaysOriginal)
            let backButton = UIBarButtonItem(image: tintedImage, style: .plain, target: self, action: #selector(cancelTapped))
            self.navigationItem.leftBarButtonItem = backButton
        }
    }
    
    func setupViews() {
        
        newPasswordTextField = FloatingLabelTextFieldView()
        newPasswordTextField.setLabelText("New password".localized)
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.textField.autocapitalizationType = .none
        newPasswordTextField.textField.isSecureTextEntry = true
        newPasswordTextField.textField.keyboardType = .default
        
        newPasswordTextField.onTextFieldShouldReturn = { [weak self] in
            print("newPasswordTextField should return")
            self?.confirmNewPasswordTextField.textField.becomeFirstResponder()
            return true
        }
        
        let newPasswordClearButton = UIButton(type: .custom)
        newPasswordClearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        newPasswordClearButton.tintColor = .lightGray
        newPasswordClearButton.addTarget(self, action: #selector(clearTextField(_:)), for: .touchUpInside)
        newPasswordClearButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let isRTL = UIView.userInterfaceLayoutDirection(for: view.semanticContentAttribute) == .rightToLeft
        if isRTL {
            newPasswordTextField.textField.leftView = newPasswordClearButton
            newPasswordTextField.textField.leftViewMode = .whileEditing
        } else {
            newPasswordTextField.textField.rightView = newPasswordClearButton
            newPasswordTextField.textField.rightViewMode = .whileEditing
        }
        view.addSubview(newPasswordTextField)
        
        
        confirmNewPasswordTextField = FloatingLabelTextFieldView()
        confirmNewPasswordTextField.setLabelText("Confirm new password".localized)
        confirmNewPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmNewPasswordTextField.textField.autocapitalizationType = .none
        confirmNewPasswordTextField.textField.isSecureTextEntry = true
        confirmNewPasswordTextField.textField.keyboardType = .default
        
        confirmNewPasswordTextField.onTextFieldShouldReturn = { [weak self] in
            guard let self = self else { return true }
            print("confirmNewPasswordTextField should return called")
            if let newPassword = newPasswordTextField.textField.text, !newPassword.isEmpty,
               let confirmNewPassword = confirmNewPasswordTextField.textField.text, !confirmNewPassword.isEmpty {
                print("Both fields filled, calling saveButtonTapped")
                confirmNewPasswordTextField.textField.resignFirstResponder()
                saveButtonTapped()
            } else {
                print("Fields empty, resigning first responder")
                confirmNewPasswordTextField.textField.resignFirstResponder()
            }
            return true
        }
        
        
        let confirmNewPasswordClearButton = UIButton(type: .custom)
        confirmNewPasswordClearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        confirmNewPasswordClearButton.tintColor = .lightGray
        confirmNewPasswordClearButton.addTarget(self, action: #selector(clearTextField(_:)), for: .touchUpInside)
        confirmNewPasswordClearButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        if isRTL {
            confirmNewPasswordTextField.textField.leftView = confirmNewPasswordClearButton
            confirmNewPasswordTextField.textField.leftViewMode = .whileEditing
        } else {
            confirmNewPasswordTextField.textField.rightView = confirmNewPasswordClearButton
            confirmNewPasswordTextField.textField.rightViewMode = .whileEditing
        }
        view.addSubview(confirmNewPasswordTextField)
        
        
        eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(named: "hide")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        eyeButton.tintColor = tenantViewModel.primaryColor ?? .red
        newPasswordTextField.textField.rightView = eyeButton
        newPasswordTextField.textField.rightViewMode = .always
        
        confireEyeButton = UIButton(type: .custom)
        confireEyeButton.setImage(UIImage(named: "hide")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        confireEyeButton.translatesAutoresizingMaskIntoConstraints = false
        confireEyeButton.addTarget(self, action: #selector(toggleConfirePasswordVisibility), for: .touchUpInside)
        confireEyeButton.tintColor = tenantViewModel.primaryColor ?? .red
        confirmNewPasswordTextField.textField.rightView = confireEyeButton
        confirmNewPasswordTextField.textField.rightViewMode = .always
        
        
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
            newPasswordTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            newPasswordTextField.widthAnchor.constraint(equalToConstant: 340),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 56)
            
        ])
        
        NSLayoutConstraint.activate([
            confirmNewPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmNewPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 20),
            confirmNewPasswordTextField.widthAnchor.constraint(equalToConstant: 340),
            confirmNewPasswordTextField.heightAnchor.constraint(equalToConstant: 56)
            
        ])
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: confirmNewPasswordTextField.bottomAnchor, constant: 60),
            saveButton.widthAnchor.constraint(equalToConstant: 340),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func saveButtonTapped() {
        guard let newPassword = newPasswordTextField.textField.text, !newPassword.isEmpty,
              let confirmPassword = confirmNewPasswordTextField.textField.text, !confirmPassword.isEmpty else {
            
            if newPasswordTextField.textField.text?.isEmpty ?? true {
                showAlert(title: "Error", message: "Please enter a new password.")
            }
            if confirmNewPasswordTextField.textField.text?.isEmpty ?? true {
                showAlert(title: "Error", message: "Please confirm your new password.")
            }
            
            return
        }
        
        if newPassword.count < 8 {
            showAlert(title: "Error", message: "Password must be at least 8 characters.")
            return
        }
        
        if !viewModel.validatePasswords(password: newPassword, confirmPassword: confirmPassword) {
            showAlert(title: "Error", message: "Passwords do not match.")
            return
        }
        
        UserDefaults.standard.set(email, forKey: UserDefaultsKeys.userEmail)
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
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        
        newPasswordTextField.textField.isSecureTextEntry = !isPasswordVisible
        print("Password visibility: \(isPasswordVisible)")
        let iconName = isPasswordVisible ? "view" : "hide"
        let iconImage = UIImage(named: iconName)
        eyeButton.setImage(iconImage, for: .normal)
    }
    
    
    @objc func toggleConfirePasswordVisibility() {
        isConfirePasswordVisible.toggle()
        
        confirmNewPasswordTextField.textField.isSecureTextEntry = !isConfirePasswordVisible
        print("Password visibility: \(isPasswordVisible)")
        let iconName = isConfirePasswordVisible ? "view" : "hide"
        let iconImage = UIImage(named: iconName)
        confireEyeButton.setImage(iconImage, for: .normal)
    }
    
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func clearTextField(_ sender: UIButton) {
        if sender == newPasswordTextField.textField.leftView || sender == newPasswordTextField.textField.rightView {
            newPasswordTextField.textField.text = ""
        } else if sender == confirmNewPasswordTextField.textField.leftView || sender == confirmNewPasswordTextField.textField.rightView {
            confirmNewPasswordTextField.textField.text = ""
        }
    }
}
