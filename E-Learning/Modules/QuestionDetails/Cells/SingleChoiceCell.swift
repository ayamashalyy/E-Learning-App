//
//  SingleChoiceCell.swift
//  E-Learning
//
//  Created by aya on 09/12/2024.
//

import UIKit

class SingleChoiceCell: UICollectionViewCell {
    
    var tenantViewModel = TenantViewModel.shared
    
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var radioButton: UIImageView!
    
    @IBOutlet weak var optionLabel: UILabel!
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerView.layer.borderWidth = 1
        outerView.layer.borderColor = UIColor.lightGray.cgColor
        outerView.layer.cornerRadius = 5
        
        contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -10),
            iconImageView.centerYAnchor.constraint(equalTo: outerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func configure(optionText: String, isSelected: Bool, isReviewMode: Bool = false, isCorrect: Bool = false) {
        optionLabel.text = optionText
        radioButton.image = UIImage(named: isSelected ? "radio_selected" : "radio_unselected")
        
        if isReviewMode {
            if isCorrect && isSelected {
                optionLabel.textColor = tenantViewModel.primaryColor
                radioButton.tintColor = tenantViewModel.primaryColor
                outerView.layer.borderColor = tenantViewModel.primaryColor?.cgColor
                iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
                iconImageView.tintColor = tenantViewModel.primaryColor
            } else if isSelected && !isCorrect {
                optionLabel.textColor = .red
                radioButton.tintColor = .red
                outerView.layer.borderColor = UIColor.red.cgColor
                iconImageView.image = UIImage(systemName: "xmark.circle.fill")
                iconImageView.tintColor = .red
            } else if isCorrect && !isSelected {
                optionLabel.textColor = tenantViewModel.primaryColor
                radioButton.tintColor = tenantViewModel.primaryColor
                outerView.layer.borderColor = tenantViewModel.primaryColor?.cgColor
                iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
                iconImageView.tintColor = tenantViewModel.primaryColor
            } else {
                optionLabel.textColor = UIColor(named: "policy")
                radioButton.tintColor = UIColor.lightGray
                outerView.layer.borderColor = UIColor.lightGray.cgColor
                iconImageView.image = nil
            }
        } else {
            optionLabel.textColor = UIColor(named: "policy")
            outerView.layer.borderColor = isSelected ? tenantViewModel.primaryColor?.cgColor : UIColor.lightGray.cgColor
            radioButton.tintColor = tenantViewModel.primaryColor
            iconImageView.image = nil
        }
    }
}
