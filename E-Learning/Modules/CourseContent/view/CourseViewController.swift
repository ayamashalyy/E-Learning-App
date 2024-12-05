//
//  CourseViewController.swift
//  E-Learning
//
//  Created by aya on 04/12/2024.
//

import UIKit
import AVFoundation

protocol sendData {
    func sendData(_ data: Any)
}

class CourseViewController: UIViewController {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var videoContainerView: UIView!
    var stackView: UIStackView!
    var selectedButton: UIButton?
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Introduction to Scrum Master"
        let backButtonImage = UIImage(named: "Icon 1")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(cancelTapped))
        self.navigationItem.leftBarButtonItem = backButton
        setupUI()
        setupConstraints()
        setupVideoPlayer()
        loadSubView(1)
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupVideoPlayer() {
        
        guard let url = URL(string: "https://www.youtube.com/watch?v=TTgzLTyXt7s") else {
            print("Invalid video URL")
            return
        }
        
        player = AVPlayer(url: url)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoContainerView.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        videoContainerView.layer.addSublayer(playerLayer!)
        player?.play()
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
        
        videoContainerView = UIView()
        videoContainerView.backgroundColor = .red
        videoContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoContainerView)
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        let containerView1 = UIView()
        let button1 = UIButton(type: .custom)
        button1.setTitle("Course Info", for: .normal)
        button1.setTitleColor(UIColor.gray, for: .normal)
        button1.setTitleColor(UIColor(named: "myCustom"), for: .selected)
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
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
        
        let containerView2 = UIView()
        let button2 = UIButton(type: .custom)
        button2.setTitle("Content", for: .normal)
        button2.setTitleColor(UIColor.gray, for: .normal)
        button2.setTitleColor(UIColor(named: "myCustom"), for: .selected)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
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
        
        let containerView3 = UIView()
        let button3 = UIButton(type: .custom)
        button3.setTitle("Interactions", for: .normal)
        button3.setTitleColor(UIColor.gray, for: .normal)
        button3.setTitleColor(UIColor(named: "myCustom"), for: .selected)
        button3.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
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
        
        if let firstButton = containerView1.subviews.first(where: { $0 is UIButton }) as? UIButton {
            buttonTapped(firstButton)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if let selectedButton = selectedButton {
            selectedButton.setTitleColor(UIColor.gray, for: .normal)
            selectedButton.isSelected = false
            
            if let containerView = selectedButton.superview {
                if let underline = containerView.subviews.first(where: { $0 is UIView && $0 != selectedButton }) {
                    underline.backgroundColor = UIColor.gray
                }
            }
        }
        
        sender.isSelected = true
        sender.setTitleColor(UIColor(named: "myCustom"), for: .normal)
        
        if let containerView = sender.superview {
            if let underline = containerView.subviews.first(where: { $0 is UIView && $0 != sender }) {
                underline.backgroundColor = UIColor(named: "myCustom")
            }
        }
        
        selectedButton = sender
        loadSubView(sender.tag)
    }
    
    private func loadSubView(_ tag: Int) {
        self.removeAllSubView(mainContainerView: contentView)
        switch tag {
        case 1:
            self.moveToSubView(mainContainerView: contentView, identifier: "CourseInfoViewController", storyboardName: "Main", CourseInfoViewController.self, data: "section1 send!")
        case 2:
            self.moveToSubView(mainContainerView: contentView, identifier: "CourseContentViewController", storyboardName: "Main", CourseContentViewController.self)
        case 3:
            self.moveToSubView(mainContainerView: contentView, identifier: "CourseInteractionsViewController", storyboardName: "Main", CourseInteractionsViewController.self)
            
            // Emit test data from Section2ViewController after it's added to the parent
            if let childVC = children.first(where: { $0 is CourseInteractionsViewController }) as? CourseInteractionsViewController {
                childVC.delegate = self
            }
        default:
            print("No View found!")
        }
    }
    
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            videoContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            videoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoContainerView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: videoContainerView.bottomAnchor, constant: 10),
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
        playerLayer?.frame = videoContainerView.bounds
    }
}

extension CourseViewController: callDataBack {
    func sendDataBack(_ data: Any) {
        print(data as? String ?? "")
    }
}
