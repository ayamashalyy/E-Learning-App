//
//  QuizViewController.swift
//  E-Learning
//
//  Created by aya on 08/12/2024.
//

import UIKit

class QuizViewController: UIViewController {
    
    var viewModel = QuizViewModel()
    var questionNumberLabel: UILabel!
    var questionLabel: UILabel!
    var collectionView: UICollectionView!
    var nextButton: UIButton!
    var previousButton: UIButton!
    var imageView = UIImageView()
    var currentQuestion = 1
    var totalQuestions = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Lesson1 Quiz"
        let backButtonImage = UIImage(named: "Icon 1")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
        setupUI()
        setupConstraints()
        viewModel.loadQuestions()
        guard viewModel.totalQuestions > 0 else {
            fatalError("No questions loaded!")
        }
        updateUI()
        updateButtonStates()
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        
    }
    
    func updateButtonStates() {
        previousButton.isHidden = viewModel.currentQuestionIndex == 0
        nextButton.isHidden = viewModel.currentQuestionIndex >= viewModel.totalQuestions - 1
        imageView.isHidden = viewModel.currentQuestionIndex > 0 && viewModel.currentQuestionIndex < viewModel.totalQuestions - 1
        
        
    }
    
    
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI() {
        
        let currentQuestion = viewModel.currentQuestion
        questionNumberLabel.text = "Question \(viewModel.currentQuestionIndex + 1) / \(10)"
        questionLabel.text =  " \(viewModel.currentQuestionIndex + 1) - \(currentQuestion.questionText)"
    }
    
    @objc func nextButtonTapped() {
        if viewModel.moveToNextQuestion() {
            viewModel.selectedOptionIndex = nil
            viewModel.selectedAnswers = [] 
            updateUI()
            updateButtonStates()
            collectionView.reloadData()
        }
    }
    
    @objc func previousButtonTapped() {
        if viewModel.moveToPreviousQuestion() {
            viewModel.selectedOptionIndex = nil
            updateUI()
            updateButtonStates()
            collectionView.reloadData()
        }
    }
    
    func setupUI() {
        
        // Question Number Label
        questionNumberLabel = UILabel()
        questionNumberLabel.text = "Question \(currentQuestion) / \(totalQuestions)"
        questionNumberLabel.font = UIFont.boldSystemFont(ofSize: 14)
        questionNumberLabel.textColor = UIColor(named: "second")
        questionNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionNumberLabel)
        
        // Question Label
        questionLabel = UILabel()
        questionLabel.text = "\(currentQuestion) - How is the waterfall method different?"
        questionLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        questionLabel.numberOfLines = 0
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionLabel)
        
        // Collection View Setup
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: "SingleChoiceCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "SingleChoiceCell")
        let nibMultipleChoiceCell = UINib(nibName: "MultipleChoiceCell", bundle: nil)
        collectionView.register(nibMultipleChoiceCell, forCellWithReuseIdentifier: "MultipleChoiceCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        
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
        nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        nextButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        
        // Button Stack View
        let buttonStackView = UIStackView(arrangedSubviews: [previousButton, nextButton])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 16
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonStackView)
        
        imageView = UIImageView()
        imageView.image = UIImage(named: "")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let bigStackView = UIStackView(arrangedSubviews: [imageView, buttonStackView])
        bigStackView.axis = .horizontal
        bigStackView.distribution = .fillEqually
        bigStackView.spacing = 16
        bigStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bigStackView)
        
        NSLayoutConstraint.activate([
            bigStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            bigStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            bigStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bigStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            questionNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            questionNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
        ])
        
        NSLayoutConstraint.activate([
            
            questionLabel.topAnchor.constraint(equalTo: questionNumberLabel.bottomAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),
            
        ])
    }
}


extension QuizViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currentQuestion.options.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let question = viewModel.currentQuestion
        switch question.questionType {
        case .singleChoice:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleChoiceCell", for: indexPath) as? SingleChoiceCell else {
                return UICollectionViewCell()
            }
            
            let optionText = viewModel.currentQuestion.options[indexPath.row]
            let isSelected = viewModel.selectedOptionIndex == indexPath.row
            cell.configure(optionText: optionText, isSelected: isSelected)
            return cell
            
            
        case .trueFalse:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleChoiceCell", for: indexPath) as? SingleChoiceCell else {
                return UICollectionViewCell()
            }
            
            let optionText = viewModel.currentQuestion.options[indexPath.row]
            let isSelected = viewModel.selectedOptionIndex == indexPath.row
            cell.configure(optionText: optionText, isSelected: isSelected)
            return cell
            
        case .multipleChoice:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultipleChoiceCell", for: indexPath) as? MultipleChoiceCell else {
                return UICollectionViewCell()
            }
            
            let optionText = viewModel.currentQuestion.options[indexPath.row]
            let isSelected = viewModel.selectedAnswers.contains(indexPath.row)
            cell.configure(optionText: optionText, isSelected: isSelected)
            return cell
            
        case .matching:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultipleChoiceCell", for: indexPath) as? MultipleChoiceCell else {
                return UICollectionViewCell()
            }
            
            let optionText = viewModel.currentQuestion.options[indexPath.row]
            let isSelected = viewModel.selectedOptionIndex == indexPath.row
            cell.configure(optionText: optionText, isSelected: isSelected)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let question = viewModel.currentQuestion
        
        switch question.questionType {
        case .trueFalse, .singleChoice:
            viewModel.selectedOptionIndex = indexPath.row
            viewModel.selectedAnswers = [indexPath.row]
        case .multipleChoice:
            if viewModel.selectedAnswers.contains(indexPath.row) {
                viewModel.selectedAnswers.removeAll { $0 == indexPath.row }
            } else {
                viewModel.selectedAnswers.append(indexPath.row)
            }
        case .matching:
            break
        }
        
        collectionView.reloadData()
    }
    
}
