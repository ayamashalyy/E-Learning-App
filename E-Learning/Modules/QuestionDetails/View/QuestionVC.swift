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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("QuestionVC viewDidLoad - Index: \(questionIndex)")
        setDataQuestion()
        configureCollectionView()
        
    }
    
    func configureCollectionView() {
        guard let type = quizViewModel?.getQuizQuestions()?[questionIndex].type.lowercased() else { return }
        if type == "matching" {
            setupMatchingCollections()
            if let question = quizViewModel?.getQuizQuestions()?[questionIndex] {
                selectedAnswers = question.right ?? [] }
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
        if let question = quizViewModel?.getQuizQuestions()?[questionIndex] {
            questionText.text = "\(question.title) (\(question.points) points)"
        } else {
            questionText.text = "No question available"
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
        guard let question = quizViewModel?.getQuizQuestions()?[questionIndex] else { return 0 }
        
        if collectionView == leftCollectionView {
            return question.left?.count ?? 0
        } else if collectionView == rightCollectionView {
            return selectedAnswers.count
        } else {
            return question.options?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let question = quizViewModel?.getQuizQuestions()?[questionIndex] else { return UICollectionViewCell() }
        
        if collectionView == leftCollectionView || collectionView == rightCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchingCell", for: indexPath) as? MatchingCell else {
                return UICollectionViewCell()
            }
            
            let text = collectionView == leftCollectionView ? question.left?[indexPath.row] : selectedAnswers[indexPath.row]
            let isSelected = (collectionView == rightCollectionView && selectedRightIndex == indexPath)
            cell.configure(optionText: text ?? "", isSelected: isSelected)
            return cell
        } else {
            let type = question.type.lowercased()
            switch type{
            case "single_choice", "true_false":
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleChoiceCell", for: indexPath) as? SingleChoiceCell else {
                    return UICollectionViewCell()
                }
                let option = question.options?[indexPath.row] ?? ""
                let isSelected = selectedAnswers.contains(option)
                cell.configure(optionText: option, isSelected: isSelected)
                return cell
                
            case "multiple_choice":
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultipleChoiceCell", for: indexPath) as? MultipleChoiceCell else {
                    return UICollectionViewCell()
                }
                let option = question.options?[indexPath.row] ?? ""
                let isSelected = selectedAnswers.contains(option)
                cell.configure(optionText: option, isSelected: isSelected)
                return cell
                
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == leftCollectionView || collectionView == rightCollectionView {
            return CGSize(width: collectionView.frame.width - 10, height: 60)
        } else {
            guard let question = quizViewModel?.getQuizQuestions()?[questionIndex] else { return CGSize.zero }
            let type = question.type.lowercased()
            switch type {
            case "true_false", "single_choice", "multiple_choice":
                return CGSize(width: collectionView.frame.width, height: 60)
            default:
                return CGSize.zero
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let question = quizViewModel?.getQuizQuestions()?[questionIndex],
              question.type.lowercased() != "matching" else { return }
        
        let option = question.options?[indexPath.row] ?? ""
        
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

