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
        outerView.layer.borderColor = UIColor.gray.cgColor
        outerView.layer.borderWidth = 1.0
        outerView.backgroundColor = tenantViewModel.primaryColor
        continueLabel.text = "Continue where you left off".localized
        
        arrow.setImage(UIImage(named: "arrow")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        courseProgress.progressTintColor = tenantViewModel.secondaryColor
        innerView.layer.cornerRadius = 6
        innerView.layer.masksToBounds = true
        innerView.layer.borderColor = UIColor.gray.cgColor
        innerView.layer.borderWidth = 1.0
        
    }
}
