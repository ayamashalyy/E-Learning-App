//
//  MultipleChoiceCell.swift
//  E-Learning
//
//  Created by aya on 09/12/2024.
//

import UIKit

class MultipleChoiceCell: UICollectionViewCell {
    
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var checkButton: UIImageView!
    
    @IBOutlet weak var optionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerView.layer.borderWidth = 1
        outerView.layer.borderColor = UIColor.lightGray.cgColor
        outerView.layer.cornerRadius = 5
    }
    
    func configure(optionText: String, isSelected: Bool) {
        optionLabel.text = optionText
        checkButton.image = UIImage(named: isSelected ? "check_box" : "check_box_outline_blank")
        outerView.layer.borderColor = isSelected ? UIColor(named: "myCustom")?.cgColor: UIColor.lightGray.cgColor
        optionLabel.textColor = isSelected ? UIColor.black : UIColor(named: "policy")
    }

}
