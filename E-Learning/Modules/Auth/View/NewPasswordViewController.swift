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
    
    
    var isPasswordVisible = true
    var isConfirePasswordVisible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        
        self.navigationItem.title = "New password".localized
        let backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(cancelTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
        
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
        newPasswordTextField.rightView = eyeButton
        newPasswordTextField.rightViewMode = .always
        
        confireEyeButton = UIButton(type: .custom)
        confireEyeButton.setImage(UIImage(named: "view")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        confireEyeButton.translatesAutoresizingMaskIntoConstraints = false
        confireEyeButton.addTarget(self, action: #selector(toggleConfirePasswordVisibility), for: .touchUpInside)
        confirmNewPasswordTextField.rightView = confireEyeButton
        confirmNewPasswordTextField.rightViewMode = .always
        
        
        saveButton = UIButton(type: .system)
        saveButton.setTitle("Save".localized, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.backgroundColor = UIColor(named: "myCustom")
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
        print("Save")
        let nextViewController = ViewController()
        let navigationController = UINavigationController(rootViewController: nextViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    
    @objc func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        
        newPasswordTextField.isSecureTextEntry = !isPasswordVisible
        print("Password visibility: \(isPasswordVisible)")
        let iconName = isPasswordVisible ? "view" : "hide"
        let iconImage = UIImage(named: iconName)?.withTintColor(UIColor(named: "myCustom") ?? .red, renderingMode: .alwaysOriginal)
        eyeButton.setImage(iconImage, for: .normal)
    }
    
    
    @objc func toggleConfirePasswordVisibility() {
        isConfirePasswordVisible.toggle()
        
        confirmNewPasswordTextField.isSecureTextEntry = !isConfirePasswordVisible
        print("Password visibility: \(isPasswordVisible)")
        let iconName = isConfirePasswordVisible ? "view" : "hide"
        let iconImage = UIImage(named: iconName)?.withTintColor(UIColor(named: "myCustom") ?? .red, renderingMode: .alwaysOriginal)
        confireEyeButton.setImage(iconImage, for: .normal)
    }
    
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
