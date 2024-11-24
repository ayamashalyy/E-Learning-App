//
//  OnboardingViewController.swift
//  E-Learning
//
//  Created by aya on 19/11/2024.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    var imageView: UIImageView!
    var welcomeText: UILabel!
    var descriptionText: UITextView!
    var registerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
    }
    
    func setupViews() {
        imageView = UIImageView()
        imageView.image = UIImage(named: "onbording")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        welcomeText = UILabel()
        welcomeText.text = "Welcome to Vinsys Academy"
        welcomeText.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        welcomeText.textAlignment = .center
        welcomeText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeText)
        
        descriptionText = UITextView()
        descriptionText.text = "Access a wide range of courses tailored to help you succeed in your personal and professional life."
        descriptionText.font = UIFont.systemFont(ofSize: 16)
        descriptionText.textAlignment = .center
        descriptionText.textColor = UIColor(named: "onboradColor")
        descriptionText.isEditable = false
        descriptionText.isScrollEnabled = false
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionText)
        
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Register", for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        registerButton.setTitleColor(UIColor.white, for: .normal)
        registerButton.backgroundColor = UIColor(named: "myCustom")
        registerButton.layer.cornerRadius = 25
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerButton)
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 260),
            imageView.heightAnchor.constraint(equalToConstant: 260)
        ])
        
        NSLayoutConstraint.activate([
            welcomeText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeText.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            descriptionText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionText.topAnchor.constraint(equalTo: welcomeText.bottomAnchor, constant: 20),
            descriptionText.widthAnchor.constraint(equalToConstant: 360),
            descriptionText.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: descriptionText.bottomAnchor, constant: 10),
            registerButton.widthAnchor.constraint(equalToConstant: 340),
            registerButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func registerButtonTapped() {
        let nextViewController = SelectOrganizationViewController()
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}
