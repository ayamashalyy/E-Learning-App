//
//  NoCoursesCellCollectionViewCell.swift
//  E-Learning
//
//  Created by Aya Mashaly on 24/03/2025.
//

import UIKit

class NoCoursesCellCollectionViewCell: UICollectionViewCell {
    static let identifier = "NoCoursesCell"
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No courses available"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
