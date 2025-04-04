//
//  QuestionVC.swift
//  E-Learning
//
//  Created by aya on 15/12/2024.
//

import UIKit

class QuestionVC: UIViewController {
    
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var collectionQuestion: UICollectionView!
    var leftCollectionView: UICollectionView!
    var rightCollectionView: UICollectionView!
    var quizViewModel: QuizViewModel?
    var questionIndex: Int = 0
    var selectedRightIndex: IndexPath?
    var selectedAnswers: [String] = []
    var isReviewMode: Bool = false
    var tenantViewModel = TenantViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("QuestionVC viewDidLoad - Index: \(questionIndex), Review Mode: \(isReviewMode)")
        setDataQuestion()
        configureCollectionView()
        if isReviewMode {
            collectionQuestion.allowsSelection = false
            leftCollectionView?.allowsSelection = false
            rightCollectionView?.allowsSelection = false
            rightCollectionView?.dragInteractionEnabled = false
        }
        
        if isReviewMode, let reviewQuestion = quizViewModel?.getQuizReviewQuestions()?[questionIndex] as? ReviewQuestion {
            let fullText = NSMutableAttributedString()
            
            let titleAndPoints = NSAttributedString(
                string: "\(reviewQuestion.title) (\(reviewQuestion.points) points) - ",
                attributes: [.foregroundColor: UIColor.black]
            )
            fullText.append(titleAndPoints)
            
            let statusText = reviewQuestion.isCorrect ? "Correct" : "Incorrect"
            let statusColor = reviewQuestion.isCorrect ? tenantViewModel.primaryColor : UIColor.red
            let status = NSAttributedString(
                string: statusText,
                attributes: [.foregroundColor: statusColor ?? .yellow]
            )
            fullText.append(status)
            questionText.attributedText = fullText
            
        }
    }
    
    
    func configureCollectionView() {
        let question: Any?
        if isReviewMode {
            question = quizViewModel?.getQuizReviewQuestions()?[questionIndex]
        } else {
            question = quizViewModel?.getQuizQuestions()?[questionIndex]
        }
        
        guard let question = question, let type = (question as? ReviewQuestion)?.type.lowercased() ?? (question as? QuestionCourses)?.type.lowercased() else { return }
        
        if type == "matching" {
            setupMatchingCollections()
            if !isReviewMode, let quizQuestion = question as? QuestionCourses {
                selectedAnswers = quizQuestion.right ?? []
            }
        } else {
            collectionQuestion.delegate = self
            collectionQuestion.dataSource = self
            collectionQuestion.register(UINib(nibName: "SingleChoiceCell", bundle: nil), forCellWithReuseIdentifier: "SingleChoiceCell")
            collectionQuestion.register(UINib(nibName: "MultipleChoiceCell", bundle: nil), forCellWithReuseIdentifier: "MultipleChoiceCell")
        }
    }
    
    func setupMatchingCollections() {
        
        let leftLayout = UICollectionViewFlowLayout()
        leftLayout.itemSize = CGSize(width: view.frame.width / 2 - 20, height: 60)
        leftCollectionView = UICollectionView(frame: .zero, collectionViewLayout: leftLayout)
        leftCollectionView.translatesAutoresizingMaskIntoConstraints = false
        leftCollectionView.backgroundColor = .white
        leftCollectionView.delegate = self
        leftCollectionView.dataSource = self
        leftCollectionView.register(UINib(nibName: "MatchingCell", bundle: nil), forCellWithReuseIdentifier: "MatchingCell")
        view.addSubview(leftCollectionView)
        
        let rightLayout = UICollectionViewFlowLayout()
        rightLayout.itemSize = CGSize(width: view.frame.width / 2 - 20, height: 60)
        rightCollectionView = UICollectionView(frame: .zero, collectionViewLayout: rightLayout)
        rightCollectionView.translatesAutoresizingMaskIntoConstraints = false
        rightCollectionView.backgroundColor = .white
        rightCollectionView.delegate = self
        rightCollectionView.dataSource = self
        rightCollectionView.dragDelegate = self
        rightCollectionView.dropDelegate = self
        rightCollectionView.dragInteractionEnabled = true
        rightCollectionView.register(UINib(nibName: "MatchingCell", bundle: nil), forCellWithReuseIdentifier: "MatchingCell")
        view.addSubview(rightCollectionView)
        
        NSLayoutConstraint.activate([
            leftCollectionView.topAnchor.constraint(equalTo: questionText.bottomAnchor, constant: 20),
            leftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            leftCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            leftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            rightCollectionView.topAnchor.constraint(equalTo: questionText.bottomAnchor, constant: 20),
            rightCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            rightCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            rightCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
    }
    
    func setDataQuestion() {
        if isReviewMode {
            if let question = quizViewModel?.getQuizReviewQuestions()?[questionIndex] {
                
                if question.isMatchingType {
                    selectedAnswers = question.answerRight ?? []
                } else {
                    selectedAnswers = question.answer ?? []
                }
            } else {
                questionText.text = "No question available"
            }
        } else {
            if let question = quizViewModel?.getQuizQuestions()?[questionIndex] {
                let fullText = "\(question.title) (\(question.points) points)"
                questionText.text = fullText
            } else {
                questionText.text = "No question available"
            }
        }
    }
    
    func getAnswer() -> [String: Any]? {
        guard let question = quizViewModel?.getQuizQuestions()?[questionIndex] else { return nil }
        let questionId = question.id
        var answer: Any
        
        switch question.type.lowercased() {
        case "single_choice", "true_false":
            answer = selectedAnswers.first ?? ""
        case "multiple_choice":
            answer = selectedAnswers
        case "matching":
            var matchingAnswer: [String: String] = [:]
            if let leftOptions = question.left, selectedAnswers.count == leftOptions.count {
                for (index, left) in leftOptions.enumerated() {
                    matchingAnswer[left] = selectedAnswers[index]
                }
            }
            answer = matchingAnswer
        default:
            return nil
        }
        
        return ["question_id": questionId, "answer": answer]
    }
}

extension QuestionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let question: Any?
        if isReviewMode {
            question = quizViewModel?.getQuizReviewQuestions()?[questionIndex]
        } else {
            question = quizViewModel?.getQuizQuestions()?[questionIndex]
        }
        
        guard let question = question else { return 0 }
        
        if collectionView == leftCollectionView {
            return (question as? ReviewQuestion)?.leftOptions?.count ?? (question as? QuestionCourses)?.left?.count ?? 0
        } else if collectionView == rightCollectionView {
            return selectedAnswers.count
        } else {
            let options = (question as? ReviewQuestion)?.options ?? (question as? QuestionCourses)?.options
            return options?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let question: Any?
        if isReviewMode {
            question = quizViewModel?.getQuizReviewQuestions()?[questionIndex]
        } else {
            question = quizViewModel?.getQuizQuestions()?[questionIndex]
        }
        
        guard let question = question else { return UICollectionViewCell() }
        
        if collectionView == leftCollectionView || collectionView == rightCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchingCell", for: indexPath) as? MatchingCell else {
                return UICollectionViewCell()
            }
            let text = collectionView == leftCollectionView ? ((question as? ReviewQuestion)?.leftOptions?[indexPath.row] ?? (question as? QuestionCourses)?.left?[indexPath.row]) : selectedAnswers[indexPath.row]
            let isSelected = true
            var isCorrect = false
            if isReviewMode, let reviewQuestion = question as? ReviewQuestion {
                if collectionView == rightCollectionView {
                    let correctRight = reviewQuestion.correctRightOptions ?? []
                    isCorrect = indexPath.row < correctRight.count && correctRight[indexPath.row] == text
                }
                cell.configure(optionText: text ?? "", isSelected: isSelected, isReviewMode: isReviewMode && collectionView == rightCollectionView, isCorrect: isCorrect)
            } else {
                cell.configure(optionText: text ?? "", isSelected: isSelected, isReviewMode: false, isCorrect: isCorrect)
            }
            return cell
        } else {
            let type = (question as? ReviewQuestion)?.type.lowercased() ?? (question as? QuestionCourses)?.type.lowercased() ?? ""
            switch type {
            case "single_choice", "true_false":
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleChoiceCell", for: indexPath) as? SingleChoiceCell else {
                    return UICollectionViewCell()
                }
                let options = (question as? ReviewQuestion)?.options ?? (question as? QuestionCourses)?.options ?? []
                let option = indexPath.row < options.count ? options[indexPath.row] : ""
                let isSelected = selectedAnswers.contains(option)
                var isCorrect = false
                if isReviewMode, let reviewQuestion = question as? ReviewQuestion {
                    let correctAnswers = reviewQuestion.correctAnswer ?? []
                    isCorrect = correctAnswers.contains(option)
                }
                cell.configure(optionText: option, isSelected: isSelected, isReviewMode: isReviewMode, isCorrect: isCorrect)
                return cell
                
            case "multiple_choice":
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultipleChoiceCell", for: indexPath) as? MultipleChoiceCell else {
                    return UICollectionViewCell()
                }
                let options = (question as? ReviewQuestion)?.options ?? (question as? QuestionCourses)?.options ?? []
                let option = indexPath.row < options.count ? options[indexPath.row] : ""
                let isSelected = selectedAnswers.contains(option)
                var isCorrect = false
                if isReviewMode, let reviewQuestion = question as? ReviewQuestion {
                    let correctAnswers = reviewQuestion.correctAnswer ?? []
                    isCorrect = correctAnswers.contains(option)
                }
                cell.configure(optionText: option, isSelected: isSelected, isReviewMode: isReviewMode, isCorrect: isCorrect)
                return cell
                
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let question: Any?
        if isReviewMode {
            question = quizViewModel?.getQuizReviewQuestions()?[questionIndex]
        } else {
            question = quizViewModel?.getQuizQuestions()?[questionIndex]
        }
        
        guard let question = question else { return CGSize.zero }
        
        if collectionView == leftCollectionView || collectionView == rightCollectionView {
            return CGSize(width: collectionView.frame.width - 10, height: 60)
        } else {
            let type = (question as? ReviewQuestion)?.type.lowercased() ?? (question as? QuestionCourses)?.type.lowercased() ?? ""
            switch type {
            case "true_false", "single_choice", "multiple_choice":
                return CGSize(width: collectionView.frame.width, height: 60)
            default:
                return CGSize.zero
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isReviewMode,
              let question = quizViewModel?.getQuizQuestions()?[questionIndex],
              question.type.lowercased() != "matching",
              let options = question.options else { return }
        
        let option = options[indexPath.row]
        
        switch question.type.lowercased() {
        case "true_false", "single_choice":
            selectedAnswers = [option]
        case "multiple_choice":
            if selectedAnswers.contains(option) {
                selectedAnswers.removeAll { $0 == option }
            } else {
                selectedAnswers.append(option)
            }
        default:
            break
        }
        
        collectionView.reloadData()
    }
}

