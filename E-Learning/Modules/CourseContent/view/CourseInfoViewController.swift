//
//  CourseInfoViewController.swift
//  E-Learning
//
//  Created by aya on 04/12/2024.
//

import UIKit

class CourseInfoViewController: UIViewController, sendData {
    
    var introductionLabel = UILabel()
    var introductionDescriptionLabel = UILabel()
    var stackView = UIStackView()
    var containerView1 = UIView()
    var containerView2 = UIView()
    var containerView3 = UIView()
    var instractorView = UIView()
    var sectionTitle: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        updateLabel()
    }
    
    func sendData(_ data: Any) {
        sectionTitle = data as? String
        //        updateLabel()
    }
    
    private func updateLabel() {
        introductionLabel.text = sectionTitle ?? "No title"
    }
    
    private func setupUI() {
        
        introductionLabel.translatesAutoresizingMaskIntoConstraints = false
        introductionLabel.text = "Introduction to Scrum Master"
        introductionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(introductionLabel)
        
        introductionDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        introductionDescriptionLabel.numberOfLines = 0
        introductionDescriptionLabel.textColor = UIColor(named: "onboradColor")
        introductionDescriptionLabel.text = "This course is designed to help Scrum beginners learn the foundational knowledge to become proficient with Agile Scrum. Throughout the course, learners will explore Agile methodologies and benefits of building incrementally."
        introductionDescriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        view.addSubview(introductionDescriptionLabel)
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        containerView1 = UIView()
        containerView1.translatesAutoresizingMaskIntoConstraints = false
        containerView1.backgroundColor = .clear
        containerView1.layer.borderWidth = 1.0
        containerView1.layer.borderColor = UIColor(named: "border")?.cgColor ?? UIColor.lightGray.cgColor
        containerView1.layer.cornerRadius = 8
        containerView1.layer.shadowColor = UIColor.black.cgColor
        containerView1.layer.shadowOpacity = 0.1
        containerView1.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView1.layer.shadowRadius = 4
        stackView.addArrangedSubview(containerView1)
        
        containerView2 = UIView()
        containerView2.translatesAutoresizingMaskIntoConstraints = false
        containerView2.backgroundColor = .clear
        containerView2.layer.borderWidth = 1.0
        containerView2.layer.borderColor = UIColor(named: "border")?.cgColor ?? UIColor.lightGray.cgColor
        containerView2.layer.cornerRadius = 8
        containerView2.layer.shadowColor = UIColor.black.cgColor
        containerView2.layer.shadowOpacity = 0.1
        containerView2.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView2.layer.shadowRadius = 4
        stackView.addArrangedSubview(containerView2)
        
        containerView3 = UIView()
        containerView3.translatesAutoresizingMaskIntoConstraints = false
        containerView3.backgroundColor = .clear
        containerView3.layer.borderWidth = 1.0
        containerView3.layer.borderColor = UIColor(named: "border")?.cgColor ?? UIColor.lightGray.cgColor
        containerView3.layer.cornerRadius = 8
        containerView3.layer.shadowColor = UIColor.black.cgColor
        containerView3.layer.shadowOpacity = 0.1
        containerView3.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView3.layer.shadowRadius = 4
        stackView.addArrangedSubview(containerView3)
        
        let button1 = UIButton()
        button1.translatesAutoresizingMaskIntoConstraints = false
        let imageView1 = UIImageView()
        imageView1.image = UIImage(named: "mingcute_time-line")
        imageView1.contentMode = .scaleAspectFit
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        let label1 = UILabel()
        label1.text = "42 h   51 min"
        label1.numberOfLines = 0
        label1.textColor = UIColor(named: "myCustom")
        label1.font = UIFont.systemFont(ofSize: 14)
        label1.translatesAutoresizingMaskIntoConstraints = false
        let label2 = UILabel()
        label2.text = "23 Lessons"
        label2.numberOfLines = 0
        label2.textColor = UIColor(named: "myCustom")
        label2.font = UIFont.systemFont(ofSize: 14)
        label2.translatesAutoresizingMaskIntoConstraints = false
        button1.addSubview(imageView1)
        button1.addSubview(label1)
        button1.addSubview(label2)
        containerView1.addSubview(button1)
        
        NSLayoutConstraint.activate([
            
            button1.leadingAnchor.constraint(equalTo: containerView1.leadingAnchor),
            button1.trailingAnchor.constraint(equalTo: containerView1.trailingAnchor),
            button1.topAnchor.constraint(equalTo: containerView1.topAnchor),
            button1.bottomAnchor.constraint(equalTo: containerView1.bottomAnchor),
            
            imageView1.centerYAnchor.constraint(equalTo: button1.centerYAnchor, constant: -20),
            imageView1.centerXAnchor.constraint(equalTo: button1.centerXAnchor),
            imageView1.widthAnchor.constraint(equalToConstant: 30),
            imageView1.heightAnchor.constraint(equalToConstant: 30),
            
            label1.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: 2),
            label1.leadingAnchor.constraint(equalTo: button1.leadingAnchor, constant: 25),
            label1.trailingAnchor.constraint(equalTo: button1.trailingAnchor),
            
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 2),
            label2.leadingAnchor.constraint(equalTo: label1.leadingAnchor),
            label2.trailingAnchor.constraint(equalTo: label1.trailingAnchor),
        ])
        
        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        let imageView2 = UIImageView()
        imageView2.image = UIImage(named: "Vector 1")
        imageView2.contentMode = .scaleAspectFit
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        let labelView2 = UILabel()
        labelView2.text = "Quizzes"
        labelView2.textColor = UIColor(named: "myCustom")
        labelView2.font = UIFont.systemFont(ofSize: 14)
        labelView2.translatesAutoresizingMaskIntoConstraints = false
        button2.addSubview(imageView2)
        button2.addSubview(labelView2)
        containerView2.addSubview(button2)
        
        NSLayoutConstraint.activate([
            
            button2.leadingAnchor.constraint(equalTo: containerView2.leadingAnchor),
            button2.trailingAnchor.constraint(equalTo: containerView2.trailingAnchor),
            button2.topAnchor.constraint(equalTo: containerView2.topAnchor),
            button2.bottomAnchor.constraint(equalTo: containerView2.bottomAnchor),
            
            imageView2.centerYAnchor.constraint(equalTo: button2.centerYAnchor, constant: -20),
            imageView2.centerXAnchor.constraint(equalTo: button2.centerXAnchor),
            imageView2.widthAnchor.constraint(equalToConstant: 20),
            imageView2.heightAnchor.constraint(equalToConstant: 20),
            
            labelView2.topAnchor.constraint(equalTo: imageView2.bottomAnchor, constant: 8),
            labelView2.leadingAnchor.constraint(equalTo: button2.leadingAnchor, constant: 40),
            labelView2.trailingAnchor.constraint(equalTo: button2.trailingAnchor),
        ])
        
        let button3 = UIButton()
        button3.translatesAutoresizingMaskIntoConstraints = false
        let imageView3 = UIImageView()
        imageView3.image = UIImage(named: "Group")
        imageView3.contentMode = .scaleAspectFit
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        let labelView3 = UILabel()
        labelView3.text = "  Certificate of completion"
        labelView3.numberOfLines = 0
        labelView3.textColor = UIColor(named: "myCustom")
        labelView3.font = UIFont.systemFont(ofSize: 14)
        labelView3.translatesAutoresizingMaskIntoConstraints = false
        button3.addSubview(imageView3)
        button3.addSubview(labelView3)
        containerView3.addSubview(button3)
        
        NSLayoutConstraint.activate([
            
            button3.leadingAnchor.constraint(equalTo: containerView3.leadingAnchor),
            button3.trailingAnchor.constraint(equalTo: containerView3.trailingAnchor),
            button3.topAnchor.constraint(equalTo: containerView3.topAnchor),
            button3.bottomAnchor.constraint(equalTo: containerView3.bottomAnchor),
            
            imageView3.centerYAnchor.constraint(equalTo: button3.centerYAnchor, constant: -20),
            imageView3.centerXAnchor.constraint(equalTo: button3.centerXAnchor),
            imageView3.widthAnchor.constraint(equalToConstant: 20),
            imageView3.heightAnchor.constraint(equalToConstant: 20),
            
            labelView3.topAnchor.constraint(equalTo: imageView3.bottomAnchor, constant: 5),
            labelView3.leadingAnchor.constraint(equalTo: button3.leadingAnchor, constant: 20),
            labelView3.trailingAnchor.constraint(equalTo: button3.trailingAnchor),
        ])
        
        instractorView = UIView()
        instractorView.translatesAutoresizingMaskIntoConstraints = false
        instractorView.backgroundColor = UIColor(named: "myLearning")
        instractorView.layer.cornerRadius = 8
        instractorView.layer.shadowColor = UIColor.black.cgColor
        instractorView.layer.shadowOpacity = 0.1
        instractorView.layer.shadowOffset = CGSize(width: 0, height: 2)
        instractorView.layer.shadowRadius = 4
        view.addSubview(instractorView)
        
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "profile_placeholder")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.cornerRadius = 30
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.orange.cgColor
        profileImageView.clipsToBounds = true
        instractorView.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: instractorView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: instractorView.centerYAnchor, constant: -30),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        let nameLabel = UILabel()
        nameLabel.text = "Clifford Lampe"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        instractorView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: instractorView.topAnchor, constant: 15)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        instractorView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4)
        ])
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Lorem ipsum dolor sit amet, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor(named: "onboradColor")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        instractorView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: instractorView.trailingAnchor, constant: -4),
            descriptionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8)
        ])
        
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            introductionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            introductionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            introductionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            introductionLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            introductionDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            introductionDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            introductionDescriptionLabel.topAnchor.constraint(equalTo: introductionLabel.bottomAnchor, constant: 4),
            introductionDescriptionLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: introductionDescriptionLabel.bottomAnchor, constant: 10),
            stackView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            instractorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instractorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            instractorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            instractorView.heightAnchor.constraint(equalToConstant: 130),
            instractorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
        
    }
}
