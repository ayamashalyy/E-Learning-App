//
//  PageViewController.swift
//  E-Learning
//
//  Created by aya on 15/12/2024.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var dataSourace: [QuestionModel] = [
        .init(title: "Question 1 / 4", questionDatasModel: .init(id: "1", questionText: "1 - How is the waterfall method different", answers: [.init(id: "1", text: "Comprehensive documentation"),
                                                                                                                                               .init(id: "2", text: "Comprehensive documentation"),
                                                                                                                                               .init(id: "3", text: "Comprehensive documentation"),.init(id: "4", text: "Comprehensive documentation")], type: .singleChoice)),
        
            .init(title: "Question 2 / 4", questionDatasModel: .init(id: "2", questionText: "2 - How is the waterfall method different", answers: [.init(id: "1", text: "True"),
                                                                                                                                                   .init(id: "2", text: "False")], type: .trueFalse)),
        
            .init(title: "Question 3 / 4", questionDatasModel: .init(id: "3", questionText: "3 - How is the waterfall method different", answers: [.init(id: "1", text: "Comprehensive documentation"),
                                                                                                                                                   .init(id: "2", text: "Comprehensive documentation"),.init(id: "3", text: "Comprehensive documentation"),.init(id: "4",text: "Comprehensive documentation")], type: .multipleChoice)),
        
            .init(title: "Question 4 / 4", questionDatasModel: .init(id: "4", questionText: "4 - How is the waterfall method different", answers: [.init(id: "1", text: "Choose 1"),
                                                                                                                                                   .init(id: "2", text: "Answer 1"),.init(id: "3", text: "Choose 2"),.init(id: "4", text: "Answer 2"),.init(id: "5", text: "Choose 3"),.init(id: "6", text: "Answer 4"),.init(id: "7", text: "Choose 4"),.init(id: "8", text: "Answer 5")], type: .matching)),
    ]
    
    private var subVC: [QuestionVC] = []
    var nextButton: UIButton!
    var previousButton: UIButton!
    var imageView = UIImageView()
    var titleLabel: UILabel!
    private var score: Int = 80
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Lesson1 Quiz"
        let backButtonImage = UIImage(named: "Icon 1")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
        var vcs = [QuestionVC]()
        
        for data in dataSourace {
            let vc = QuestionVC()
            vc.question = data.questionDatasModel
            vcs.append(vc)
        }
        self.subVC = vcs
        setupPageController()
        setupButtonsUI()
        updateButtonStates()
        
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupButtonsUI() {
        
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        titleLabel.textColor = UIColor(named: "second")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Previous Button
        previousButton = UIButton(type: .system)
        previousButton.setTitle("Previous", for: .normal)
        previousButton.setTitleColor(UIColor(named: "myCustom"), for: .normal)
        previousButton.layer.borderWidth = 1.0
        previousButton.layer.borderColor = UIColor(named: "myCustom")?.cgColor
        previousButton.layer.cornerRadius = 24
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.setImage(UIImage(named: "Icon 1"), for: .normal)
        previousButton.imageView?.contentMode = .scaleAspectFit
        previousButton.addTarget(self, action: #selector(previousButtonPressed), for: .touchUpInside)
        previousButton.semanticContentAttribute = .forceLeftToRight
        previousButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        previousButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        
        // Next Button
        nextButton = UIButton(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = UIColor(named: "myCustom")
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
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25),
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
        guard let currentViewController = self.viewControllers?.first as? QuestionVC,
              let currentQuestion = currentViewController.question else { return }
        
        let isAnswerSelected = currentQuestion.answers.contains { $0.isSelected }
        
        if isAnswerSelected {
            goToNextPage()
        } else {
            showAlert(message: "Please select an answer before proceeding to the next question.")
        }
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
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
        self.setViewControllers([self.subVC[0]], direction: .forward, animated: true, completion: nil)
    }
    
    func updateButtonStates() {
        guard let currentViewController = self.viewControllers?.first as? QuestionVC,
              let currentIndex = subVC.firstIndex(of: currentViewController) else { return }
        
        previousButton.isHidden = currentIndex == 0
        nextButton.isHidden = false
        imageView.isHidden = currentIndex > 0 && currentIndex < subVC.count
        
        titleLabel.text = dataSourace[currentIndex].title
        
        if currentIndex == subVC.count - 1 {
            nextButton.setTitle("Show Results", for: .normal)
            nextButton.removeTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
            nextButton.addTarget(self, action: #selector(showResults), for: .touchUpInside)
        } else {
            nextButton.setTitle("Next", for: .normal)
            nextButton.removeTarget(self, action: #selector(showResults), for: .touchUpInside)
            nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        }
    }
    
    @objc private func showResults() {
        guard let currentViewController = self.viewControllers?.first as? QuestionVC,
              let currentQuestion = currentViewController.question else { return }
        
        let isAnswerSelected = currentQuestion.answers.contains { $0.isSelected }
        
        if isAnswerSelected {
            if score > 85 {
                let successViewController = SuccessViewController()
                successViewController.modalPresentationStyle = .fullScreen
                successViewController.score = score
                present(successViewController, animated: true, completion: nil)
            } else {
                let failureViewController = FailureViewController()
                failureViewController.modalPresentationStyle = .fullScreen
                failureViewController.score = score
                present(failureViewController, animated: true, completion: nil)
            }
        } else {
            showAlert(message: "Please select an answer before proceeding to the results.")
        }
    }
    
    
    func goToNextPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) else { return }
        let currentIndex = subVC.firstIndex(of: nextViewController as! QuestionVC) ?? 0
        setViewControllers([nextViewController], direction: .forward, animated: animated, completion: nil)
        updateButtonStates()
        
    }
    
    private func goToPreviousPage(animated: Bool = true) {
        guard let currentViewController = self.viewControllers?.first else { return }
        guard let previousViewController = dataSource?.pageViewController(self, viewControllerBefore: currentViewController) else { return }
        let currentIndex = subVC.firstIndex(of: previousViewController as! QuestionVC) ?? 0
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

