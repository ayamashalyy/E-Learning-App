//
//  CourseContentTableViewCell.swift
//  E-Learning
//
//  Created by aya on 05/12/2024.
//

import UIKit

class CourseContentTableViewCell: UITableViewCell {
    
    var numberLabel = UILabel()
    var titleLabel = UILabel()
    var durationLabel = UILabel()
    var typeLabel = UILabel()
    var completedIcon = UIImageView()
    var outerView = UIView()
    var innerTypeLabel = UIView()
    var innerDurationLabel = UIView()
    var tenantViewModel = TenantViewModel.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        innerDurationLabel = UIView()
        innerDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        innerDurationLabel.layer.cornerRadius = 8
        
        durationLabel.font = UIFont(name: "Roboto-Medium", size: 10)
        durationLabel.textAlignment = .center
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        innerDurationLabel.addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            durationLabel.leadingAnchor.constraint(equalTo: innerDurationLabel.leadingAnchor, constant: 4),
            durationLabel.topAnchor.constraint(equalTo: innerDurationLabel.topAnchor, constant: 4),
            durationLabel.trailingAnchor.constraint(equalTo: innerDurationLabel.trailingAnchor, constant: -4),
            durationLabel.bottomAnchor.constraint(equalTo: innerDurationLabel.bottomAnchor, constant: -4)
        ])
        stackView.addArrangedSubview(innerDurationLabel)
        
        innerTypeLabel = UIView()
        innerTypeLabel.layer.cornerRadius = 8
        innerTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.textAlignment = .center
        typeLabel.font = UIFont(name: "Roboto-Medium", size: 10)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        innerTypeLabel.addSubview(typeLabel)
        
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: innerTypeLabel.leadingAnchor, constant: 4),
            typeLabel.topAnchor.constraint(equalTo: innerTypeLabel.topAnchor, constant: 4),
            typeLabel.trailingAnchor.constraint(equalTo: innerTypeLabel.trailingAnchor, constant: -4),
            typeLabel.bottomAnchor.constraint(equalTo: innerTypeLabel.bottomAnchor, constant: -4)
        ])
        stackView.addArrangedSubview(innerTypeLabel)
        
        NSLayoutConstraint.activate([
            innerDurationLabel.widthAnchor.constraint(equalToConstant: 60),
            innerTypeLabel.widthAnchor.constraint(equalToConstant: 80),
            innerDurationLabel.heightAnchor.constraint(equalToConstant: 25),
            innerTypeLabel.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        
        outerView = UIView()
        outerView.translatesAutoresizingMaskIntoConstraints = false
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.textAlignment = .center
        numberLabel.layer.cornerRadius = 20
        numberLabel.layer.masksToBounds = true
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        outerView.addSubview(numberLabel)
        
        titleLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        outerView.addSubview(titleLabel)
        
        outerView.addSubview(stackView)
        
        completedIcon.translatesAutoresizingMaskIntoConstraints = false
        completedIcon.contentMode = .scaleAspectFit
        outerView.addSubview(completedIcon)
        
        contentView.addSubview(outerView)
        
        
        
        NSLayoutConstraint.activate([
            
            outerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            outerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            outerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            outerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            numberLabel.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 16),
            numberLabel.centerYAnchor.constraint(equalTo: outerView.centerYAnchor),
            numberLabel.widthAnchor.constraint(equalToConstant: 40),
            numberLabel.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: outerView.topAnchor, constant: 8),
            
            stackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            
            completedIcon.trailingAnchor.constraint(equalTo: outerView.trailingAnchor, constant: -16),
            completedIcon.centerYAnchor.constraint(equalTo: outerView.centerYAnchor),
            completedIcon.widthAnchor.constraint(equalToConstant: 24),
            completedIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        
    }
    
    func configure(with viewModel: CourseContentViewModel, indexPath: IndexPath) {
        guard let lesson = viewModel.getLesson(at: indexPath) else {
            return
        }
        numberLabel.text = String(format: "%02d", indexPath.row + 1)
        numberLabel.backgroundColor = lesson.isCompleted ?? false ? tenantViewModel.primaryColor : .white
        numberLabel.textColor = lesson.isCompleted ?? false ? .white : UIColor(named: "onboradColor")
        
        titleLabel.text = lesson.title
        titleLabel.textColor = lesson.isCompleted ?? false ? .black : UIColor(named: "policy2")
        
        durationLabel.text = viewModel.formatDuration(lesson.duration)
        durationLabel.textColor = lesson.isCompleted ?? false ? .black : UIColor(named: "policy2")
        
        typeLabel.text = lesson.type
        typeLabel.textColor = lesson.isCompleted ?? false ? .black : UIColor(named: "policy2")
        
        completedIcon.image = lesson.isCompleted ?? false ? UIImage(named: "Vector (1)") : nil
        
        innerDurationLabel.backgroundColor = lesson.isCompleted ?? false ? UIColor(named: "myLearning") : .white
        innerTypeLabel.backgroundColor = lesson.isCompleted ?? false ? UIColor(named: "myLearning") : .white
        outerView.backgroundColor = lesson.isCompleted ?? false ? .white : UIColor(named: "myLearning")
        
        outerView.layer.cornerRadius = 35
        outerView.layer.borderWidth = 1.0
        outerView.layer.borderColor = UIColor(named: "border")?.cgColor ?? UIColor.lightGray.cgColor
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.1
        outerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        outerView.layer.shadowRadius = 4
        contentView.clipsToBounds = true
    }
    
}
