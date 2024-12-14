//
//  SuccessViewController.swift
//  E-Learning
//
//  Created by aya on 12/12/2024.
//

import UIKit

class SuccessViewController: UIViewController {
    
    var score: Int?
    var quizViewModel: QuizViewModel?
    var stackView = UIStackView()
    var imageGrowth = UIImageView()
    var scoreNum = UILabel()
    var congratulationLabel = UILabel()
    var passedMassage = UILabel()
    var continueButton = UIButton()
    var reviewButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
        
        if let score = score {
            scoreNum.text = "\(score)% Score"
        }
    }
    
    func setupUI() {
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let viewImage = UIView()
        viewImage.translatesAutoresizingMaskIntoConstraints = false
        viewImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        stackView.addArrangedSubview(viewImage)
        
        imageGrowth = UIImageView()
        imageGrowth.translatesAutoresizingMaskIntoConstraints = false
        imageGrowth.contentMode = .scaleAspectFit
        imageGrowth.image = UIImage(named: "imageGrowth")
        viewImage.addSubview(imageGrowth)
        
        NSLayoutConstraint.activate([
            imageGrowth.centerXAnchor.constraint(equalTo: viewImage.centerXAnchor),
            imageGrowth.centerYAnchor.constraint(equalTo: viewImage.centerYAnchor),
            imageGrowth.widthAnchor.constraint(equalTo: viewImage.widthAnchor, multiplier: 0.7),
            imageGrowth.heightAnchor.constraint(equalTo: viewImage.heightAnchor, multiplier: 0.9)
        ])
        
        scoreNum = UILabel()
        scoreNum.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        scoreNum.textColor = UIColor(named: "scoreColor")
        scoreNum.textAlignment = .center
        scoreNum.heightAnchor.constraint(equalToConstant: 20).isActive = true
        scoreNum.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(scoreNum)
        
        congratulationLabel = UILabel()
        congratulationLabel.text = "Congratulation!"
        congratulationLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        congratulationLabel.textColor = .black
        congratulationLabel.textAlignment = .center
        congratulationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        congratulationLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(congratulationLabel)
        
        passedMassage = UILabel()
        passedMassage.text = "You have successfully passed the Quiz,\n\nclick Continue to complete your educational journey"
        passedMassage.font = UIFont.systemFont(ofSize: 12)
        passedMassage.textColor = UIColor(named: "onboradColor")
        passedMassage.textAlignment = .center
        passedMassage.lineBreakMode = .byWordWrapping
        passedMassage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passedMassage.numberOfLines = 0
        passedMassage.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(passedMassage)
        
        continueButton = UIButton(type: .system)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.backgroundColor = UIColor(named: "myCustom")
        continueButton.layer.cornerRadius = 25
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        reviewButton = UIButton(type: .system)
        reviewButton.setTitle("Review", for: .normal)
        reviewButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        reviewButton.setTitleColor(UIColor.white, for: .normal)
        reviewButton.backgroundColor = UIColor(named: "second")
        reviewButton.layer.cornerRadius = 25
        reviewButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reviewButton)
        reviewButton.addTarget(self, action: #selector(reviewButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -350),
            continueButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            reviewButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 15),
            reviewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            reviewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            continueButton.widthAnchor.constraint(equalToConstant: 340),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            reviewButton.widthAnchor.constraint(equalToConstant: 340),
            reviewButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc func continueButtonTapped() {
        print("Continue")
    }
    
    @objc func reviewButtonTapped() {
        print("Review")
        guard let quizViewModel = quizViewModel else {
            print("QuizViewModel is nil")
            return
            
        }
        let quizViewController = QuizViewController()
        quizViewController.viewModel = quizViewModel
        quizViewController.modalPresentationStyle = .fullScreen
        present(quizViewController, animated: true, completion: nil)
    }
    
}
