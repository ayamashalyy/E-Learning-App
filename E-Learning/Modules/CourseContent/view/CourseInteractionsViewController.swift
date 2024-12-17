//
//  CourseInteractionsViewController.swift
//  E-Learning
//
//  Created by aya on 04/12/2024.
//

import UIKit

class CourseInteractionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var delegate: callDataBack?
    var headerView = UIView()
    var comments: [(text: String, date: Date)] = []
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeaderView()
        setupTableView()
        
    }
    
    private func setupHeaderView() {
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        headerView.backgroundColor = .white
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let shareImageView = UIImageView(image: UIImage(named: "share_icon"))
        shareImageView.contentMode = .scaleAspectFit
        shareImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let shareButton = UIButton(type: .system)
        shareButton.setTitle("Share this course", for: .normal)
        shareButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 14)
        shareButton.setTitleColor(UIColor(named: "myCustom"), for: .normal)
        
        let shareStackView = UIStackView(arrangedSubviews: [shareImageView, shareButton])
        shareStackView.axis = .horizontal
        shareStackView.spacing = 8
        stackView.addArrangedSubview(shareStackView)
        
        
        let discussionImageView = UIImageView(image: UIImage(named: "forum_icon"))
        discussionImageView.contentMode = .scaleAspectFit
        discussionImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let discussionButton = UIButton(type: .system)
        discussionButton.setTitle("Discussion Forum", for: .normal)
        discussionButton.setTitleColor(UIColor(named: "myCustom"), for: .normal)
        discussionButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 14)
        
        let discussionStackView = UIStackView(arrangedSubviews: [discussionImageView, discussionButton])
        discussionStackView.axis = .horizontal
        discussionStackView.spacing = 8
        stackView.addArrangedSubview(discussionStackView)
        
        
        headerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
        ])
        
        let stackViewComments = UIStackView()
        stackViewComments.axis = .horizontal
        stackViewComments.distribution = .equalSpacing
        stackViewComments.alignment = .center
        stackViewComments.spacing = 16
        stackViewComments.translatesAutoresizingMaskIntoConstraints = false
        
        let commentsLabel = UILabel()
        commentsLabel.text = "Comments"
        commentsLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackViewComments.addArrangedSubview(commentsLabel)
        
        let addCommentButton = UIButton(type: .system)
        addCommentButton.setTitle(" Add Comment", for: .normal)
        addCommentButton.setImage(UIImage(named: "pencil_icon"), for: .normal)
        addCommentButton.tintColor = UIColor(named: "myCustom")
        addCommentButton.backgroundColor = UIColor(named: "addCommet")
        addCommentButton.setTitleColor(UIColor(named: "myCustom"), for: .normal)
        addCommentButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 12)
        addCommentButton.layer.cornerRadius = 10
        addCommentButton.layer.borderWidth = 1.0
        addCommentButton.layer.borderColor = UIColor(named: "myCustom")?.cgColor
        addCommentButton.translatesAutoresizingMaskIntoConstraints = false
        addCommentButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        
        addCommentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        addCommentButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        
        stackViewComments.addArrangedSubview(addCommentButton)
        
        headerView.addSubview(stackViewComments)
        
        NSLayoutConstraint.activate([
            
            stackViewComments.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 90),
            stackViewComments.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            stackViewComments.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            commentsLabel.centerYAnchor.constraint(equalTo: stackViewComments.centerYAnchor),
            addCommentButton.centerYAnchor.constraint(equalTo: stackViewComments.centerYAnchor),
            addCommentButton.heightAnchor.constraint(equalToConstant: 40),
            addCommentButton.widthAnchor.constraint(equalToConstant: 130)
            
        ])
        
        view.addSubview(headerView)
    }
    
    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func addComment() {
        
        let alert = UIAlertController(title: "Add Comment", message: "Enter your comment below:", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Your comment here"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let commentText = alert.textFields?.first?.text, !commentText.isEmpty {
                let currentDate = Date()
                self?.comments.append((text: commentText, date: currentDate))
                self?.tableView.reloadData()
            } else {
                
                let errorAlert = UIAlertController(title: "Error", message: "The text field is empty. Please enter a comment.", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(errorAlert, animated: true, completion: nil)
            }
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell else {
            return UITableViewCell()
        }
        
        let comment = comments[indexPath.row]
        
        cell.profileImageView.image = UIImage(named: "profile_placeholder")
        cell.nameLabel.text = "User \(indexPath.row + 1)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        cell.dateLabel.text = dateFormatter.string(from: comment.date)
        cell.commentLabel.text = comment.text
        cell.selectionStyle = .none
        
        return cell
    }
    
}
