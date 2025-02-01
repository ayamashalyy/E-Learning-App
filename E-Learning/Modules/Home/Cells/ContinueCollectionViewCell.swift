//
//  ContinueCollectionViewCell.swift
//  E-Learning
//
//  Created by aya on 19/11/2024.
//

import UIKit

class ContinueCollectionViewCell: UICollectionViewCell {
    
    var tenantViewModel = TenantViewModel.shared
    @IBOutlet weak var outerView: UIView!
    @IBAction func arrow(_ sender: UIButton) {
    }
    
    @IBOutlet weak var arrow: UIButton!
    
    @IBOutlet weak var continueLabel: UILabel!
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var titleCourse: UILabel!
    @IBOutlet weak var constratorNameCourse: UILabel!
    @IBOutlet weak var courseProgressRaico: UILabel!
    @IBOutlet weak var courseProgress: UIProgressView!
    @IBOutlet weak var innerView: UIStackView!
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
        outerView.backgroundColor = tenantViewModel.primaryColor
        continueLabel.text = "Continue where you left off".localized
        
        arrow.setImage(UIImage(named: "arrow")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        courseProgress.progressTintColor = tenantViewModel.secondaryColor
        innerView.layer.cornerRadius = 6
        innerView.layer.masksToBounds = true
        innerView.layer.shadowColor = UIColor.gray.cgColor
        innerView.layer.shadowOpacity = 0.3
        innerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        innerView.layer.shadowRadius = 6
        innerView.layer.borderColor = UIColor.lightGray.cgColor
        innerView.layer.borderWidth = 0.5
        
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        self.selectedBackgroundView = highlightView
    }
}
