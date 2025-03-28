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
    var tenantViewModel = TenantViewModel.shared
    var courseViewModel: CourseOverviewViewModel?
    
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
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let viewImage = UIView()
        viewImage.translatesAutoresizingMaskIntoConstraints = false
        viewImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.addArrangedSubview(viewImage)
        
        failureImage = UIImageView()
        failureImage.translatesAutoresizingMaskIntoConstraints = false
        failureImage.contentMode = .scaleAspectFit
        failureImage.image = UIImage(named: "failureImage")
        viewImage.addSubview(failureImage)
        
        NSLayoutConstraint.activate([
            failureImage.centerXAnchor.constraint(equalTo: viewImage.centerXAnchor),
            failureImage.centerYAnchor.constraint(equalTo: viewImage.centerYAnchor),
            failureImage.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 200),
            failureImage.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        scoreNum = UILabel()
        scoreNum.font = UIFont(name: "Roboto-Medium", size: 18)
        scoreNum.textColor = UIColor(named: "failureColor")
        scoreNum.textAlignment = .center
        scoreNum.heightAnchor.constraint(equalToConstant: 40).isActive = true
        scoreNum.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(scoreNum)
        
        congratulationLabel = UILabel()
        congratulationLabel.text = "You did not pass the quiz!".localized
        congratulationLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        congratulationLabel.textColor = .black
        congratulationLabel.textAlignment = .center
        congratulationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        congratulationLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(congratulationLabel)
        
        retryMassage = UILabel()
        retryMassage.text = "Please click \"Retry\" to take the quiz again \n\nand continue your educational journey.".localized
        retryMassage.font = UIFont(name: "Roboto-Regular", size: 12)
        retryMassage.textColor = UIColor(named: "onboradColor")
        retryMassage.textAlignment = .center
        retryMassage.lineBreakMode = .byWordWrapping
        retryMassage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        retryMassage.numberOfLines = 0
        retryMassage.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(retryMassage)
        
        tryAgainButton = UIButton(type: .system)
        tryAgainButton.setTitle("Try Again".localized, for: .normal)
        tryAgainButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        tryAgainButton.setTitleColor(UIColor.white, for: .normal)
        tryAgainButton.backgroundColor = tenantViewModel.primaryColor
        tryAgainButton.layer.cornerRadius = 25
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tryAgainButton)
        tryAgainButton.addTarget(self, action: #selector(tryAgainButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tryAgainButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            tryAgainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            tryAgainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func tryAgainButtonTapped() {
        print("Try Again button tapped")
        let quizViewModel = QuizViewModel()
        guard let courseViewModel = courseViewModel else {
            print("Error: CourseViewModel not available")
            return
        }
        
        let courseSlug = courseViewModel.getCourse()?.slug ?? ""
        let quizId = quizViewModel.quizCourse?.data?.id ?? 1
        let token = UserSessionManager.shared.token ?? ""
        
        print("Retrying quiz with courseSlug: \(courseSlug), quizId: \(quizId)")
        quizViewModel.getQuiz(courseSlug: courseSlug, quizId: quizId, token: token) { [weak self] (quizResponse, message, error) in
            guard let self = self else { return }
            if let error = error {
                print("Failed to fetch quiz: \(error)")
                return
            }
            if let message = message, message == "You have already passed this quiz" {
                print("User already passed the quiz, no retry needed")
                return
            }
            
            print("Quiz fetched successfully for retry")
            let pageViewController = PageViewController(viewModel: courseViewModel, quizViewModel: quizViewModel)
            pageViewController.onQuizCompleted = { isPassed in
                print("Quiz retry completed, isPassed: \(isPassed)")
                if isPassed {
                    let successVC = SuccessViewController()
                    successVC.score = Int(quizViewModel.getQuizScore() ?? 0)
                    successVC.modalPresentationStyle = .fullScreen
                    self.present(successVC, animated: true, completion: nil)
                } else {
                    let failureVC = FailureViewController()
                    failureVC.score = Int(quizViewModel.getQuizScore() ?? 0)
                    failureVC.courseViewModel = courseViewModel
                    failureVC.modalPresentationStyle = .fullScreen
                    self.present(failureVC, animated: true, completion: nil)
                }
            }
            let navigationController = UINavigationController(rootViewController: pageViewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}
