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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Account Center"
        let backButtonImage = UIImage(named: "Icon 1")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(cancelTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
        setupUI()
        
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func setupUI() {
        
        
        textLabel = UILabel()
        textLabel.text = "Make changes to your personal information"
        textLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor(named: "onboradColor")
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textLabel)
        
        
        configureStack(stack: nameStackView, title: "Name", icon: "lucide_user-cog")
        configureStack(stack: emailStackView, title: "Email address", icon: "mage_email")
        configureStack(stack: passwordStackView, title: "Password", icon: "ri_lock-password-line")
        
        let mainStack = UIStackView(arrangedSubviews: [nameStackView, emailStackView, passwordStackView])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            
            textLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 120),
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 40),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func configureStack(stack: UIStackView, title: String, icon: String) {
        stack.axis = .vertical
        stack.spacing = 20
        stack.backgroundColor = UIColor.white
        stack.isLayoutMarginsRelativeArrangement = true
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 10
        horizontalStack.isUserInteractionEnabled = true
        
        let iconImageView = UIImageView(image: UIImage(named: icon))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
        
        let actionButton = UIButton(type: .system)
        actionButton.setImage(UIImage(named: "arrow_drop_down_24px"), for: .normal)
        actionButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        horizontalStack.addArrangedSubview(iconImageView)
        horizontalStack.addArrangedSubview(titleLabel)
        horizontalStack.addArrangedSubview(actionButton)
        stack.addArrangedSubview(horizontalStack)
        
        let firstTextField = UITextField()
        firstTextField.font = UIFont.systemFont(ofSize: 16)
        firstTextField.textColor = UIColor(named: "textfield")
        firstTextField.isHidden = true
        firstTextField.placeholder = title == "Name" ? "Moaz Mohamed" :
        title == "Email address" ? "Username@gmail.com" : "Current password"
        firstTextField.backgroundColor = UIColor(named: "myLearning")
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        firstTextField.leftView = paddingView
        firstTextField.leftViewMode = .always
        firstTextField.textAlignment = .left
        firstTextField.translatesAutoresizingMaskIntoConstraints = false
        
        if title == "Password" {
            let eyeButton1 = UIButton(type: .system)
            eyeButton1.setImage(UIImage(named: "view"), for: .normal)
            eyeButton1.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
            
            eyeButton1.tag = 1
            firstTextField.rightViewMode = .always
            firstTextField.rightView = eyeButton1
            firstTextField.addSubview(eyeButton1)
            
            NSLayoutConstraint.activate([
                eyeButton1.trailingAnchor.constraint(equalTo: firstTextField.trailingAnchor, constant: -10),
                eyeButton1.widthAnchor.constraint(equalToConstant: 24),
                eyeButton1.heightAnchor.constraint(equalToConstant: 24)
            ])
            
        }
        
        stack.addArrangedSubview(firstTextField)
        
        if title == "Password" {
            let secondTextField = UITextField()
            secondTextField.font = UIFont.systemFont(ofSize: 16)
            secondTextField.textColor = UIColor(named: "textfield")
            secondTextField.isHidden = true
            secondTextField.placeholder = "New password"
            secondTextField.backgroundColor = UIColor(named: "myLearning")
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            secondTextField.leftView = paddingView
            secondTextField.leftViewMode = .always
            secondTextField.translatesAutoresizingMaskIntoConstraints = false
            
            
            let eyeButton2 = UIButton(type: .system)
            eyeButton2.setImage(UIImage(named: "view"), for: .normal)
            eyeButton2.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
            eyeButton2.tag = 2
            secondTextField.rightViewMode = .always
            secondTextField.rightView = eyeButton2
            secondTextField.addSubview(eyeButton2)
            eyeButton2.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(secondTextField)
            
            NSLayoutConstraint.activate([
                secondTextField.topAnchor.constraint(equalTo: firstTextField.bottomAnchor, constant: 0),
                secondTextField.heightAnchor.constraint(equalToConstant: 50),
                secondTextField.leadingAnchor.constraint(equalTo: horizontalStack.leadingAnchor, constant: -20),
                secondTextField.trailingAnchor.constraint(equalTo: horizontalStack.trailingAnchor, constant: 20),
                eyeButton2.widthAnchor.constraint(equalToConstant: 24),
                eyeButton2.heightAnchor.constraint(equalToConstant: 24)
            ])
            
        }
        
        NSLayoutConstraint.activate([
            horizontalStack.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 20),
            horizontalStack.topAnchor.constraint(equalTo: stack.topAnchor, constant: 20),
            horizontalStack.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20),
            firstTextField.leadingAnchor.constraint(equalTo: horizontalStack.leadingAnchor, constant: -20),
            firstTextField.trailingAnchor.constraint(equalTo: horizontalStack.trailingAnchor, constant: 20),
            firstTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(stackTapped(_:)))
        horizontalStack.addGestureRecognizer(tapGesture)
        horizontalStack.isUserInteractionEnabled = true
    }
    
    @objc private func stackTapped(_ sender: UITapGestureRecognizer) {
        guard let horizontalStack = sender.view as? UIStackView,
              let parentStack = horizontalStack.superview as? UIStackView else { return }
        
        if let stack = parentStack as? UIStackView {
            for view in stack.arrangedSubviews {
                if let textField = view as? UITextField {
                    textField.isHidden.toggle()
                    
                    if textField.isHidden {
                        
                        stack.layer.borderWidth = 0.0
                        stack.layer.borderColor = UIColor(named: "border")?.cgColor ?? UIColor.lightGray.cgColor
                        stack.layer.cornerRadius = 8
                        stack.layer.shadowColor = UIColor.lightGray.cgColor
                        stack.layer.shadowOpacity = 0.0
                        stack.layer.shadowOffset = CGSize(width: 0, height: 2)
                        stack.layer.shadowRadius = 4
                    } else {
                        
                        stack.layer.borderWidth = 1.0
                        stack.layer.borderColor = UIColor(named: "border")?.cgColor ?? UIColor.lightGray.cgColor
                        stack.layer.cornerRadius = 8
                        stack.layer.shadowColor = UIColor.lightGray.cgColor
                        stack.layer.shadowOpacity = 0.1
                        stack.layer.shadowOffset = CGSize(width: 0, height: 2)
                        stack.layer.shadowRadius = 4
                    }
                }
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
            sender.setImage(UIImage(named: "hide"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "view"), for: .normal)
        }
    }
    
}
