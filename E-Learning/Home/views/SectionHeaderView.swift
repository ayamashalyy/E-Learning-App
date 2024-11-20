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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        titleLabel.text = title
//        titleLabel.font = UIFont(name: "Roboto-Bold", size: 24.0)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        actionButton.setTitle("See all ", for: .normal)

        // Create a smaller version of the system image
          let imageConfig = UIImage.SymbolConfiguration(pointSize: 8, weight: .medium)
          let smallerImage = UIImage(systemName: "greaterthan", withConfiguration: imageConfig)
          actionButton.setImage(smallerImage, for: .normal)

          // Adjust the button layout to place the image on the right
          actionButton.semanticContentAttribute = .forceRightToLeft
          actionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0) // Space between text and image
        }

}
