//
//  SectionHeaderView.swift
//  E-Learning
//
//  Created by mayar on 19/11/2024.
//

import Foundation
import UIKit

protocol SectionHeaderViewDelegate: AnyObject {
    func didTapSeeAll(in section: Int)
}

class SectionHeaderView: UICollectionViewCell {
    
    var tenantViewModel = TenantViewModel.shared
    weak var delegate: SectionHeaderViewDelegate?
    
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
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        let color = tenantViewModel.primaryColor
        button.setTitleColor(color, for: .normal)
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
        actionButton.addTarget(self, action: #selector(handleSeeAllTap), for: .touchUpInside)
        
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
    
    @objc func handleSeeAllTap() {
        delegate?.didTapSeeAll(in: self.tag)
    }
    
    func configure(title: String, showAction: Bool = true) {
        
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        
        if showAction {
            actionButton.setTitle("See all".localized, for: .normal)
            actionButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14)
            
            let imageConfig = UIImage.SymbolConfiguration(pointSize: 8, weight: .medium)
            let smallerImage = UIImage(named: "navigate_next", in: Bundle.main, compatibleWith: nil)?.withConfiguration(imageConfig)
            let tintedArrowImage = smallerImage?.withRenderingMode(.alwaysTemplate)
            actionImageView.image = tintedArrowImage?.imageFlippedForRightToLeftLayoutDirection()
            
            if let customColor = tenantViewModel.primaryColor {
                actionButton.tintColor = customColor
                actionImageView.tintColor = customColor
            }
            
            actionButton.isHidden = false
            actionImageView.isHidden = false
            
        } else {
            actionButton.isHidden = true
            actionImageView.isHidden = true
        }
    }
}
