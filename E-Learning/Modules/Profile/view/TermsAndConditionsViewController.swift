//
//  TermsAndConditionsViewController.swift
//  E-Learning
//
//  Created by aya on 23/11/2024.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {
    
    var scrollView = UIScrollView()
    var stackView = UIStackView()
    var introLabel = UILabel()
    var transparencyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Terms and Conditions"
        let backButtonImage = UIImage(named: "Icon 1")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        setupUI()
        setupConstraints()
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        introLabel = UILabel()
        introLabel.text = """
            Welcome to Vinsys Inc.'s Privacy Policy. This Policy explains how we collect and use your data and how you can control your information. Looking for a quick summary on our privacy practices? Check out this page or this video. And if you’re looking for specific product privacy information, for example, how we process your Chats and Snaps, take a look at our Privacy by Product page. In addition to these documents, we also show in-app notices that provide you more information about our products and services.
            """
        introLabel.font = UIFont.systemFont(ofSize: 18)
        introLabel.textColor = UIColor(named: "policy2")
        introLabel.numberOfLines = 0
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(introLabel)
        
        transparencyLabel = UILabel()
        transparencyLabel.text = """
           Transparency is one of our core values at Vinsys. We believe there shouldn’t be any surprises about the data we collect and how we use it — that’s why we’re upfront with how we process it. For example, we process your information to provide you a more personalized experience, including to show you content and information that is most relevant to your experience, as well as more relevant advertisements. Understanding your interests and preferences help us provide a better product experience.
           """
        transparencyLabel.font = UIFont.systemFont(ofSize: 18)
        transparencyLabel.textColor = UIColor(named: "policy2")
        transparencyLabel.numberOfLines = 0
        transparencyLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(transparencyLabel)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
}
