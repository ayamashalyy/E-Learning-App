//
//  ProfileItemCell.swift
//  E-Learning
//
//  Created by aya on 28/11/2024.
//

import UIKit

class ProfileItemCell: UITableViewCell {
    
    var itemLabel: UILabel!
    var iconImageView: UIImageView!
    var outerView: UIView!
    var arrowButton: UIButton!
    var englishButton: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        outerView = UIView()
        outerView.translatesAutoresizingMaskIntoConstraints = false
        
        itemLabel = UILabel()
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        
        arrowButton = UIButton(type: .custom)
        arrowButton.translatesAutoresizingMaskIntoConstraints = false
        arrowButton.setImage(UIImage(named: "navigate_next"), for: .normal)
        arrowButton.isHidden = false
        
        englishButton = UIButton(type: .custom)
        englishButton.translatesAutoresizingMaskIntoConstraints = false
        englishButton.setTitle("English", for: .normal)
        englishButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        englishButton.setTitleColor(UIColor(named: "myCustom"), for: .normal)
        englishButton.contentHorizontalAlignment = .left
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let underlineString = NSAttributedString(string: "English", attributes: underlineAttribute)
        englishButton.setAttributedTitle(underlineString, for: .normal)
        englishButton.isHidden = true
        
        contentView.addSubview(outerView)
        outerView.addSubview(itemLabel)
        outerView.addSubview(iconImageView)
        outerView.addSubview(arrowButton)
        outerView.addSubview(englishButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            outerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            outerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
            outerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            outerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            
            iconImageView.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 25),
            iconImageView.centerYAnchor.constraint(equalTo: outerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            itemLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 25),
            itemLabel.centerYAnchor.constraint(equalTo: outerView.centerYAnchor),
            itemLabel.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -15),
            
            arrowButton.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -35),
            arrowButton.centerYAnchor.constraint(equalTo: outerView.centerYAnchor),
            arrowButton.widthAnchor.constraint(equalToConstant: 24),
            arrowButton.heightAnchor.constraint(equalToConstant: 24),
            
            englishButton.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -35),
            englishButton.centerYAnchor.constraint(equalTo: outerView.centerYAnchor),
            englishButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(for item: ProfileItem, isLanguage: Bool) {
        iconImageView.image = UIImage(named: item.imageName)
        
        if isLanguage {
            itemLabel.text = "Language"
            englishButton.isHidden = false
            arrowButton.isHidden = true
        } else {
            itemLabel.text = item.title
            arrowButton.isHidden = false
            englishButton.isHidden = true
        }
        
        selectionStyle = .none
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .white
        self.selectedBackgroundView = selectedBackgroundView
    }
}
