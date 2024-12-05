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
    var comments: [String] = []
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeaderView()
        setupTableView()
        
    }
    
    private func setupHeaderView() {
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
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
        shareButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
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
        discussionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        
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
        commentsLabel.font = .systemFont(ofSize: 20, weight: .bold)
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackViewComments.addArrangedSubview(commentsLabel)
        
        let addCommentButton = UIButton(type: .system)
        addCommentButton.setTitle(" Add Comment", for: .normal)
        addCommentButton.setImage(UIImage(named: "pencil_icon"), for: .normal)
        addCommentButton.tintColor = UIColor(named: "myCustom")
        addCommentButton.backgroundColor = UIColor(named: "addCommet")
        addCommentButton.setTitleColor(UIColor(named: "myCustom"), for: .normal)
        addCommentButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        addCommentButton.layer.cornerRadius = 10
        addCommentButton.layer.borderWidth = 1.0
        addCommentButton.layer.borderColor = UIColor(named: "myCustom")?.cgColor
        addCommentButton.translatesAutoresizingMaskIntoConstraints = false
        addCommentButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        addCommentButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        addCommentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        addCommentButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        stackViewComments.addArrangedSubview(addCommentButton)
        
        headerView.addSubview(stackViewComments)
        
        NSLayoutConstraint.activate([
            
            stackViewComments.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 90),
            stackViewComments.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            stackViewComments.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            commentsLabel.centerYAnchor.constraint(equalTo: stackViewComments.centerYAnchor),
            addCommentButton.centerYAnchor.constraint(equalTo: stackViewComments.centerYAnchor),
            addCommentButton.heightAnchor.constraint(equalToConstant: 50),
            addCommentButton.widthAnchor.constraint(equalToConstant: 150)
            
        ])
        
        view.addSubview(headerView)
    }
    
    private func setupTableView() {
        tableView.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.height - 200)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.separatorStyle = .singleLine
        view.addSubview(tableView)
    }
    
    @objc func addComment() {
        
        let alert = UIAlertController(title: "Add Comment", message: "Enter your comment below:", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Your comment here"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let comment = alert.textFields?.first?.text, !comment.isEmpty {
                self?.comments.append(comment)
                self?.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        cell.textLabel?.text = comments[indexPath.row]
        return cell
    }
    
}
