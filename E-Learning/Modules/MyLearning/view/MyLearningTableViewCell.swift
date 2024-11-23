//
//  MyLearningTableViewCell.swift
//  E-Learning
//
//  Created by aya on 23/11/2024.
//

import UIKit

class MyLearningTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var myLearningImage: UIView!
    @IBOutlet weak var myLearningCategory: UILabel!
    @IBOutlet weak var myLearningNameCourse: UILabel!
    @IBOutlet weak var myLearningConstractorName: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var myLearningBtn: UIButton!
    @IBOutlet weak var myLearningProgressLabel: UILabel!
    @IBOutlet weak var myLearningProgress: UIProgressView!
    @IBOutlet weak var myLearningImage2: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var shareCertificationBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        outerView.layer.cornerRadius = 10
        outerView.layer.masksToBounds = true
        myLearningImage.layer.cornerRadius = 8
        myLearningImage.layer.masksToBounds = true
        
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
        myLearningBtn.layer.borderWidth = 0
        myLearningBtn.layer.shadowOpacity = 0
        print("Button frame: \(myLearningBtn.frame)")
        print("Button backgroundColor: \(String(describing: myLearningBtn.backgroundColor))")
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: outerView.layer.cornerRadius).cgPath
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    func configureCell(isInProgress: Bool = false, isInAssigned: Bool = false, isInCompleted: Bool = false) {
        
        checkImage.isHidden = isInProgress || isInAssigned
        myLearningProgress.isHidden = isInAssigned
        myLearningProgressLabel.isHidden = isInAssigned
        shareCertificationBtn.isHidden = isInProgress || isInAssigned
        
        if isInProgress {
            
            myLearningProgress.setProgress(0.5, animated: true)
            myLearningProgressLabel.text = "50%"
            myLearningBtn.setTitle("Continue!", for: .normal)
        } else if isInAssigned {
            
            myLearningBtn.setTitle("Start now!", for: .normal)
        } else if isInCompleted {
            
            myLearningProgress.setProgress(1.0, animated: true)
            myLearningProgressLabel.text = "100%"
            myLearningBtn.setTitle("Share Certification", for: .normal)
        }
    }
    
    
    
}
