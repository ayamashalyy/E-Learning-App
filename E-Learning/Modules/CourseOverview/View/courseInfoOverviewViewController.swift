//
//  courseInfoOverviewViewController.swift
//  E-Learning
//
//  Created by aya on 25/12/2024.
//

import UIKit

class courseInfoOverviewViewController: UIViewController, sendData {
    
    var introductionLabel = UILabel()
    var introductionDescriptionLabel = UILabel()
    var stackView = UIStackView()
    var containerView1 = UIView()
    var durationLabel = UILabel()
    var lessonsCountLabel = UILabel()
    var containerView2 = UIView()
    var quizzesLabel = UILabel()
    var containerView3 = UIView()
    var certificateLabel = UILabel()
    var instractorView = UIView()
    var instructorNameLabel = UILabel()
    var instructorTitleLabel = UILabel()
    var instructorDescriptionLabel = UILabel()
    var instructorProfileImageView = UIImageView()
    var applyButton: UIButton!
    var enrollmentViewModel = CourseEnrollmentViewModel()
    var tenantViewModel = TenantViewModel.shared
    private var viewModel: CourseOverviewViewModel?
    private var isEnrolled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
        courseEnrollment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel != nil {
            print("viewWillAppear: viewModel exists, updating UI")
            updateUIWithViewModel()
            updateApplyButtonState()
        } else {
            print("viewWillAppear: viewModel is nil")
        }
    }
    
    private func updateApplyButtonState() {
        if let requestStatus = viewModel?.getCourseRequestStatus(), requestStatus == "PENDING" {
            applyButton.setTitle("Cancel ".localized, for: .normal)
            applyButton.backgroundColor = .red
            isEnrolled = true
        } else {
            applyButton.setTitle("Enroll ".localized, for: .normal)
            applyButton.backgroundColor = tenantViewModel.primaryColor
            isEnrolled = false
        }
    }
    
    func sendData(_ data: Any) {
        if let viewModel = data as? CourseOverviewViewModel {
            self.viewModel = viewModel
            print("ViewModel received in sendData: \(viewModel)")
            print("Course from viewModel: \(String(describing: viewModel.getCourse()))")
            updateUIWithViewModel()
        } else {
            print("No valid viewModel received in sendData")
        }
    }
    
    private func updateUIWithViewModel() {
        
        guard let course = viewModel?.getCourse() else {
            print("No course data available in viewModel")
            return
        }
        
        print("Updating UI with course: \(course)")
        print("Title: \(course.title)")
        print("Description: \(course.description)")
        print("Duration: \(viewModel?.getFormattedDuration() ?? "nil")")
        print("Lessons: \(viewModel?.getLessonsCount() ?? "nil")")
        print("Has Quiz: \(viewModel?.hasQuiz() ?? false)")
        print("Certificate: \(String(describing: course.certificate))")
        print("Instructor Name: \(viewModel?.getInstructorName() ?? "nil")")
        print("Instructor Title: \(viewModel?.getInstructorTitle() ?? "nil")")
        print("Instructor Bio: \(viewModel?.getInstructorBio() ?? "nil")")
        print("Instructor Image URL: \(String(describing: viewModel?.getInstructorImageURL() ?? nil))")
        
        introductionLabel.text = course.title
        introductionDescriptionLabel.text = course.description
        durationLabel.text = viewModel?.getFormattedDuration()
        lessonsCountLabel.text = viewModel?.getLessonsCount()
        quizzesLabel.text = viewModel?.hasQuiz() ?? false ? "Quizzes Available".localized : "No Quizzes"
        certificateLabel.text = (course.certificate != nil) ? "Certificate of completion".localized : "No certificate"
        instructorNameLabel.text = viewModel?.getInstructorName()
        instructorTitleLabel.text = viewModel?.getInstructorTitle()
        instructorDescriptionLabel.text = viewModel?.getInstructorBio()
        instructorProfileImageView.sd_setImage(
            with: viewModel?.getInstructorImageURL(),
            placeholderImage: UIImage(named: "profile_placeholder")?.imageFlippedForRightToLeftLayoutDirection())
    }
    
    
    private func showPendingAlert() {
        let alert = UIAlertController(title: "Pending".localized, message: "Your enrollment request is under review.".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToCourseViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextViewController = storyboard.instantiateViewController(withIdentifier: "CourseViewController") as? CourseViewController {
            let navigationController = UINavigationController(rootViewController: nextViewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    private func courseEnrollment() {
        enrollmentViewModel.onEnrollmentSuccess = { [weak self] message, isEnroll in
            DispatchQueue.main.async {
                self?.showSuccessAlert(message: message)
                if isEnroll {
                    self?.applyButton.setTitle("Cancel ".localized, for: .normal)
                    self?.applyButton.backgroundColor = .red
                    self?.isEnrolled = true
                } else {
                    self?.applyButton.setTitle("Enroll ".localized, for: .normal)
                    self?.applyButton.backgroundColor = self?.tenantViewModel.primaryColor
                    self?.isEnrolled = false
                }
                
                
            }
        }
        
        enrollmentViewModel.onEnrollmentFailure = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: errorMessage)
                self?.updateApplyButtonState()
            }
        }
    }
    
    private func setupUI() {
        
        introductionLabel.translatesAutoresizingMaskIntoConstraints = false
        introductionLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        view.addSubview(introductionLabel)
        
        introductionDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        introductionDescriptionLabel.numberOfLines = 0
        introductionDescriptionLabel.textColor = UIColor(named: "onboradColor")
        introductionDescriptionLabel.font = UIFont(name: "Roboto-Regular", size: 14)
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
        containerView1.layer.shadowOffset = CGSize(width: 0, height: 10)
        containerView1.layer.shadowRadius = 8
        stackView.addArrangedSubview(containerView1)
        
        containerView2 = UIView()
        containerView2.translatesAutoresizingMaskIntoConstraints = false
        containerView2.backgroundColor = .clear
        containerView2.layer.borderWidth = 1.0
        containerView2.layer.borderColor = UIColor(named: "border")?.cgColor ?? UIColor.lightGray.cgColor
        containerView2.layer.cornerRadius = 8
        containerView2.layer.shadowColor = UIColor.black.cgColor
        containerView2.layer.shadowOffset = CGSize(width: 0, height: 10)
        containerView2.layer.shadowRadius = 8
        stackView.addArrangedSubview(containerView2)
        
        containerView3 = UIView()
        containerView3.translatesAutoresizingMaskIntoConstraints = false
        containerView3.backgroundColor = .clear
        containerView3.layer.borderWidth = 1.0
        containerView3.layer.borderColor = UIColor(named: "border")?.cgColor ?? UIColor.lightGray.cgColor
        containerView3.layer.cornerRadius = 8
        containerView3.layer.shadowColor = UIColor.black.cgColor
        containerView3.layer.shadowOffset = CGSize(width: 0, height: 10)
        containerView3.layer.shadowRadius = 8
        stackView.addArrangedSubview(containerView3)
        
        let button1 = UIButton()
        button1.translatesAutoresizingMaskIntoConstraints = false
        let imageView1 = UIImageView()
        imageView1.image = UIImage(named: "mingcute_time-line")?.imageFlippedForRightToLeftLayoutDirection()
        imageView1.tintColor = tenantViewModel.secondaryColor
        imageView1.contentMode = .scaleAspectFit
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        
        durationLabel.numberOfLines = 0
        durationLabel.textColor = tenantViewModel.primaryColor
        durationLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        lessonsCountLabel.numberOfLines = 0
        lessonsCountLabel.textColor = tenantViewModel.primaryColor
        lessonsCountLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        lessonsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        button1.addSubview(imageView1)
        button1.addSubview(durationLabel)
        button1.addSubview(lessonsCountLabel)
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
            
            durationLabel.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: 2),
            durationLabel.leadingAnchor.constraint(equalTo: button1.leadingAnchor, constant: 25),
            durationLabel.trailingAnchor.constraint(equalTo: button1.trailingAnchor),
            
            lessonsCountLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 2),
            lessonsCountLabel.leadingAnchor.constraint(equalTo: durationLabel.leadingAnchor),
            lessonsCountLabel.trailingAnchor.constraint(equalTo: durationLabel.trailingAnchor),
        ])
        
        let button2 = UIButton()
        button2.translatesAutoresizingMaskIntoConstraints = false
        let imageView2 = UIImageView()
        imageView2.image = UIImage(named: "note")?.imageFlippedForRightToLeftLayoutDirection()
        imageView2.tintColor = tenantViewModel.secondaryColor
        imageView2.contentMode = .scaleAspectFit
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        
        quizzesLabel.text = "Quizzes".localized
        quizzesLabel.textColor = tenantViewModel.primaryColor
        quizzesLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        quizzesLabel.translatesAutoresizingMaskIntoConstraints = false
        button2.addSubview(imageView2)
        button2.addSubview(quizzesLabel)
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
            
            quizzesLabel.topAnchor.constraint(equalTo: imageView2.bottomAnchor, constant: 8),
            quizzesLabel.leadingAnchor.constraint(equalTo: button2.leadingAnchor, constant: 40),
            quizzesLabel.trailingAnchor.constraint(equalTo: button2.trailingAnchor),
        ])
        
        let button3 = UIButton()
        button3.translatesAutoresizingMaskIntoConstraints = false
        let imageView3 = UIImageView()
        imageView3.image = UIImage(named: "Group")?.imageFlippedForRightToLeftLayoutDirection()
        imageView3.tintColor = tenantViewModel.secondaryColor
        imageView3.contentMode = .scaleAspectFit
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        
        certificateLabel.numberOfLines = 0
        certificateLabel.textColor = tenantViewModel.primaryColor
        certificateLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        certificateLabel.translatesAutoresizingMaskIntoConstraints = false
        button3.addSubview(imageView3)
        button3.addSubview(certificateLabel)
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
            
            certificateLabel.topAnchor.constraint(equalTo: imageView3.bottomAnchor, constant: 5),
            certificateLabel.leadingAnchor.constraint(equalTo: button3.leadingAnchor, constant: 20),
            certificateLabel.trailingAnchor.constraint(equalTo: button3.trailingAnchor),
        ])
        
        applyButton = UIButton(type: .system)
        applyButton.setTitle("Enroll ".localized, for: .normal)
        applyButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 15)
        applyButton.setTitleColor(UIColor.white, for: .normal)
        applyButton.backgroundColor = tenantViewModel.primaryColor
        applyButton.layer.cornerRadius = 20
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(applyButton)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        view.addSubview(applyButton)
        
        
        instractorView = UIView()
        instractorView.translatesAutoresizingMaskIntoConstraints = false
        instractorView.backgroundColor = UIColor(named: "myLearning")
        instractorView.layer.cornerRadius = 8
        instractorView.layer.shadowColor = UIColor.black.cgColor
        instractorView.layer.shadowOpacity = 0.3
        instractorView.layer.shadowOffset = CGSize(width: 0, height: 5)
        instractorView.layer.shadowRadius = 8
        view.addSubview(instractorView)
        
        instructorProfileImageView.contentMode = .scaleAspectFill
        instructorProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        instructorProfileImageView.layer.cornerRadius = 30
        instructorProfileImageView.layer.borderWidth = 2
        instructorProfileImageView.layer.borderColor = tenantViewModel.secondaryColor?.cgColor
        instructorProfileImageView.clipsToBounds = true
        instractorView.addSubview(instructorProfileImageView)
        
        NSLayoutConstraint.activate([
            instructorProfileImageView.leadingAnchor.constraint(equalTo: instractorView.leadingAnchor, constant: 16),
            instructorProfileImageView.topAnchor.constraint(equalTo: instractorView.topAnchor, constant: 10),
            instructorProfileImageView.widthAnchor.constraint(equalToConstant: 60),
            instructorProfileImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        instructorNameLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        instructorNameLabel.textColor = .black
        instructorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        instractorView.addSubview(instructorNameLabel)
        
        NSLayoutConstraint.activate([
            instructorNameLabel.leadingAnchor.constraint(equalTo: instructorProfileImageView.trailingAnchor, constant: 16),
            instructorNameLabel.topAnchor.constraint(equalTo: instractorView.topAnchor, constant: 15)
        ])
        
        
        instructorTitleLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        instructorTitleLabel.textColor = .black
        instructorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        instractorView.addSubview(instructorTitleLabel)
        
        NSLayoutConstraint.activate([
            instructorTitleLabel.leadingAnchor.constraint(equalTo: instructorNameLabel.leadingAnchor),
            instructorTitleLabel.topAnchor.constraint(equalTo: instructorNameLabel.bottomAnchor, constant: 4)
        ])
        
        
        instructorDescriptionLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        instructorDescriptionLabel.textColor = UIColor(named: "onboradColor")
        instructorDescriptionLabel.numberOfLines = 0
        instructorDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        instractorView.addSubview(instructorDescriptionLabel)
        
        NSLayoutConstraint.activate([
            instructorDescriptionLabel.leadingAnchor.constraint(equalTo: instructorProfileImageView.leadingAnchor),
            instructorDescriptionLabel.trailingAnchor.constraint(equalTo: instractorView.trailingAnchor, constant: -4),
            instructorDescriptionLabel.topAnchor.constraint(equalTo: instructorProfileImageView.bottomAnchor, constant: 16)
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
            introductionDescriptionLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: introductionDescriptionLabel.bottomAnchor, constant: 10),
            stackView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            
            applyButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            applyButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            applyButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            applyButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
        
        NSLayoutConstraint.activate([
            instractorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instractorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            instractorView.topAnchor.constraint(equalTo: applyButton.bottomAnchor, constant: 20),
            instractorView.heightAnchor.constraint(equalToConstant: 200),
            instractorView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
        
    }
    
    
    @objc func applyButtonTapped() {
        
        guard let token = UserSessionManager.shared.token else {
            print("Token is nil, cannot enroll in course")
            return
        }
        
        guard let courseSlug = viewModel?.getCourse()?.slug else {
            print("Course slug is nil")
            return
        }
        
        if isEnrolled {
            print("Attempting to cancel enrollment for course: \(courseSlug)")
            enrollmentViewModel.cancelEnrollInCourse(courseSlug: courseSlug, token: token)
        } else {
            print("Attempting to enroll in course: \(courseSlug)")
            enrollmentViewModel.enrollInCourse(courseSlug: courseSlug, token: token)
        }
    }
}
