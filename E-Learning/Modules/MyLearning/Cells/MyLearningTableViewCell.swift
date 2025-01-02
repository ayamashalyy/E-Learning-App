//
//  MyLearningTableViewCell.swift
//  E-Learning
//
//  Created by aya on 23/11/2024.
//

import UIKit

class MyLearningTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var myLearningCategory: UILabel!
    @IBOutlet weak var myLearningNameCourse: UILabel!
    @IBOutlet weak var myLearningConstractorName: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var myLearningBtn: UIButton!
    @IBOutlet weak var myLearningProgressLabel: UILabel!
    @IBOutlet weak var myLearningProgress: UIProgressView!
    @IBOutlet weak var myLearningImage2: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        outerView.layer.cornerRadius = 10
        outerView.layer.masksToBounds = true
        myLearningImage2.layer.cornerRadius = 8
        myLearningImage2.layer.masksToBounds = true
        
        innerView.layer.cornerRadius = 4
        innerView.layer.masksToBounds = true
        
        outerView.layer.shadowColor = UIColor.gray.cgColor
        outerView.layer.shadowOpacity = 0.3
        outerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        outerView.layer.shadowRadius = 6
        outerView.layer.borderColor = UIColor.lightGray.cgColor
        outerView.layer.borderWidth = 0.5
        
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        self.selectedBackgroundView = highlightView
        
        myLearningBtn.layer.cornerRadius = myLearningBtn.bounds.height / 2
        myLearningBtn.layer.masksToBounds = true
        myLearningBtn.backgroundColor = UIColor(named: "myCustom")
        myLearningBtn.layer.borderColor = nil
        myLearningBtn.tintColor = nil
        myLearningBtn.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 8)
        myLearningBtn.layer.borderWidth = 0
        myLearningBtn.layer.shadowOpacity = 0
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: outerView.layer.cornerRadius).cgPath
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    func configureCell(isInProgress: Bool = false, isInAssigned: Bool = false, isInCompleted: Bool = false) {
        
        myLearningImage2.removeConstraints(myLearningImage2.constraints)
        
        
        checkImage.isHidden = isInProgress || isInAssigned
        myLearningProgress.isHidden = isInAssigned
        myLearningProgressLabel.isHidden = isInAssigned
        myLearningBtn.imageView?.isHidden = isInProgress || isInAssigned
        
        
        myLearningImage2.translatesAutoresizingMaskIntoConstraints = false
        if isInProgress {
            myLearningImage2.widthAnchor.constraint(equalToConstant: 90).isActive = true
            myLearningProgress.setProgress(0.5, animated: true)
            myLearningProgressLabel.text = "50%".localized
            myLearningBtn.setTitle("Continue!".localized, for: .normal)
        } else if isInAssigned {
            myLearningImage2.widthAnchor.constraint(equalToConstant: 90).isActive = true
            myLearningBtn.setTitle("Start now!".localized, for: .normal)
        } else if isInCompleted {
            myLearningImage2.widthAnchor.constraint(equalToConstant: 80).isActive = true
            myLearningProgress.setProgress(1.0, animated: true)
            myLearningProgressLabel.text = "100%".localized
            myLearningBtn.setTitle("Share Certification".localized, for: .normal)
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 8, weight: .medium)
            let smallerImage = UIImage(named: "uil_share", in: Bundle.main, compatibleWith: nil)?.withConfiguration(imageConfig)
            let tintedArrowImage = smallerImage?.withRenderingMode(.alwaysTemplate)
            myLearningBtn.setImage(tintedArrowImage?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
            myLearningBtn.semanticContentAttribute = .forceRightToLeft
            let spacing: CGFloat = 10
            myLearningBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: spacing)
            myLearningBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
            myLearningBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
            myLearningBtn.layoutIfNeeded()
        }
        
        self.layoutIfNeeded()
    }
}
