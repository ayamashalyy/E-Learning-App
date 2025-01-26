//
//  ForgetPasswordViewController.swift
//  E-Learning
//
//  Created by aya on 25/11/2024.
//

import UIKit
import MaterialComponents

class ForgetPasswordViewController: UIViewController, UITextFieldDelegate{
    
    var imageView: UIImageView!
    var ForgetPasswordText: UILabel!
    var descriptionForgetPasswordText: UITextView!
    var emailTextField: MDCTextField!
    var emailController: MDCTextInputControllerOutlined!
    var getVerificationCodeButton: UIButton!
    var tenantViewModel = TenantViewModel.shared
    var backButtonImage: UIImage!
    
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
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
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
            emailTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            getVerificationCodeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getVerificationCodeButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40),
            getVerificationCodeButton.widthAnchor.constraint(equalToConstant: 340),
            getVerificationCodeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc func getVerificationCodeButtonTapped() {
        let nextViewController = ResetPasswordViewController()
        
        let navigationController = UINavigationController(rootViewController: nextViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
