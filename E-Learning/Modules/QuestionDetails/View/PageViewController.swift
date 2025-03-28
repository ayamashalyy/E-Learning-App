//
//  PageViewController.swift
//  E-Learning
//
//  Created by aya on 15/12/2024.
//

import UIKit

class PageViewController: UIPageViewController {
    
    private var subVC: [QuestionVC] = []
    var nextButton: UIButton!
    var previousButton: UIButton!
    var imageView = UIImageView()
    var titleLabel: UILabel!
    var tenantViewModel = TenantViewModel.shared
    var backButtonImage: UIImage!
    var viewModel: CourseOverviewViewModel?
    private var quizViewModel = QuizViewModel()
    var onQuizCompleted: ((Bool) -> Void)?
    
    init(viewModel: CourseOverviewViewModel?, quizViewModel: QuizViewModel) {
        self.viewModel = viewModel
        self.quizViewModel = quizViewModel
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let quizTitle = quizViewModel.getQuizTitle() ?? "Lesson Quiz".localized
        print("PageViewController loaded with Quiz Title: \(quizTitle)")
        self.title = quizTitle
        backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        
        if let backButtonImage = backButtonImage {
            let tintedImage = backButtonImage.withTintColor(tenantViewModel.primaryColor ?? .blue, renderingMode: .alwaysOriginal)
            let backButton = UIBarButtonItem(image: tintedImage, style: .plain, target: self, action: #selector(backButtonTapped))
            self.navigationItem.leftBarButtonItem = backButton
        }
        
        setupSubViewControllers()
        setupPageController()
        setupButtonsUI()
        updateButtonStates()
        
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupSubViewControllers() {
        guard let quizResponse = quizViewModel.quizCourse,
              let questions = quizResponse.data?.questions else {
            print("No quiz response or questions found")
            return
        }
        print("Found \(questions.count) questions for the quiz")
        
        var vcs = [QuestionVC]()
        for (index, _) in questions.enumerated() {
            let vc = QuestionVC()
            vc.quizViewModel = quizViewModel
            vc.questionIndex = index
            vcs.append(vc)
        }
        self.subVC = vcs
    }
    
    func setupButtonsUI() {
        
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        titleLabel.textColor = tenantViewModel.secondaryColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Previous Button
        previousButton = UIButton(type: .system)
        previousButton.setTitle("Previous".localized, for: .normal)
        previousButton.setTitleColor(tenantViewModel.primaryColor, for: .normal)
        previousButton.layer.borderWidth = 1.0
        previousButton.layer.borderColor = tenantViewModel.primaryColor?.cgColor
        previousButton.layer.cornerRadius = 24
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.setImage(UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        previousButton.tintColor = tenantViewModel.primaryColor
        previousButton.imageView?.contentMode = .scaleAspectFit
        previousButton.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
        previousButton.semanticContentAttribute = .forceLeftToRight
        previousButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        previousButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        
        // Next Button
        nextButton = UIButton(type: .system)
        nextButton.setTitle("Next".localized, for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = tenantViewModel.primaryColor
        nextButton.layer.cornerRadius = 24
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setImage(UIImage(named: "navigate_next 1"), for: .normal)
        nextButton.imageView?.contentMode = .scaleAspectFit
        nextButton.semanticContentAttribute = .forceRightToLeft
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        nextButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // Button Stack View
        let buttonStackView = UIStackView(arrangedSubviews: [previousButton, nextButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 16
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(buttonStackView)
        
        imageView = UIImageView()
        imageView.image = nil
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let bigStackView = UIStackView(arrangedSubviews: [imageView, buttonStackView])
        bigStackView.axis = .horizontal
        bigStackView.distribution = .fillEqually
        bigStackView.spacing = 16
        bigStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(bigStackView)
        
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bigStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25),
            bigStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
            bigStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -20),
            bigStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension PageViewController {
    @objc private func nextButtonPressed() {
        guard let currentViewController = self.viewControllers?.first as? QuestionVC else { return }
        
        let isAnswerSelected = currentViewController.quizViewModel?.getQuizQuestions()?[currentViewController.questionIndex].type.lowercased() == "matching" || !currentViewController.selectedAnswers.isEmpty
        
        if isAnswerSelected {
            goToNextPage()
        } else {
            showAlert(message: "Please select an answer before proceeding to the next question.".localized)
        }
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert".localized, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func previousButtonPressed() {
        goToPreviousPage()
    }
}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private func setupPageController() {
        self.delegate = self
        self.dataSource = self
        if !subVC.isEmpty {
            self.setViewControllers([self.subVC[0]], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func updateButtonStates() {
        guard let currentViewController = self.viewControllers?.first as? QuestionVC,
              let currentIndex = subVC.firstIndex(of: currentViewController) else { return }
        
        previousButton.isHidden = currentIndex == 0
        nextButton.isHidden = false
        imageView.isHidden = currentIndex > 0 && currentIndex < subVC.count
        
        // Use viewModel to get the current question title
        if currentViewController.quizViewModel?.getQuizQuestions()?[currentIndex] != nil {
            titleLabel.text = "Question \(currentIndex + 1) / \(subVC.count)"
        } else {
            titleLabel.text = "Question \(currentIndex + 1) / \(subVC.count)"
        }
        
        if currentIndex == subVC.count - 1 {
            nextButton.setTitle("Show Results".localized, for: .normal)
            nextButton.removeTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
            nextButton.addTarget(self, action: #selector(showResults), for: .touchUpInside)
        } else {
            nextButton.setTitle("Next".localized, for: .normal)
            nextButton.removeTarget(self, action: #selector(showResults), for: .touchUpInside)
            nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        }
    }
    
    @objc private func showResults() {
        guard let currentViewController = self.viewControllers?.first as? QuestionVC else { return }
        
        let isAnswerSelected = currentViewController.quizViewModel?.getQuizQuestions()?[currentViewController.questionIndex].type.lowercased() == "matching" || !currentViewController.selectedAnswers.isEmpty
        
        if isAnswerSelected {
            var answers: [[String: Any]] = []
            for vc in subVC {
                if let answer = vc.getAnswer() {
                    answers.append(answer)
                }
            }
            
            let courseSlug = viewModel?.getCourse()?.slug ?? ""
            let quizId = quizViewModel.quizCourse?.data?.id ?? 1
            let token = UserSessionManager.shared.token ?? ""
            let isEnroll = viewModel?.isCourseEnrolled() ?? false
            let isRequest = viewModel?.getCourseRequestStatus() ?? "UNKNOWN"
            
            print("isEnroll: \(isEnroll), isRequest: \(isRequest)")
            print("Submitting quiz with courseSlug: \(courseSlug), quizId: \(quizId), Answers: \(answers)")
            
            quizViewModel.onQuizSubmitted = { [weak self] in
                guard let self = self else {
                    print("Self is nil in onQuizSubmitted")
                    return
                }
                print("onQuizSubmitted called")
                let isPassed = self.quizViewModel.isQuizPassed()
                let score = self.quizViewModel.getQuizScore() ?? 0.0
                print("isPassed: \(isPassed), Score: \(score)")
                self.onQuizCompleted?(isPassed)
                if isPassed {
                    self.showSuccessAlert(message: "Quiz submitted successfully! Your score is \(Int(score))%.") {
                        let successViewController = SuccessViewController()
                        successViewController.score = Int(score)
                        let navController = UINavigationController(rootViewController: successViewController)
                        navController.modalPresentationStyle = .fullScreen
                        self.present(navController, animated: true, completion: nil)
                    }
                } else {
                    self.showErrorAlert(message: "Quiz failed. Your score is \(Int(score))%, required: \(self.quizViewModel.getPassPercentage() ?? 0)%.") {
                        let failureViewController = FailureViewController()
                        failureViewController.score = Int(score)
                        failureViewController.courseViewModel = self.viewModel
                        let navController = UINavigationController(rootViewController: failureViewController)
                        navController.modalPresentationStyle = .fullScreen
                        self.present(navController, animated: true, completion: nil)
                    }
                }
            }
            
            quizViewModel.submitQuiz(courseSlug: courseSlug, quizId: quizId, answers: answers, token: token)
            
        } else {
            showAlert(message: "Please select an answer before proceeding to the results.".localized)
        }
    }
    
    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        let _ = subVC.firstIndex(of: nextViewController as! QuestionVC) ?? 0
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
        updateButtonStates()
        
    }
    
    private func goToPreviousPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        let _ = subVC.firstIndex(of: previousViewController as! QuestionVC) ?? 0
        setViewControllers([previousViewController], direction: .reverse, animated: animated, completion: nil)
        updateButtonStates()
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.subVC.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = subVC.firstIndex(of: viewController as! QuestionVC) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return subVC[currentIndex - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = subVC.firstIndex(of: viewController as! QuestionVC) ?? 0
        if currentIndex >= subVC.count - 1 {
            return nil
        }
        return subVC[currentIndex + 1]
    }
}

