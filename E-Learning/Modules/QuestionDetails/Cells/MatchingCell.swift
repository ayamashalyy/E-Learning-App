//
//  MatchingCell.swift
//  E-Learning
//
//  Created by aya on 10/12/2024.
//

import UIKit

class MatchingCell: UICollectionViewCell {
    
    var tenantViewModel = TenantViewModel.shared
    
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var optionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerView.layer.borderWidth = 1
        outerView.layer.borderColor = UIColor.lightGray.cgColor
        outerView.layer.cornerRadius = 8
        outerView.layer.masksToBounds = true
    }
    
    func configure(optionText: String, isSelected: Bool) {
        optionLabel.text = optionText
        outerView.layer.borderColor =  UIColor.lightGray.cgColor
        optionLabel.textColor = UIColor(named: "policy")
    }
}
