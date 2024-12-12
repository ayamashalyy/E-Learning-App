//
//  FailureViewController.swift
//  E-Learning
//
//  Created by aya on 12/12/2024.
//

import UIKit

class FailureViewController: UIViewController {
    
    var score: Int?
    var stackView = UIStackView()
    var failureImage = UIImageView()
    var scoreNum = UILabel()
    var congratulationLabel = UILabel()
    var retryMassage = UILabel()
    var tryAgainButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
    }
    
    func setupUI() {
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let viewImage = UIView()
        viewImage.translatesAutoresizingMaskIntoConstraints = false
        viewImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        stackView.addArrangedSubview(viewImage)
        
        failureImage = UIImageView()
        failureImage.translatesAutoresizingMaskIntoConstraints = false
        failureImage.contentMode = .scaleAspectFit
        failureImage.image = UIImage(named: "failureImage")
        viewImage.addSubview(failureImage)
        
        NSLayoutConstraint.activate([
            failureImage.centerXAnchor.constraint(equalTo: viewImage.centerXAnchor),
            failureImage.centerYAnchor.constraint(equalTo: viewImage.centerYAnchor),
            failureImage.widthAnchor.constraint(equalTo: viewImage.widthAnchor, multiplier: 0.6),
            failureImage.heightAnchor.constraint(equalTo: viewImage.heightAnchor, multiplier: 0.9)
        ])
        
        scoreNum = UILabel()
        scoreNum.text = "60% Score"
        scoreNum.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        scoreNum.textColor = UIColor(named: "failureColor")
        scoreNum.textAlignment = .center
        scoreNum.heightAnchor.constraint(equalToConstant: 20).isActive = true
        scoreNum.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(scoreNum)
        
        congratulationLabel = UILabel()
        congratulationLabel.text = "You did not pass the quiz!"
        congratulationLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        congratulationLabel.textColor = .black
        congratulationLabel.textAlignment = .center
        congratulationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        congratulationLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(congratulationLabel)
        
        retryMassage = UILabel()
        retryMassage.text = "Please click \"Retry\" to take the quiz again \n\nand continue your educational journey."
        retryMassage.font = UIFont.systemFont(ofSize: 12)
        retryMassage.textColor = UIColor(named: "onboradColor")
        retryMassage.textAlignment = .center
        retryMassage.lineBreakMode = .byWordWrapping
        retryMassage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        retryMassage.numberOfLines = 0
        retryMassage.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(retryMassage)
        
        tryAgainButton = UIButton(type: .system)
        tryAgainButton.setTitle("Try Again", for: .normal)
        tryAgainButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        tryAgainButton.setTitleColor(UIColor.white, for: .normal)
        tryAgainButton.backgroundColor = UIColor(named: "myCustom")
        tryAgainButton.layer.cornerRadius = 25
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tryAgainButton)
        tryAgainButton.addTarget(self, action: #selector(tryAgainButtonTapped), for: .touchUpInside)
        
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -350),
            tryAgainButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            tryAgainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            tryAgainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            tryAgainButton.widthAnchor.constraint(equalToConstant: 340),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
    }
    
    @objc func tryAgainButtonTapped() {
        print("Try Again")
    }
    
    
}
