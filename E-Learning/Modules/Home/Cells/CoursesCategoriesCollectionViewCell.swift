//
//  CoursesCollectionViewCell.swift
//  E-Learning
//
//  Created by aya on 20/11/2024.
//

import UIKit

class CoursesCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var titleCourse: UILabel!
    @IBOutlet weak var innerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerView.layer.cornerRadius = 10
        outerView.layer.masksToBounds = true
        outerView.layer.shadowColor = UIColor.gray.cgColor
        outerView.layer.shadowOpacity = 0.1
        outerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        outerView.layer.shadowRadius = 3
        outerView.layer.borderColor = UIColor.lightGray.cgColor
        outerView.layer.borderWidth = 0.3
        titleCourse.textAlignment = .center
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        self.selectedBackgroundView = highlightView
    }
    
    func configure(with category: CourseCategory) {
        titleCourse.text = category.name
        
        if let textColor = UIColor(hex: category.text_color) {
            titleCourse.textColor = textColor
        } else {
            titleCourse.textColor = .white
        }
        
        if let backgroundColor = UIColor(hex: category.color) {
            innerView.backgroundColor = backgroundColor
        }
    }
}
