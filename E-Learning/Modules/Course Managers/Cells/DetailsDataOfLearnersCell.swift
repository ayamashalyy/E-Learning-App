//
//  DetailsDataOfLearnersCell.swift
//  E-Learning
//
//  Created by aya on 04/01/2025.
//

import UIKit

class DetailsDataOfLearnersCell: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var myLearningCategory: UILabel!
    @IBOutlet weak var myLearningNameCourse: UILabel!
    @IBOutlet weak var myLearningConstractorName: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var myLearningProgressLabel: UILabel!
    @IBOutlet weak var myLearningProgress: UIProgressView!
    @IBOutlet weak var myLearningImage2: UIImageView!
    var tenantViewModel = TenantViewModel.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        outerView.layer.cornerRadius = 10
        outerView.layer.masksToBounds = true
        myLearningImage2.layer.cornerRadius = 8
        myLearningImage2.layer.masksToBounds = true
        myLearningProgress.progressTintColor = tenantViewModel.secondaryColor
        innerView.layer.cornerRadius = 4
        innerView.layer.masksToBounds = true
        myLearningCategory.textColor = tenantViewModel.primaryColor
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: outerView.layer.cornerRadius).cgPath
    }
    
    func configure(category: String, courseName: String, instructorName: String, progress: Float, image: String?) {
        myLearningCategory.text = category
        myLearningNameCourse.text = courseName
        myLearningConstractorName.text = instructorName
        myLearningProgress.setProgress(progress, animated: true)
        
        if let urlString = image, let url = URL(string: urlString) {
            myLearningImage2.sd_setImage(with: url, placeholderImage: UIImage(named: "myLearning"))
        } else {
            myLearningImage2.image = UIImage(named: "myLearning") ?? UIImage()
        }
        
        let progressPercentage = Int(progress * 100)
        myLearningProgressLabel.text = "\(progressPercentage)%"
    }
}
