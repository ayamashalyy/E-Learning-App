//
//  LearnersCell.swift
//  E-Learning
//
//  Created by aya on 03/01/2025.
//

import UIKit

class LearnersCell: UITableViewCell {
    
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coursesLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var backButton: UIImageView!
    var tenantViewModel = TenantViewModel.shared
    
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
        progressView.progressTintColor = tenantViewModel.secondaryColor
        detailsButton.setTitle("Details".localized, for: .normal)
        detailsButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 12)
        detailsButton.setTitleColor(tenantViewModel.primaryColor, for: .normal)
        backButton.image = UIImage(named: "navigate_next")?.imageFlippedForRightToLeftLayoutDirection()
        backButton.tintColor = tenantViewModel.primaryColor
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        self.selectedBackgroundView = highlightView
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: outerView.layer.cornerRadius).cgPath
    }
    
    func configure(with learner: Learner) {
        profileImageView.image = learner.profileImage
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.borderWidth = 0.8
        profileImageView.layer.borderColor = tenantViewModel.secondaryColor?.cgColor
        profileImageView.clipsToBounds = true
        nameLabel.text = learner.name
        let coursesText = "\(learner.coursesCompleted) "
        let completeText = "Course Complete"
        
        let attributedString = NSMutableAttributedString(string: coursesText, attributes: [
            .foregroundColor: tenantViewModel.primaryColor ?? UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 14)
        ])
        
        let completeAttributed = NSAttributedString(string: completeText, attributes: [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
        ])
        
        attributedString.append(completeAttributed)
        coursesLabel.attributedText = attributedString
        progressView.progress = learner.progress
        progressLabel.text = "\(Int(learner.progress * 100))%"
    }
}
