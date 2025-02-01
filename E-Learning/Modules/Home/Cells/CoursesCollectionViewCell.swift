//
//  CoursesCollectionViewCell.swift
//  E-Learning
//
//  Created by aya on 20/11/2024.
//

import UIKit

class CoursesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var titleCourse: UILabel!
    @IBOutlet weak var innerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerView.layer.cornerRadius = 10
        outerView.layer.masksToBounds = true
        outerView.layer.shadowColor = UIColor.gray.cgColor
        outerView.layer.shadowOpacity = 0.3
        outerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        outerView.layer.shadowRadius = 6
        outerView.layer.borderColor = UIColor.lightGray.cgColor
        outerView.layer.borderWidth = 0.5
        
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        self.selectedBackgroundView = highlightView
    }
    
    func configure(with text: String, color: UIColor) {
        titleCourse.text = text
        titleCourse.textAlignment = .center
        innerView.layer.backgroundColor = color.cgColor
        
    }
}
