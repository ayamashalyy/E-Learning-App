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
    var question: Question!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("QuestionVC viewDidLoad")
        setDataQuestion(question: question)
        configureCollectionView()
        
    }
    
    func configureCollectionView() {
        collectionQuestion.delegate = self
        collectionQuestion.dataSource = self
        collectionQuestion.register(UINib(nibName: "SingleChoiceCell", bundle: nil), forCellWithReuseIdentifier: "SingleChoiceCell")
        collectionQuestion.register(UINib(nibName: "MultipleChoiceCell", bundle: nil), forCellWithReuseIdentifier: "MultipleChoiceCell")
        collectionQuestion.register(UINib(nibName: "MatchingCell", bundle: nil), forCellWithReuseIdentifier: "MatchingCell")
    }
    
    func setDataQuestion(question: Question) {
        self.question = question
        self.questionText.text = question.questionText
    }
}

extension QuestionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        question?.answers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch question.type {
        case .singleChoice, .trueFalse:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SingleChoiceCell", for: indexPath) as? SingleChoiceCell else {
                return UICollectionViewCell()
            }
            let answer = question.answers[indexPath.row]
            cell.configure(optionText: answer.text, isSelected: answer.isSelected)
            return cell
        case .multipleChoice:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultipleChoiceCell", for: indexPath) as? MultipleChoiceCell else {
                return UICollectionViewCell()
            }
            
            let answer = question.answers[indexPath.row]
            cell.configure(optionText: answer.text, isSelected: answer.isSelected)
            return cell
        case .matching:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchingCell", for: indexPath) as? MatchingCell else {
                return UICollectionViewCell()
            }
            
            let answer = question.answers[indexPath.row]
            cell.configure(optionText: answer.text, isSelected: answer.isSelected)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch question.type {
        case .trueFalse, .singleChoice, .multipleChoice:
            return CGSize(width: collectionView.frame.width, height: 60)
        case .matching:
            return CGSize(width: collectionView.frame.width / 2 - 10, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard var question = self.question else { return }
        
        switch question.type {
        case .trueFalse, .singleChoice:
            
            question.answers.indices.forEach { index in
                question.answers[index].isSelected = (index == indexPath.row)
            }
            
        case .multipleChoice:
            if question.answers[indexPath.row].isSelected {
                question.answers[indexPath.row].isSelected = false
            } else {
                question.answers[indexPath.row].isSelected = true
            }
            
        case .matching:
            if question.answers[indexPath.row].isSelected {
                question.answers[indexPath.row].isSelected = false
            } else {
                question.answers[indexPath.row].isSelected = true
            }
        }
        
        self.question = question
        collectionView.reloadData()
    }
}

