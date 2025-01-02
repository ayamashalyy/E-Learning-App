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
        enterOrganizationNameText.text = "Enter Your Organization Name".localized
        enterOrganizationNameText.font = UIFont(name: "Roboto-Bold", size: 24)
        enterOrganizationNameText.textColor = UIColor(named: "myCustom") ?? .black
        enterOrganizationNameText.textAlignment = .center
        enterOrganizationNameText.numberOfLines = 0
        enterOrganizationNameText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(enterOrganizationNameText)
        
        organizationNameTextField = MDCTextField()
        organizationNameTextField.font = UIFont(name: "Roboto-Medium", size: 14)
        organizationNameTextField.textColor = .lightGray
        organizationNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(organizationNameTextField)
        
        
        organizationNameController = MDCTextInputControllerOutlined(textInput: organizationNameTextField)
        organizationNameController.placeholderText = "Organization Name".localized
        organizationNameController.normalColor = .lightGray
        organizationNameController.activeColor = .lightGray
        organizationNameController.floatingPlaceholderActiveColor = .black
        organizationNameController.floatingPlaceholderScale = 0.8
        organizationNameController.borderRadius = 8
        
        
        goToYourOrgaizationButton = UIButton(type: .system)
        goToYourOrgaizationButton.setTitle("Go To Your Organization".localized, for: .normal)
        goToYourOrgaizationButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        goToYourOrgaizationButton.setTitleColor(.white, for: .normal)
        goToYourOrgaizationButton.backgroundColor = UIColor(named: "myCustom") ?? .black
        goToYourOrgaizationButton.layer.cornerRadius = 25
        goToYourOrgaizationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goToYourOrgaizationButton)
        
        goToYourOrgaizationButton.addTarget(self, action: #selector(goToYourOrgaizationButtonTapped), for: .touchUpInside)
        
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
}
