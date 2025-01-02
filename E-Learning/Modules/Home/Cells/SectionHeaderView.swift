//
//  SectionHeaderView.swift
//  E-Learning
//
//  Created by mayar on 19/11/2024.
//

import Foundation
import UIKit

class SectionHeaderView: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        return stackView
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor(named:"myCustom2"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(actionStackView)
        actionStackView.addArrangedSubview(actionButton)
        actionStackView.addArrangedSubview(actionImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            actionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            actionStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        actionButton.setTitle("See all".localized, for: .normal)
        actionButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 8, weight: .medium)
        let smallerImage = UIImage(named: "navigate_next", in: Bundle.main, compatibleWith: nil)?.withConfiguration(imageConfig)
        let tintedArrowImage = smallerImage?.withRenderingMode(.alwaysTemplate)
        actionImageView.image = tintedArrowImage?.imageFlippedForRightToLeftLayoutDirection()
        
        if let customColor = UIColor(named: "myCustom") {
            actionButton.tintColor = customColor
            actionImageView.tintColor = customColor
        }
    }
}
