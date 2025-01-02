//
//  ResetPasswordViewController.swift
//OTP
//  E-Learning
//
//  Created by aya on 25/11/2024.
//

import UIKit

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {
    
    var descriptionResetPasswordText: UITextView!
    let emailLabel = UILabel()
    var otpFields: [UITextField] = []
    var checkReceiveOTPLabel = UILabel()
    var resendButton = UIButton()
    var verifyButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        self.navigationItem.title = "Reset Password".localized
        let backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(cancelTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
        
        
    }
    
    func setupViews() {
        
        descriptionResetPasswordText = UITextView()
        descriptionResetPasswordText.text = "Please enter the code we just sent to email".localized
        descriptionResetPasswordText.font = UIFont(name: "Roboto-Regular", size: 14)
        descriptionResetPasswordText.textAlignment = .center
        descriptionResetPasswordText.textColor = UIColor(named: "onboradColor")
        descriptionResetPasswordText.isEditable = false
        descriptionResetPasswordText.isScrollEnabled = false
        descriptionResetPasswordText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionResetPasswordText)
        
        emailLabel.text = "username@gmail.com".localized
        emailLabel.textAlignment = .center
        emailLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        emailLabel.textColor = UIColor(named: "onboradColor")
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        
        
        for _ in 0..<4 {
            let textField = UITextField()
            textField.textAlignment = .center
            textField.font = UIFont(name: "Roboto-Bold", size: 20)
            textField.layer.borderColor = UIColor.lightGray.cgColor
            textField.layer.cornerRadius = 8
            textField.backgroundColor = UIColor(named: "reset")
            textField.keyboardType = .numberPad
            textField.delegate = self
            textField.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(textField)
            otpFields.append(textField)
        }
        
        checkReceiveOTPLabel.text = "Didn’t receive OTP?".localized
        checkReceiveOTPLabel.textAlignment = .center
        checkReceiveOTPLabel.font = UIFont(name: "Roboto-Medium", size: 12)
        checkReceiveOTPLabel.textColor = UIColor(named: "onboradColor")
        checkReceiveOTPLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkReceiveOTPLabel)
        
        
        let attributedString = NSAttributedString(
            string: "Resend code".localized,
            attributes: [
                .foregroundColor: UIColor(named: "myCustom") ?? .blue,
                .font: UIFont(name: "Roboto-Medium", size: 12) ?? .boldSystemFont(ofSize: 12),
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .underlineColor:  UIColor(named: "myCustom") ?? .blue
            ]
        )
        resendButton.setAttributedTitle(attributedString, for: .normal)
        resendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resendButton)
        
        resendButton.addTarget(self, action: #selector(sendOTPAgainButtonTapped), for: .touchUpInside)
        
        
        verifyButton = UIButton()
        verifyButton.setTitle("Verify".localized, for: .normal)
        verifyButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        verifyButton.setTitleColor(.white, for: .normal)
        verifyButton.backgroundColor = UIColor(named: "myCustom") ?? .black
        verifyButton.layer.cornerRadius = 25
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verifyButton)
        
        verifyButton.addTarget(self, action: #selector(verifyButtonTapped), for: .touchUpInside)
        
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            descriptionResetPasswordText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionResetPasswordText.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            descriptionResetPasswordText.widthAnchor.constraint(equalToConstant: 300),
            descriptionResetPasswordText.heightAnchor.constraint(equalToConstant: 30)
            
        ])
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: descriptionResetPasswordText.bottomAnchor, constant: 2),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            
            otpFields[0].topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 25),
            otpFields[0].leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            otpFields[0].widthAnchor.constraint(equalToConstant: 65),
            otpFields[0].heightAnchor.constraint(equalToConstant: 50),
            
            otpFields[1].topAnchor.constraint(equalTo: otpFields[0].topAnchor),
            otpFields[1].leadingAnchor.constraint(equalTo: otpFields[0].trailingAnchor, constant: 10),
            otpFields[1].widthAnchor.constraint(equalToConstant: 65),
            otpFields[1].heightAnchor.constraint(equalToConstant: 50),
            
            otpFields[2].topAnchor.constraint(equalTo: otpFields[0].topAnchor),
            otpFields[2].leadingAnchor.constraint(equalTo: otpFields[1].trailingAnchor, constant: 10),
            otpFields[2].widthAnchor.constraint(equalToConstant: 65),
            otpFields[2].heightAnchor.constraint(equalToConstant: 50),
            
            otpFields[3].topAnchor.constraint(equalTo: otpFields[0].topAnchor),
            otpFields[3].leadingAnchor.constraint(equalTo: otpFields[2].trailingAnchor, constant: 10),
            otpFields[3].widthAnchor.constraint(equalToConstant: 65),
            otpFields[3].heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            checkReceiveOTPLabel.topAnchor.constraint(equalTo: otpFields[0].bottomAnchor, constant: 40),
            checkReceiveOTPLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            resendButton.topAnchor.constraint(equalTo: checkReceiveOTPLabel.bottomAnchor, constant: 5),
            resendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            verifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verifyButton.topAnchor.constraint(equalTo: resendButton.bottomAnchor, constant: 55),
            verifyButton.widthAnchor.constraint(equalToConstant: 340),
            verifyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
    }
    
    @objc func verifyButtonTapped() {
        
        print("Hiiiiiiiiiiiiiiiiiiiiiiiiiiii")
        let nextViewController = NewPasswordViewController()
        
        let navigationController = UINavigationController(rootViewController: nextViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    
    @objc func cancelTapped() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func sendOTPAgainButtonTapped() {
        print("OTP resent successfully!")
    }
    
    
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count > 1 { return false }
        textField.text = string
        
        if let index = otpFields.firstIndex(of: textField) {
            if !string.isEmpty {
                
                textField.textColor = UIColor(named: "second") ?? .blue
                textField.layer.borderColor = (UIColor(named: "second") ?? .blue).cgColor
                textField.layer.borderWidth = 1
                if index < otpFields.count - 1 {
                    otpFields[index + 1].becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                }
            } else {
                
                textField.textColor = UIColor(named: "second") ?? .black
                textField.layer.borderColor = UIColor.lightGray.cgColor
                textField.layer.borderWidth = 0.4
                
            }
        }
        
        return false
    }
}
