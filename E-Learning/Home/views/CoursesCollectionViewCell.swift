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
        outerView.layer.borderColor = UIColor.gray.cgColor
        outerView.layer.borderWidth = 1.0
        
        
        
        
    }
    
    func configure(with text: String, color: UIColor) {
        titleCourse.text = text
        titleCourse.font = UIFont.systemFont(ofSize: 16)
        titleCourse.textAlignment = .center
        innerView.layer.backgroundColor = color.cgColor
        
    }
    
}
