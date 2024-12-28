//
//  FeaturedCoursesCollectionViewCell.swift
//  E-Learning
//
//  Created by aya on 20/11/2024.
//

import UIKit

class FeaturedCoursesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseConstractorTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerView.layer.cornerRadius = 15
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
        courseTitle.lineBreakMode = .byWordWrapping
        courseTitle.numberOfLines = 0
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: outerView.layer.cornerRadius).cgPath
    }
    
    func configureCourseTitle() {
        courseTitle.text = "Google UX\nDesign"
    }
    
}
