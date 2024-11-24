//
//  SelectOrganizationViewController.swift
//  E-Learning
//
//  Created by aya on 24/11/2024.
//

import UIKit

class SelectOrganizationViewController: UIViewController {
    
    var enterOrganizationNameText: UILabel!
    var organizationNameTextField: UITextField!
    var goToYourOrgaizationButton: UIButton!
    
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
        enterOrganizationNameText.textColor = UIColor(named: "myCustom")
        enterOrganizationNameText.textAlignment = .center
        enterOrganizationNameText.numberOfLines = 0
        enterOrganizationNameText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(enterOrganizationNameText)
        
        organizationNameTextField = UITextField()
        organizationNameTextField.placeholder = "   Enter your organization name"
        organizationNameTextField.font = UIFont.systemFont(ofSize: 14)
        organizationNameTextField.borderStyle = .roundedRect
        organizationNameTextField.layer.cornerRadius = 10
        organizationNameTextField.layer.borderWidth = 1
        organizationNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        organizationNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(organizationNameTextField)
        
        goToYourOrgaizationButton = UIButton(type: .system)
        goToYourOrgaizationButton.setTitle("Go To Your Orgaization", for: .normal)
        goToYourOrgaizationButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        goToYourOrgaizationButton.setTitleColor(UIColor.white, for: .normal)
        goToYourOrgaizationButton.backgroundColor = UIColor(named: "myCustom")
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
