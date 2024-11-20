//
//  coursesTitlesCellCollectionViewCell.swift
//  E-Learning
//
//  Created by mayar on 19/11/2024.
//

import UIKit

class coursesTitlesCellCollectionViewCell: UICollectionViewCell {
    
private let actionButton: UIButton = {
            let button = UIButton(type: .system)
            button.layer.cornerRadius = 20
            button.layer.masksToBounds = true
            button.setTitleColor(.white, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.imageView?.contentMode = .scaleAspectFill
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            return button
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(actionButton)
            NSLayoutConstraint.activate([
                      actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                      actionButton.topAnchor.constraint(equalTo: topAnchor, constant: 8)])
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        

        func configure(title: String, useFirstImage: Bool, width: CGFloat, height: CGFloat) {
            actionButton.setTitle(title, for: .normal)
            
            actionButton.widthAnchor.constraint(equalToConstant: width).isActive = true
            actionButton.heightAnchor.constraint(equalToConstant: height).isActive = true

        actionButton.setTitle(title, for: .normal)
        let imageName = useFirstImage ? "Rectangle 2" : "splash"
        let image = UIImage(named: imageName)
        actionButton.setBackgroundImage(image, for: .normal)
    }
    
}
