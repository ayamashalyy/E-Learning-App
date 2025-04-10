//
//  SelectOrganizationViewController.swift
//  E-Learning
//
//  Created by aya on 24/11/2024.
//

import UIKit
import MaterialComponents
import SDWebImage

class SelectOrganizationViewController: UIViewController, UITextFieldDelegate {
    
    var enterOrganizationNameText: UILabel!
    var organizationNameTextField: MDCTextField!
    var goToYourOrgaizationButton: UIButton!
    var organizationNameController: MDCTextInputControllerOutlined!
    var tenantViewModel = TenantViewModel.shared
    var logoViewController: LogoViewController?
    
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
        enterOrganizationNameText.textAlignment = .center
        enterOrganizationNameText.numberOfLines = 0
        enterOrganizationNameText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(enterOrganizationNameText)
        
        organizationNameTextField = MDCTextField()
        organizationNameTextField.font = UIFont(name: "Roboto-Medium", size: 14)
        organizationNameTextField.textColor = .lightGray
        organizationNameTextField.translatesAutoresizingMaskIntoConstraints = false
        organizationNameTextField.clearButtonMode = .never
        organizationNameTextField.autocapitalizationType = .none
        
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .lightGray
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        clearButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let isRTL = UIView.userInterfaceLayoutDirection(for: view.semanticContentAttribute) == .rightToLeft
        if isRTL {
            organizationNameTextField.leftView = clearButton
            organizationNameTextField.leftViewMode = .whileEditing
        } else {
            organizationNameTextField.rightView = clearButton
            organizationNameTextField.rightViewMode = .whileEditing
        }
        
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
        goToYourOrgaizationButton.backgroundColor = .black
        goToYourOrgaizationButton.layer.cornerRadius = 25
        goToYourOrgaizationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goToYourOrgaizationButton)
        
        goToYourOrgaizationButton.addTarget(self, action: #selector(goToYourOrgaizationButtonTapped), for: .touchUpInside)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            enterOrganizationNameText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterOrganizationNameText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
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
        guard let organizationName = organizationNameTextField.text, !organizationName.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Organization name is required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        tenantViewModel.setOrganizationName(organizationName)
        UserDefaults.standard.set(organizationName, forKey: UserDefaultsKeys.selectedTenant)
        
        tenantViewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
        
        tenantViewModel.fetchTenantData()
        
        tenantViewModel.onDataLoaded = { [weak self] tenant in
            DispatchQueue.main.async{
                if self?.tenantViewModel.validateOrganizationName(organizationName) == true {
                    if let self = self {
                        let logoViewController = LogoViewController()
                        logoViewController.modalPresentationStyle = .fullScreen
                        self.present(logoViewController, animated: true, completion: nil)
                        
                        if let logoURL = URL(string: tenant.siteLogo) {
                            logoViewController.logoImageView.sd_setImage(with: logoURL, placeholderImage: UIImage(named: "placeholder")) { image, error, cacheType, url in
                                if let error = error {
                                    print("Failed to load logo image: \(error.localizedDescription)")
                                } else {
                                    print("Logo image loaded successfully")
                                }
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            let nextViewController = LoginViewController()
                            nextViewController.modalPresentationStyle = .fullScreen
                            
                            logoViewController.present(nextViewController, animated: true) {
                                self.logoViewController = nil
                            }
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "Organization name does not match.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc func clearTextField() {
        organizationNameTextField.text = ""
    }
}

