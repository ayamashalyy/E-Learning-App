//
//  CourseViewController.swift
//  E-Learning
//
//  Created by aya on 04/12/2024.
//

import UIKit
import AVFoundation

class CourseViewController: UIViewController {
    
    var lessonContentView: LessonContentView!
    var stackView: UIStackView!
    var selectedButton: UIButton?
    var scrollView: UIScrollView!
    var contentView: UIView!
    var tenantViewModel = TenantViewModel.shared
    var backButtonImage: UIImage!
    var courseSlug: String?
    var courseIsEnroll: Bool?
    var viewModel: CourseOverviewViewModel?
    private var userSessionManager = UserSessionManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = viewModel?.getCourse()?.title
        if let courseSlug = courseSlug {
            print("Course Slug in CourseViewController: \(courseSlug)")
        }
        backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        
        if let backButtonImage = backButtonImage {
            let tintedImage = backButtonImage.withTintColor(tenantViewModel.primaryColor ?? .blue, renderingMode: .alwaysOriginal)
            let backButton = UIBarButtonItem(image: tintedImage, style: .plain, target: self, action: #selector(cancelTapped))
            self.navigationItem.leftBarButtonItem = backButton
        }
        setupUI()
        setupConstraints()
        displayFirstLesson()
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        scrollView.addSubview(contentView)
        
        lessonContentView = LessonContentView()
        lessonContentView.backgroundColor = .clear
        lessonContentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lessonContentView)
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let containerView2 = UIView()
        let button2 = UIButton(type: .custom)
        button2.setTitle("Content".localized, for: .normal)
        button2.setTitleColor(UIColor.gray, for: .normal)
        button2.setTitleColor(tenantViewModel.primaryColor, for: .selected)
        button2.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 18)
        button2.titleLabel?.textAlignment = .left
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.tag = 2
        button2.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        containerView2.addSubview(button2)
        
        let underline2 = UIView()
        underline2.backgroundColor = UIColor.gray
        underline2.translatesAutoresizingMaskIntoConstraints = false
        containerView2.addSubview(underline2)
        
        NSLayoutConstraint.activate([
            button2.centerXAnchor.constraint(equalTo: containerView2.centerXAnchor),
            button2.centerYAnchor.constraint(equalTo: containerView2.centerYAnchor),
            underline2.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 10),
            underline2.leadingAnchor.constraint(equalTo: containerView2.leadingAnchor),
            underline2.trailingAnchor.constraint(equalTo: containerView2.trailingAnchor),
            underline2.heightAnchor.constraint(equalToConstant: 4),
            underline2.bottomAnchor.constraint(equalTo: containerView2.bottomAnchor)
        ])
        stackView.addArrangedSubview(containerView2)
        
        let containerView1 = UIView()
        let button1 = UIButton(type: .custom)
        button1.setTitle("Course Info".localized, for: .normal)
        button1.setTitleColor(UIColor.gray, for: .normal)
        button1.setTitleColor(tenantViewModel.primaryColor, for: .selected)
        button1.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 18)
        button1.translatesAutoresizingMaskIntoConstraints = false
        button1.tag = 1
        button1.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        containerView1.addSubview(button1)
        
        let underline1 = UIView()
        underline1.backgroundColor = UIColor.gray
        underline1.translatesAutoresizingMaskIntoConstraints = false
        containerView1.addSubview(underline1)
        
        NSLayoutConstraint.activate([
            button1.centerXAnchor.constraint(equalTo: containerView1.centerXAnchor),
            button1.centerYAnchor.constraint(equalTo: containerView1.centerYAnchor),
            underline1.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 10),
            underline1.leadingAnchor.constraint(equalTo: containerView1.leadingAnchor),
            underline1.trailingAnchor.constraint(equalTo: containerView1.trailingAnchor),
            underline1.heightAnchor.constraint(equalToConstant: 4),
            underline1.bottomAnchor.constraint(equalTo: containerView1.bottomAnchor)
        ])
        stackView.addArrangedSubview(containerView1)
        
        let containerView3 = UIView()
        let button3 = UIButton(type: .custom)
        button3.setTitle("Interactions".localized, for: .normal)
        button3.setTitleColor(UIColor.gray, for: .normal)
        button3.setTitleColor(tenantViewModel.primaryColor, for: .selected)
        button3.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 18)
        button3.translatesAutoresizingMaskIntoConstraints = false
        button3.tag = 3
        button3.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        containerView3.addSubview(button3)
        
        let underline3 = UIView()
        underline3.backgroundColor = UIColor.gray
        underline3.translatesAutoresizingMaskIntoConstraints = false
        containerView3.addSubview(underline3)
        
        NSLayoutConstraint.activate([
            button3.centerXAnchor.constraint(equalTo: containerView3.centerXAnchor),
            button3.centerYAnchor.constraint(equalTo: containerView3.centerYAnchor),
            underline3.topAnchor.constraint(equalTo: button3.bottomAnchor, constant: 10),
            underline3.leadingAnchor.constraint(equalTo: containerView3.leadingAnchor),
            underline3.trailingAnchor.constraint(equalTo: containerView3.trailingAnchor),
            underline3.heightAnchor.constraint(equalToConstant: 4),
            underline3.bottomAnchor.constraint(equalTo: containerView3.bottomAnchor)
        ])
        stackView.addArrangedSubview(containerView3)
        
        if let firstButton = containerView2.subviews.first(where: { $0 is UIButton }) as? UIButton {
            buttonTapped(firstButton)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if let selectedButton = selectedButton {
            selectedButton.setTitleColor(UIColor.gray, for: .normal)
            selectedButton.isSelected = false
            
            if let containerView = selectedButton.superview {
                if let underline = containerView.subviews.first(where: { $0 != selectedButton }) {
                    underline.backgroundColor = UIColor.gray
                }
            }
        }
        
        sender.isSelected = true
        sender.setTitleColor(tenantViewModel.primaryColor, for: .normal)
        
        if let containerView = sender.superview {
            if let underline = containerView.subviews.first(where: { $0 != sender }) {
                underline.backgroundColor = tenantViewModel.primaryColor
            }
        }
        
        selectedButton = sender
        loadSubView(sender.tag)
    }
    
    private func loadSubView(_ tag: Int) {
        self.removeAllSubView(mainContainerView: contentView)
        switch tag {
        case 1:
            self.moveToSubView(
                mainContainerView: contentView,
                identifier: "CourseInfoViewController",
                storyboardName: "Main",
                CourseInfoViewController.self,
                data: self.viewModel)
            
        case 2:
            self.moveToSubView(
                mainContainerView: contentView,
                identifier: "CourseContentViewController",
                storyboardName: "Main",
                CourseContentViewController.self,
                data: self.viewModel
            )
        case 3:
            self.moveToSubView(
                mainContainerView: contentView,
                identifier: "CourseInteractionsViewController",
                storyboardName: "Main",
                CourseInteractionsViewController.self,
                data: self.viewModel
            )
            
        default:
            print("No View found!")
        }
    }
    
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            lessonContentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            lessonContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lessonContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lessonContentView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: lessonContentView.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lessonContentView?.layoutSubviews()
    }
    
    func displayLesson() {
        print("--- Display Lesson Called ---")
        guard let viewModel = viewModel else {
            print("ViewModel is nil")
            return
        }
        lessonContentView.configure(with: viewModel)
        lessonContentView.layoutIfNeeded()
    }
    
    private func displayFirstLesson() {
        guard let viewModel = viewModel else {
            print("ViewModel is nil in displayFirstLesson")
            return
        }
        
        if let firstSection = viewModel.getSections().first,
           let firstLesson = firstSection.lessons?.first {
            viewModel.setSelectedLesson(firstLesson)
            lessonContentView.configure(with: viewModel)
        } else {
            print("No lessons available to display")
            lessonContentView.isHidden = true
        }
    }
}

extension CourseViewController: callDataBack {
    func sendDataBack(_ data: Any) {
        print(data as? String ?? "")
    }
}
