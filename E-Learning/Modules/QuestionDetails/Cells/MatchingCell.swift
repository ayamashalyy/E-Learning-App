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
        outerView.layer.cornerRadius = 8
        outerView.layer.masksToBounds = true
        
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
        
        if isReviewMode {
            if isCorrect {
                optionLabel.textColor = tenantViewModel.primaryColor
                outerView.layer.borderColor = tenantViewModel.primaryColor?.cgColor
                iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
                iconImageView.tintColor = .green
            } else {
                optionLabel.textColor = .red
                outerView.layer.borderColor = UIColor.red.cgColor
                iconImageView.image = UIImage(systemName: "xmark.circle.fill")
                iconImageView.tintColor = .red
            }
        } else {
            outerView.layer.borderColor = UIColor.lightGray.cgColor
            optionLabel.textColor = UIColor(named: "policy")
            iconImageView.image = nil
        }
    }
}
