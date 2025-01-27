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
        outerView.layer.cornerRadius = 5
    }
    
    func configure(optionText: String, isSelected: Bool) {
        optionLabel.text = optionText
        outerView.layer.borderColor = isSelected ? tenantViewModel.primaryColor?.cgColor: UIColor.lightGray.cgColor
        optionLabel.textColor = isSelected ? UIColor.black : UIColor(named: "policy")
    }
}
