//
//  SelectOrganizationViewController.swift
//  E-Learning
//
//  Created by aya on 24/11/2024.
//

import UIKit
import MaterialComponents

class SelectOrganizationViewController: UIViewController, UITextFieldDelegate {
    
    var enterOrganizationNameText: UILabel!
    var organizationNameTextField: MDCTextField!
    var goToYourOrgaizationButton: UIButton!
    var organizationNameController: MDCTextInputControllerOutlined!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        
        enterOrganizationNameText = UILabel()
        enterOrganizationNameText.text = "Enter Your Organization Name"
        enterOrganizationNameText.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        enterOrganizationNameText.textColor = UIColor(named: "myCustom") ?? .black
        enterOrganizationNameText.textAlignment = .center
        enterOrganizationNameText.numberOfLines = 0
        enterOrganizationNameText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(enterOrganizationNameText)
        
        organizationNameTextField = MDCTextField()
        organizationNameTextField.font = UIFont.systemFont(ofSize: 12)
        organizationNameTextField.text = "Enter your organization name"
        organizationNameTextField.textColor = .lightGray
        organizationNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(organizationNameTextField)
        
        
        organizationNameController = MDCTextInputControllerOutlined(textInput: organizationNameTextField)
        organizationNameController.placeholderText = "Organization Name"
        organizationNameController.normalColor = .lightGray
        organizationNameController.activeColor = .lightGray;     organizationNameController.floatingPlaceholderActiveColor = .black
        organizationNameController.floatingPlaceholderScale = 0.8
        organizationNameController.borderRadius = 8
        
        
        goToYourOrgaizationButton = UIButton(type: .system)
        goToYourOrgaizationButton.setTitle("Go To Your Organization", for: .normal)
        goToYourOrgaizationButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        goToYourOrgaizationButton.setTitleColor(.white, for: .normal)
        goToYourOrgaizationButton.backgroundColor = UIColor(named: "myCustom") ?? .black
        goToYourOrgaizationButton.layer.cornerRadius = 25
        goToYourOrgaizationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goToYourOrgaizationButton)
        
        goToYourOrgaizationButton.addTarget(self, action: #selector(goToYourOrgaizationButtonTapped), for: .touchUpInside)
        
        organizationNameTextField.delegate = self
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            enterOrganizationNameText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterOrganizationNameText.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
            enterOrganizationNameText.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            organizationNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            organizationNameTextField.topAnchor.constraint(equalTo: enterOrganizationNameText.bottomAnchor, constant: 40),
            organizationNameTextField.widthAnchor.constraint(equalToConstant: 340),
            organizationNameTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            goToYourOrgaizationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goToYourOrgaizationButton.topAnchor.constraint(equalTo: organizationNameTextField.bottomAnchor, constant: 160),
            goToYourOrgaizationButton.widthAnchor.constraint(equalToConstant: 340),
            goToYourOrgaizationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func goToYourOrgaizationButtonTapped() {
        let nextViewController = LoginViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Remove placeholder text when editing begins
        if textField.text == "Enter your organization name" {
            textField.text = ""
            textField.textColor = .black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Restore placeholder text if field is empty
        if textField.text?.isEmpty ?? true {
            textField.text = "Enter your organization name"
            textField.textColor = .lightGray
        }
    }
}
