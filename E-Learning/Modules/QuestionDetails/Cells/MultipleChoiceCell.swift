//
//  MultipleChoiceCell.swift
//  E-Learning
//
//  Created by aya on 09/12/2024.
//

import UIKit

class MultipleChoiceCell: UICollectionViewCell {
    
    var tenantViewModel = TenantViewModel.shared
    
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var checkButton: UIImageView!
    
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
        checkButton.image = UIImage(named: isSelected ? "check_box" : "check_box_outline_blank")
        
        if isReviewMode {
            if isCorrect && isSelected {
                optionLabel.textColor = tenantViewModel.primaryColor
                checkButton.tintColor = tenantViewModel.primaryColor
                outerView.layer.borderColor = tenantViewModel.primaryColor?.cgColor
                iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
                iconImageView.tintColor = tenantViewModel.primaryColor
            } else if isSelected && !isCorrect {
                optionLabel.textColor = .red
                checkButton.tintColor = .red
                outerView.layer.borderColor = UIColor.red.cgColor
                iconImageView.image = UIImage(systemName: "xmark.circle.fill")
                iconImageView.tintColor = .red
            } else if isCorrect && !isSelected {
                optionLabel.textColor = tenantViewModel.primaryColor
                checkButton.tintColor = tenantViewModel.primaryColor
                outerView.layer.borderColor = tenantViewModel.primaryColor?.cgColor
                iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
                iconImageView.tintColor = tenantViewModel.primaryColor
            } else {
                optionLabel.textColor = UIColor(named: "policy")
                checkButton.tintColor = UIColor.lightGray
                outerView.layer.borderColor = UIColor.lightGray.cgColor
                iconImageView.image = nil
            }
        } else {
            checkButton.tintColor = tenantViewModel.primaryColor
            outerView.layer.borderColor = isSelected ? tenantViewModel.primaryColor?.cgColor : UIColor.lightGray.cgColor
            optionLabel.textColor = UIColor(named: "policy")
            iconImageView.image = nil
        }
    }
}
