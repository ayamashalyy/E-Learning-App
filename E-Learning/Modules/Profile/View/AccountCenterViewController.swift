//
//  AccountCenterViewController.swift
//  E-Learning
//
//  Created by aya on 29/11/2024.
//

import UIKit

class AccountCenterViewController: UIViewController {
    
    var nameStackView = UIStackView()
    var emailStackView = UIStackView()
    var passwordStackView = UIStackView()
    var textLabel = UILabel()
    var passwordRequirementsLabel = UILabel()
    var passwordCriteriaLabel = UILabel()
    var scrollView: UIScrollView!
    var contentView: UIView!
    var tenantViewModel = TenantViewModel.shared
    var backButtonImage: UIImage!
    let profileUpdateViewModel = ProfileUpdateViewModel()
    var userSessionManager = UserSessionManager.shared
    var resetPasswordViewModel = ResetPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Account Center".localized
        backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        
        if let backButtonImage = backButtonImage {
            let tintedImage = backButtonImage.withTintColor(tenantViewModel.primaryColor ?? .blue, renderingMode: .alwaysOriginal)
            let backButton = UIBarButtonItem(image: tintedImage, style: .plain, target: self, action: #selector(cancelTapped))
            self.navigationItem.leftBarButtonItem = backButton
        }
        setupScrollView()
        setupUI()
        setupButtons()
        userSessionManager.loadUserCredentialsFromUserDefaults()
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupScrollView() {
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
    }
    
    
    
    func setupUI() {
        passwordCriteriaLabel.text = "Your password must meet the following criteria:".localized
        passwordCriteriaLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        passwordCriteriaLabel.textColor = .black
        passwordCriteriaLabel.isHidden = true
        passwordCriteriaLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(passwordCriteriaLabel)
        
        passwordRequirementsLabel.text = "passwordRequirements".localized
        passwordRequirementsLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        passwordRequirementsLabel.textColor = UIColor(named: "onboradColor")
        passwordRequirementsLabel.isHidden = true
        passwordRequirementsLabel.numberOfLines = 0
        passwordRequirementsLabel.lineBreakMode = .byWordWrapping
        passwordRequirementsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(passwordRequirementsLabel)
        
        textLabel = UILabel()
        textLabel.text = "Make changes to your personal information".localized
        textLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor(named: "onboradColor")
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textLabel)
        
        configureStack(stack: nameStackView, title: "Name", icon: "lucide_user-cog")
        configureStack(stack: emailStackView, title: "Email address", icon: "mage_email")
        configureStack(stack: passwordStackView, title: "Password", icon: "ri_lock-password-line")
        
        let mainStack = UIStackView(arrangedSubviews: [nameStackView, emailStackView, passwordStackView])
        mainStack.axis = .vertical
        mainStack.spacing = 15
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            mainStack.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
            
        ])
        
        NSLayoutConstraint.activate([
            passwordCriteriaLabel.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: 10),
            passwordCriteriaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordCriteriaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordRequirementsLabel.topAnchor.constraint(equalTo: passwordCriteriaLabel.bottomAnchor, constant: 10),
            passwordRequirementsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordRequirementsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func configureStack(stack: UIStackView, title: String, icon: String) {
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.backgroundColor = UIColor.white
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 0)
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 10
        horizontalStack.isUserInteractionEnabled = true
        horizontalStack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        
        let iconImageView = UIImageView(image: UIImage(named: icon))
        iconImageView.tintColor = tenantViewModel.secondaryColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = title.localized
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 16)
        titleLabel.textColor = .black
        
        let actionButton = UIButton(type: .system)
        actionButton.setImage(UIImage(named: "arrow_drop_down_24px")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        actionButton.tintColor = tenantViewModel.primaryColor
        actionButton.widthAnchor.constraint(lessThanOrEqualToConstant: 24).isActive = true
        actionButton.heightAnchor.constraint(lessThanOrEqualToConstant: 24).isActive = true
        
        horizontalStack.addArrangedSubview(iconImageView)
        horizontalStack.addArrangedSubview(titleLabel)
        horizontalStack.addArrangedSubview(actionButton)
        stack.addArrangedSubview(horizontalStack)
        
        
        if title == "Name" {
            let nameTextField = UITextField()
            nameTextField.font = UIFont(name: "Roboto-Regular", size: 16)
            nameTextField.textColor = UIColor(named: "textfield")
            nameTextField.isHidden = true
            nameTextField.placeholder = userSessionManager.name
            nameTextField.backgroundColor = UIColor(named: "myLearning")
            let paddingViewName = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            nameTextField.leftView = paddingViewName
            nameTextField.leftViewMode = .always
            nameTextField.translatesAutoresizingMaskIntoConstraints = false
            
            stack.addArrangedSubview(nameTextField)
            
            NSLayoutConstraint.activate([
                nameTextField.heightAnchor.constraint(equalToConstant: 50),
                nameTextField.leadingAnchor.constraint(equalTo: horizontalStack.leadingAnchor, constant: -20),
                nameTextField.trailingAnchor.constraint(equalTo: horizontalStack.trailingAnchor),
                
            ])
        }
        
        if title == "Email address" {
            let emailTextField = UITextField()
            emailTextField.font = UIFont(name: "Roboto-Regular", size: 16)
            emailTextField.textColor = UIColor(named: "textfield")
            emailTextField.isHidden = true
            emailTextField.placeholder = userSessionManager.email
            emailTextField.backgroundColor = UIColor(named: "myLearning")
            let paddingViewEmail = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            emailTextField.leftView = paddingViewEmail
            emailTextField.leftViewMode = .always
            emailTextField.translatesAutoresizingMaskIntoConstraints = false
            
            stack.addArrangedSubview(emailTextField)
            
            NSLayoutConstraint.activate([
                emailTextField.heightAnchor.constraint(equalToConstant: 50),
                emailTextField.leadingAnchor.constraint(equalTo: horizontalStack.leadingAnchor, constant: -20),
                emailTextField.trailingAnchor.constraint(equalTo: horizontalStack.trailingAnchor)
            ])
        }
        
        
        if title == "Password" {
            
            let currentPasswordTextField = UITextField()
            currentPasswordTextField.font = UIFont(name: "Roboto-Regular", size: 16)
            currentPasswordTextField.textColor = UIColor(named: "textfield")
            currentPasswordTextField.isHidden = true
            currentPasswordTextField.placeholder = userSessionManager.newPassword
            currentPasswordTextField.backgroundColor = UIColor(named: "myLearning")
            let paddingViewCurrentPasswordTextField = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            currentPasswordTextField.leftView = paddingViewCurrentPasswordTextField
            currentPasswordTextField.leftViewMode = .always
            currentPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
            
            let eyeButton1 = UIButton(type: .system)
            eyeButton1.tintColor = tenantViewModel.primaryColor
            eyeButton1.translatesAutoresizingMaskIntoConstraints = false
            eyeButton1.setImage(UIImage(named: "view")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
            eyeButton1.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
            
            eyeButton1.tag = 1
            currentPasswordTextField.rightViewMode = .always
            currentPasswordTextField.rightView = eyeButton1
            currentPasswordTextField.addSubview(eyeButton1)
            
            stack.addArrangedSubview(currentPasswordTextField)
            
            
            let newPasswordTextField = UITextField()
            newPasswordTextField.font = UIFont(name: "Roboto-Regular", size: 16)
            newPasswordTextField.textColor = UIColor(named: "textfield")
            newPasswordTextField.isHidden = true
            newPasswordTextField.placeholder = userSessionManager.confirmPassword
            newPasswordTextField.backgroundColor = UIColor(named: "myLearning")
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            newPasswordTextField.leftView = paddingView
            newPasswordTextField.leftViewMode = .always
            newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
            
            
            let eyeButton2 = UIButton(type: .system)
            eyeButton2.tintColor = tenantViewModel.primaryColor
            eyeButton2.setImage(UIImage(named: "view")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
            eyeButton2.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
            eyeButton2.tag = 2
            newPasswordTextField.rightViewMode = .always
            newPasswordTextField.rightView = eyeButton2
            newPasswordTextField.addSubview(eyeButton2)
            eyeButton2.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(newPasswordTextField)
            
            NSLayoutConstraint.activate([
                
                currentPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
                currentPasswordTextField.leadingAnchor.constraint(equalTo: horizontalStack.leadingAnchor, constant: -20),
                currentPasswordTextField.trailingAnchor.constraint(equalTo: horizontalStack.trailingAnchor),
                
                eyeButton1.trailingAnchor.constraint(equalTo: currentPasswordTextField.trailingAnchor, constant: -10),
                eyeButton1.widthAnchor.constraint(equalToConstant: 90),
                eyeButton1.heightAnchor.constraint(equalToConstant: 90),
                
                newPasswordTextField.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 0),
                newPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
                newPasswordTextField.leadingAnchor.constraint(equalTo: horizontalStack.leadingAnchor, constant: -20),
                
                newPasswordTextField.trailingAnchor.constraint(equalTo: horizontalStack.trailingAnchor),
                eyeButton2.widthAnchor.constraint(equalToConstant: 90),
                eyeButton2.heightAnchor.constraint(equalToConstant: 90)
                
            ])
            
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stackTapped(_:)))
        horizontalStack.addGestureRecognizer(tapGesture)
        horizontalStack.isUserInteractionEnabled = true
    }
    
    @objc private func stackTapped(_ sender: UITapGestureRecognizer) {
        guard let horizontalStack = sender.view as? UIStackView,
              let parentStack = horizontalStack.superview as? UIStackView else { return }
        
        for view in parentStack.arrangedSubviews {
            if let textField = view as? UITextField {
                textField.isHidden.toggle()
                
                if textField.isHidden {
                    
                    parentStack.layer.borderWidth = 0.0
                    parentStack.layer.borderColor = UIColor(named: "border")?.cgColor ?? UIColor.lightGray.cgColor
                    parentStack.layer.cornerRadius = 8
                    parentStack.layer.shadowColor = UIColor.lightGray.cgColor
                    parentStack.layer.shadowOpacity = 0.0
                    parentStack.layer.shadowOffset = CGSize(width: 0, height: 2)
                    parentStack.layer.shadowRadius = 4
                } else {
                    
                    parentStack.layer.borderWidth = 1.0
                    parentStack.layer.borderColor = UIColor(named: "border")?.cgColor ?? UIColor.lightGray.cgColor
                    parentStack.layer.cornerRadius = 8
                    parentStack.layer.shadowColor = UIColor.lightGray.cgColor
                    parentStack.layer.shadowOpacity = 0.1
                    parentStack.layer.shadowOffset = CGSize(width: 0, height: 2)
                    parentStack.layer.shadowRadius = 4
                }
            }
        }
        
        if parentStack == passwordStackView {
            passwordCriteriaLabel.isHidden.toggle()
            passwordRequirementsLabel.isHidden.toggle()
        }
    }
    
    func setupButtons() {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel".localized, for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        cancelButton.setTitleColor(tenantViewModel.primaryColor, for: .normal)
        cancelButton.backgroundColor = .clear
        cancelButton.layer.cornerRadius = 8
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.layer.cornerRadius = 32
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = tenantViewModel.primaryColor?.cgColor
        cancelButton.addTarget(self, action: #selector(cancelChanges), for: .touchUpInside)
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save Changes".localized, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = tenantViewModel.primaryColor
        saveButton.layer.cornerRadius = 32
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        
        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillProportionally
        
        buttonStack.spacing = 10
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalTo: saveButton.heightAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc func cancelChanges() {
        print("Changes cancelled")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveChanges() {
        guard let token = userSessionManager.token else {
            print("Token not found in UserDefaults")
            return
        }
        guard let nameTextField = nameStackView.arrangedSubviews.compactMap({$0 as? UITextField }).first,
              let emailTextField = emailStackView.arrangedSubviews.compactMap({ $0 as? UITextField }).first,
              let currentPasswordTextField = passwordStackView.arrangedSubviews.compactMap ({ $0 as? UITextField }).first,
              let confirmationPasswordTextField = passwordStackView.arrangedSubviews.compactMap ({ $0 as? UITextField }).last
        else {
            print("Text fields not found")
            return
        }
        
        
        let name = nameTextField.text?.isEmpty == false ? nameTextField.text! : userSessionManager.name ?? ""
        let email = emailTextField.text?.isEmpty == false ? emailTextField.text! : userSessionManager.email ?? ""
        let currentPassword = currentPasswordTextField.text?.isEmpty == false ? currentPasswordTextField.text! : userSessionManager.newPassword ?? ""
        let confirmationPassword = confirmationPasswordTextField.text?.isEmpty == false ? confirmationPasswordTextField.text! : userSessionManager.confirmPassword ?? ""
        
        if !profileUpdateViewModel.isValidEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        if !profileUpdateViewModel.isValidPassword(currentPassword) {
            showAlert(title: "Invalid Password", message: "The password field must be at least 8 characters.")
            return
        }
        
        if currentPassword != confirmationPassword {
            showAlert(title: "Password Mismatch", message: "The password field confirmation does not match.")
            return
        }
        
        profileUpdateViewModel.updateProfile(name: name, email: email, avatar: nil, password: currentPassword, password_confirmation: confirmationPassword, token: token) { result in
            switch result {
            case .success(let data):
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Profile updated successfully with response: \(responseString)")
                    DispatchQueue.main.async {
                        self.userSessionManager.name = name
                        self.userSessionManager.email = email
                        self.userSessionManager.newPassword = currentPassword
                        self.userSessionManager.confirmPassword = confirmationPassword
                        self.userSessionManager.saveUserCredentialsToUserDefaults()
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    print("Profile updated successfully, but no response data.")
                }
            case .failure(let error):
                print("Failed to update profile: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        
        guard let textField = sender.superview as? UITextField else {
            print("Error: Unable to find the associated text field.")
            return
        }
        
        textField.isSecureTextEntry.toggle()
        
        if textField.isSecureTextEntry {
            sender.setImage(UIImage(named: "hide")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        } else {
            sender.setImage(UIImage(named: "view")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
