//
//  LessonContentView.swift
//  E-Learning
//
//  Created by Aya Mashaly on 24/03/2025.
//

import Foundation
import UIKit
import AVFoundation
import WebKit
import SDWebImage

class LessonContentView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var textView: UITextView?
    private var audioPlayer: AVAudioPlayer?
    private var documentView: WKWebView?
    private var scormView: WKWebView?
    private var aiccView: WKWebView?
    private var courseImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: CourseOverviewViewModel) {
        subviews.forEach { $0.removeFromSuperview() }
        playerLayer?.removeFromSuperlayer()
        
        guard let lesson = viewModel.getSelectedLesson() else {
            print("No selected lesson found in ViewModel")
            setupCourseImageView(viewModel: viewModel)
            return
        }
        let lessonType = LessonType(rawValue: lesson.type)
        switch lessonType {
        case .video:
            setupVideoPlayer(content: lesson.content)
        case .text:
            setupTextView(content: lesson.content)
        case .audio:
            setupAudioPlayer(content: lesson.content)
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
    }
    
    private func setupVideoPlayer(content: String?) {
        guard let urlString = content, let url = URL(string: urlString) else {
            print("Invalid video URL")
            return
        }
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        self.layer.addSublayer(playerLayer!)
        player?.play()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnVideo))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapOnVideo() {
        if player?.rate == 0 {
            player?.play()
        } else {
            player?.pause()
        }
    }
    
    private func setupTextView(content: String?) {
        textView = UITextView(frame: self.bounds)
        textView?.isEditable = false
        textView?.text = content ?? "No text content available"
        textView?.font = UIFont(name: "Roboto-Regular", size: 16)
        if let textView = textView {
            self.addSubview(textView)
        }
    }
    
    private func setupAudioPlayer(content: String?) {
        guard let urlString = content, let url = URL(string: urlString) else {
            print("Invalid audio URL")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error)")
        }
    }
    
    private func setupDocumentView(content: String?) {
        documentView = WKWebView(frame: self.bounds)
        if let urlString = content, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            documentView?.load(request)
        } else {
            documentView?.loadHTMLString("<h1>No document available</h1>", baseURL: nil)
        }
        if let documentView = documentView {
            self.addSubview(documentView)
        }
    }
    
    private func setupScormView(content: String?) {
        scormView = WKWebView(frame: self.bounds)
        if let urlString = content, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            scormView?.load(request)
        } else {
            scormView?.loadHTMLString("<h1>No SCORM content available</h1>", baseURL: nil)
        }
        if let scormView = scormView {
            self.addSubview(scormView)
        }
    }
    
    private func setupAiccView(content: String?) {
        aiccView = WKWebView(frame: self.bounds)
        if let urlString = content, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            aiccView?.load(request)
        } else {
            aiccView?.loadHTMLString("<h1>No AICC content available</h1>", baseURL: nil)
        }
        if let aiccView = aiccView {
            self.addSubview(aiccView)
        }
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
        playerLayer?.frame = self.bounds
        textView?.frame = self.bounds
        documentView?.frame = self.bounds
        scormView?.frame = self.bounds
        aiccView?.frame = self.bounds
        courseImageView?.frame = self.bounds
    }
}
