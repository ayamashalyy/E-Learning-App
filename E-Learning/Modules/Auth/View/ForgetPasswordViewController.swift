//
//  ForgetPasswordViewController.swift
//  E-Learning
//
//  Created by aya on 25/11/2024.
//

import UIKit

class ForgetPasswordViewController: UIViewController, UITextFieldDelegate{
    
    var imageView: UIImageView!
    var ForgetPasswordText: UILabel!
    var descriptionForgetPasswordText: UITextView!
    var emailTextField: FloatingLabelTextFieldView!
    var getVerificationCodeButton: UIButton!
    var tenantViewModel = TenantViewModel.shared
    var backButtonImage: UIImage!
    var sendOTPViewModel = SendOTPViewModel.shared
    var loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        
        backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        
        if let backButtonImage = backButtonImage {
            let tintedImage = backButtonImage.withTintColor(tenantViewModel.primaryColor ?? .blue, renderingMode: .alwaysOriginal)
            let backButton = UIBarButtonItem(image: tintedImage, style: .plain, target: self, action: #selector(cancelTapped))
            self.navigationItem.leftBarButtonItem = backButton
        }
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupViews() {
        
        imageView = UIImageView()
        imageView.image = UIImage(named: "password")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        
        ForgetPasswordText = UILabel()
        ForgetPasswordText.text = "Forget Password!".localized
        ForgetPasswordText.font = UIFont(name: "Roboto-Bold", size: 24)
        ForgetPasswordText.textAlignment = .center
        ForgetPasswordText.textColor = tenantViewModel.primaryColor
        ForgetPasswordText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ForgetPasswordText)
        
        descriptionForgetPasswordText = UITextView()
        descriptionForgetPasswordText.text = "Please enter the email address associated with you account".localized
        descriptionForgetPasswordText.font = UIFont(name: "Roboto-Regular", size: 15)
        descriptionForgetPasswordText.textAlignment = .center
        descriptionForgetPasswordText.textColor = UIColor(named: "onboradColor")
        descriptionForgetPasswordText.isEditable = false
        descriptionForgetPasswordText.isScrollEnabled = false
        descriptionForgetPasswordText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionForgetPasswordText)
        
        emailTextField = FloatingLabelTextFieldView()
        emailTextField.setLabelText("Email".localized)
        emailTextField.textField.keyboardType = .emailAddress
        emailTextField.textField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let emailClearButton = UIButton(type: .custom)
        emailClearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        emailClearButton.tintColor = .lightGray
        emailClearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
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
        
        getVerificationCodeButton = UIButton(type: .system)
        getVerificationCodeButton.setTitle("Get verification code".localized, for: .normal)
        getVerificationCodeButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        getVerificationCodeButton.setTitleColor(.white, for: .normal)
        getVerificationCodeButton.backgroundColor = tenantViewModel.primaryColor
        getVerificationCodeButton.layer.cornerRadius = 25
        getVerificationCodeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(getVerificationCodeButton)
        
        getVerificationCodeButton.addTarget(self, action: #selector(getVerificationCodeButtonTapped), for: .touchUpInside)
        
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            ForgetPasswordText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ForgetPasswordText.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            descriptionForgetPasswordText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionForgetPasswordText.topAnchor.constraint(equalTo: ForgetPasswordText.bottomAnchor, constant: 5),
            descriptionForgetPasswordText.widthAnchor.constraint(equalToConstant: 300),
            descriptionForgetPasswordText.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: descriptionForgetPasswordText.bottomAnchor, constant: 40),
            emailTextField.widthAnchor.constraint(equalToConstant: 340),
            emailTextField.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        NSLayoutConstraint.activate([
            getVerificationCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getVerificationCodeButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40),
            getVerificationCodeButton.widthAnchor.constraint(equalToConstant: 340),
            getVerificationCodeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc func getVerificationCodeButtonTapped() {
        guard let email = emailTextField.textField.text, !email.isEmpty else {
            showAlert(message: "Please enter your email address.")
            return
        }
        
        guard loginViewModel.isValidEmail(email) else {
            showAlert(message: "Please enter a valid email address.")
            return
        }
        
        sendOTPViewModel.sendOTP(to: email) { [weak self] success, message in
            DispatchQueue.main.async {
                if success {
                    let nextViewController = ResetPasswordViewController()
                    nextViewController.email = email
                    let navigationController = UINavigationController(rootViewController: nextViewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self?.present(navigationController, animated: true, completion: nil)
                } else {
                    self?.showAlert(message: "This email is not registered. Please try again.")
                }
            }
        }
    }
    
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func clearTextField() {
        emailTextField.textField.text = ""
    }
}
