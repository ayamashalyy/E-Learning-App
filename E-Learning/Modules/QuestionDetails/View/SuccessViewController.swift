//
//  SuccessViewController.swift
//  E-Learning
//
//  Created by aya on 12/12/2024.
//

import UIKit

class SuccessViewController: UIViewController {
    
    var score: Int?
    var stackView = UIStackView()
    var imageGrowth = UIImageView()
    var scoreNum = UILabel()
    var congratulationLabel = UILabel()
    var passedMassage = UILabel()
    var continueButton = UIButton()
    var reviewButton = UIButton()
    var tenantViewModel = TenantViewModel.shared
    var quizViewModel: QuizViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUI()
        setupConstraints()
        
        if let score = score {
            print("Score received: \(score)")
            scoreNum.text = "\(score)% Score"
        } else {
            print("No score available")
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
        
        imageGrowth = UIImageView()
        imageGrowth.translatesAutoresizingMaskIntoConstraints = false
        imageGrowth.contentMode = .scaleAspectFit
        imageGrowth.image = UIImage(named: "imageGrowth")
        viewImage.addSubview(imageGrowth)
        
        NSLayoutConstraint.activate([
            imageGrowth.centerXAnchor.constraint(equalTo: viewImage.centerXAnchor),
            imageGrowth.centerYAnchor.constraint(equalTo: viewImage.centerYAnchor),
            imageGrowth.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 200),
            imageGrowth.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        scoreNum = UILabel()
        scoreNum.font = UIFont(name: "Roboto-Medium", size: 18)
        scoreNum.textColor = UIColor(named: "scoreColor")
        scoreNum.textAlignment = .center
        scoreNum.heightAnchor.constraint(equalToConstant: 40).isActive = true
        scoreNum.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(scoreNum)
        
        congratulationLabel = UILabel()
        congratulationLabel.text = "Congratulation!".localized
        congratulationLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        congratulationLabel.textColor = .black
        congratulationLabel.textAlignment = .center
        congratulationLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        congratulationLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(congratulationLabel)
        
        passedMassage = UILabel()
        passedMassage.text = "You have successfully passed the Quiz,\n\nclick Continue to complete your educational journey".localized
        passedMassage.font = UIFont(name: "Roboto-Regular", size: 12)
        passedMassage.textColor = UIColor(named: "onboradColor")
        passedMassage.textAlignment = .center
        passedMassage.lineBreakMode = .byWordWrapping
        passedMassage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passedMassage.numberOfLines = 0
        passedMassage.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(passedMassage)
        
        continueButton = UIButton(type: .system)
        continueButton.setTitle("Continue".localized, for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.backgroundColor = tenantViewModel.primaryColor
        continueButton.layer.cornerRadius = 25
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        reviewButton = UIButton(type: .system)
        reviewButton.setTitle("Review", for: .normal)
        reviewButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        reviewButton.setTitleColor(UIColor.white, for: .normal)
        reviewButton.backgroundColor = tenantViewModel.secondaryColor
        reviewButton.layer.cornerRadius = 25
        reviewButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reviewButton)
        reviewButton.addTarget(self, action: #selector(reviewButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            continueButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            reviewButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 15),
            reviewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            reviewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            reviewButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc func continueButtonTapped() {
        print("Continue button tapped")
        
        guard let navController = self.navigationController else {
            print("Error: No navigation controller found")
            return
        }
        
        print("Current Navigation Stack: \(navController.viewControllers.map { String(describing: type(of: $0)) })")
        
        if let courseVC = navController.viewControllers.first(where: { $0 is CourseViewController }) as? CourseViewController {
            guard let viewModel = courseVC.viewModel else {
                print("Error: CourseViewModel not available")
                navController.popToRootViewController(animated: true)
                return
            }
            
            if let nextLesson = viewModel.getNextLesson() {
                viewModel.setSelectedLesson(nextLesson)
                print("Next lesson set: \(nextLesson.title)")
                navController.popToViewController(courseVC, animated: true)
                DispatchQueue.main.async { [weak courseVC] in
                    courseVC?.displayLesson()
                    if let contentVC = courseVC?.children.first(where: { $0 is CourseContentViewController }) as? CourseContentViewController {
                        contentVC.tableView.reloadData()
                        print("Updated CourseContentViewController table view")
                    }
                }
            } else {
                print("No next lesson available, course completed")
                let alert = UIAlertController(
                    title: "Course Completed".localized,
                    message: "Congratulations 🎉! You have finished all lessons in this course.".localized,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK".localized, style: .default) { _ in
                    navController.popToViewController(courseVC, animated: true)
                    DispatchQueue.main.async { [weak courseVC] in
                        courseVC?.displayLesson()
                        if let contentVC = courseVC?.children.first(where: { $0 is CourseContentViewController }) as? CourseContentViewController {
                            contentVC.tableView.reloadData()
                            print("Updated CourseContentViewController table view")
                        }
                    }
                })
                self.present(alert, animated: true)
            }
        } else {
            print("Error: Could not find CourseViewController in navigation stack")
            navController.popToRootViewController(animated: true)
        }
    }
    
    @objc func reviewButtonTapped() {
        print("Review button tapped")
        
        guard let navController = self.navigationController else {
            print("Error: No navigation controller found")
            return
        }
        
        guard let quizViewModel = self.quizViewModel else {
            print("Error: QuizViewModel is nil")
            return
        }
        
        if let courseVC = navController.viewControllers.first(where: { $0 is CourseViewController }) as? CourseViewController,
           let courseViewModel = courseVC.viewModel {
            let courseSlug = courseViewModel.getCourse()?.slug ?? ""
            let quizId = quizViewModel.quizCourse?.data?.id ?? 1
            let token = UserSessionManager.shared.token ?? ""
            
            quizViewModel.fetchQuizReview(courseSlug: courseSlug, quizId: quizId, token: token) { [weak self] (reviewResponse, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Failed to fetch quiz review: \(error)")
                    return
                }
                if let reviewResponse = reviewResponse {
                    print("Quiz review fetched: \(reviewResponse.data.quizScore)")
                    let pageViewController = PageViewController(viewModel: courseViewModel, quizViewModel: quizViewModel, isReviewMode: true)
                    self.navigationController?.pushViewController(pageViewController, animated: true)
                }
            }
        } else {
            print("Error: Could not find CourseViewController or viewModel")
        }
    }
}
