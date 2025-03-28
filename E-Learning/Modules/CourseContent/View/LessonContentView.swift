//
//  LessonContentView.swift
//  E-Learning
//
//  Created by Aya Mashaly on 24/03/2025.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import WebKit
import SDWebImage

class LessonContentView: UIView{
    private var textView: UITextView?
    private var playerController: AVPlayerViewController?
    private var documentView: WKWebView?
    private var scormView: WKWebView?
    private var aiccView: WKWebView?
    private var courseImageView: UIImageView?
    var tenantViewModel = TenantViewModel.shared
    private var activityIndicator: UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: CourseOverviewViewModel) {
        subviews.forEach { $0.removeFromSuperview() }
        
        print("--- Configuring LessonContentView ---")
        guard let lesson = viewModel.getSelectedLesson() else {
            print("No lesson selected - showing course image")
            setupCourseImageView(viewModel: viewModel)
            return
        }
        print("Rendering lesson: \(lesson.title) | Type: \(lesson.type) | Content: \(lesson.content ?? "nil")")
        let lessonType = LessonType(rawValue: lesson.type)
        switch lessonType {
        case .video:
            print("Setting up video player with AVPlayerViewController")
            setupMediaPlayer(content: lesson.content, isVideo: true)
        case .text:
            print("Setting up text view")
            setupTextView(content: lesson.content)
        case .audio:
            print("Setting up audio player with AVPlayerViewController")
            setupMediaPlayer(content: lesson.content, isVideo: false)
        case .document:
            setupDocumentView(content: lesson.content)
        case .scorm:
            setupScormView(content: lesson.content)
        case .aicc:
            setupAiccView(content: lesson.content)
        case .quiz:
            setupCourseImageView(viewModel: viewModel)
        case .unknown:
            setupCourseImageView(viewModel: viewModel)
        }
        self.setNeedsLayout()
    }
    
    
    private func setupMediaPlayer(content: String?, isVideo: Bool) {
        guard let urlString = content, let url = URL(string: urlString) else {
            print("Invalid media URL")
            return
        }
        
        let player = AVPlayer(url: url)
        playerController = AVPlayerViewController()
        playerController?.player = player
        
        playerController?.view.translatesAutoresizingMaskIntoConstraints = false
        playerController?.showsPlaybackControls = true
        playerController?.videoGravity = isVideo ? .resizeAspectFill : .resize
        
        if let playerView = playerController?.view {
            self.addSubview(playerView)
            NSLayoutConstraint.activate([
                playerView.topAnchor.constraint(equalTo: self.topAnchor),
                playerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                playerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                playerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        
        player.play()
        print("\(isVideo ? "Video" : "Audio") is playing with AVPlayerViewController from URL: \(urlString)")
    }
    
    private func setupTextView(content: String?) {
        textView = UITextView()
        textView?.isEditable = false
        textView?.text = content ?? "No text content available"
        textView?.font = UIFont(name: "Roboto-Regular", size: 16)
        textView?.backgroundColor = .white
        textView?.translatesAutoresizingMaskIntoConstraints = false
        
        if let textView = textView {
            self.addSubview(textView)
            NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: self.topAnchor),
                textView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                textView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            print("textView added with constraints, text: \(textView.text ?? "nil")")
        }
        
        self.layoutIfNeeded()
    }
    
    private func setupDocumentView(content: String?) {
        documentView = WKWebView(frame: self.bounds)
        documentView?.navigationDelegate = self
        
        if let urlString = content, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            documentView?.load(request)
        } else {
            documentView?.loadHTMLString("<h1>No document available</h1>", baseURL: nil)
        }
        if let documentView = documentView {
            self.addSubview(documentView)
            loadIndicator(in: documentView)
        }
    }
    
    private func setupScormView(content: String?) {
        scormView = WKWebView(frame: self.bounds, configuration: WKWebViewConfiguration())
        scormView?.configuration.preferences.javaScriptEnabled = true
        scormView?.navigationDelegate = self
        
        if let urlString = content, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            scormView?.load(request)
        } else {
            scormView?.loadHTMLString("<h1>No SCORM content available</h1>", baseURL: nil)
        }
        if let scormView = scormView {
            self.addSubview(scormView)
            loadIndicator(in: scormView)
        }
    }
    
    private func setupAiccView(content: String?) {
        aiccView = WKWebView(frame: self.bounds)
        aiccView?.navigationDelegate = self
        
        if let urlString = content, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            aiccView?.load(request)
        } else {
            aiccView?.loadHTMLString("<h1>No AICC content available</h1>", baseURL: nil)
        }
        if let aiccView = aiccView {
            self.addSubview(aiccView)
            loadIndicator(in: aiccView)
        }
    }
    
    private func loadIndicator(in view: UIView) {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator!)
        
        NSLayoutConstraint.activate([
            activityIndicator!.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator!.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator?.startAnimating()
    }
    
    private func setupCourseImageView(viewModel: CourseOverviewViewModel) {
        courseImageView = UIImageView(frame: self.bounds)
        courseImageView?.contentMode = .scaleAspectFill
        courseImageView?.clipsToBounds = true
        
        if let imageUrlString = viewModel.getCourse()?.image, let imageUrl = URL(string: imageUrlString) {
            courseImageView?.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "course_placeholder"))
        } else {
            courseImageView?.image = UIImage(named: "course_placeholder")
        }
        
        if let courseImageView = courseImageView {
            self.addSubview(courseImageView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("LessonContentView bounds: \(self.bounds)")
        playerController?.view.frame = self.bounds
        textView?.frame = self.bounds
        documentView?.frame = self.bounds
        scormView?.frame = self.bounds
        aiccView?.frame = self.bounds
        courseImageView?.frame = self.bounds
    }
}

extension LessonContentView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
    }
}
