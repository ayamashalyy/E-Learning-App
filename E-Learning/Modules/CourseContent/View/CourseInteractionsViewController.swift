//
//  CourseInteractionsViewController.swift
//  E-Learning
//
//  Created by aya on 04/12/2024.
//

import UIKit

class CourseInteractionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, sendData{
    
    var headerView = UIView()
    var tableView = UITableView()
    var tenantViewModel = TenantViewModel.shared
    private var viewModel: CourseOverviewViewModel?
    private var commentViewModel = CommentViewModel()
    private var courseSlug: String?
    private var userSessionManager = UserSessionManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeaderView()
        setupTableView()
        fetchCourseData()
    }
    
    func sendData(_ data: Any) {
        if let viewModel = data as? CourseOverviewViewModel {
            print("Received viewModel in sendData: \(viewModel)")
            self.viewModel = viewModel
            self.courseSlug = viewModel.getCourse()?.slug
            fetchCourseData()
        } else {
            print("Failed to cast data to CourseOverviewViewModel")
        }
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
        
        let shareImageView = UIImageView(image: UIImage(named: "share_icon")?.imageFlippedForRightToLeftLayoutDirection())
        shareImageView.tintColor = tenantViewModel.secondaryColor
        shareImageView.contentMode = .scaleAspectFit
        shareImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let shareButton = UIButton(type: .system)
        shareButton.setTitle("Share this course".localized, for: .normal)
        shareButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 14)
        shareButton.setTitleColor(tenantViewModel.primaryColor, for: .normal)
        
        let shareStackView = UIStackView(arrangedSubviews: [shareImageView, shareButton])
        shareStackView.axis = .horizontal
        shareStackView.spacing = 8
        stackView.addArrangedSubview(shareStackView)
        
        let discussionImageView = UIImageView(image: UIImage(named: "forum_icon")?.imageFlippedForRightToLeftLayoutDirection())
        discussionImageView.tintColor = tenantViewModel.secondaryColor
        discussionImageView.contentMode = .scaleAspectFit
        discussionImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let discussionButton = UIButton(type: .system)
        discussionButton.setTitle("Discussion Forum".localized, for: .normal)
        discussionButton.setTitleColor(tenantViewModel.primaryColor, for: .normal)
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
        commentsLabel.text = "Comments".localized
        commentsLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackViewComments.addArrangedSubview(commentsLabel)
        
        let pencilImageView = UIImageView(image: UIImage(named: "pencil_icon"))
        pencilImageView.tintColor = tenantViewModel.primaryColor
        pencilImageView.contentMode = .scaleAspectFit
        pencilImageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let padding = UIView()
        padding.translatesAutoresizingMaskIntoConstraints = false
        padding.frame = CGRect(x: 0, y: 0, width: 8, height: 8)
        
        let addCommentButton = UIButton(type: .system)
        addCommentButton.setTitle("Add Comment".localized, for: .normal)
        addCommentButton.setTitleColor(tenantViewModel.primaryColor, for: .normal)
        addCommentButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 12)
        addCommentButton.translatesAutoresizingMaskIntoConstraints = false
        addCommentButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        
        let addCommentStackView = UIStackView(arrangedSubviews: [padding ,pencilImageView, addCommentButton])
        addCommentStackView.axis = .horizontal
        addCommentStackView.backgroundColor = UIColor(named: "addCommet")
        addCommentStackView.layer.cornerRadius = 10
        addCommentStackView.layer.borderWidth = 1.0
        addCommentStackView.alignment = .center
        addCommentStackView.layer.borderColor = tenantViewModel.primaryColor?.cgColor
        addCommentStackView.spacing = 2
        addCommentStackView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        stackViewComments.addArrangedSubview(addCommentStackView)
        
        headerView.addSubview(stackViewComments)
        
        NSLayoutConstraint.activate([
            stackViewComments.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 90),
            stackViewComments.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            stackViewComments.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            
            commentsLabel.centerYAnchor.constraint(equalTo: stackViewComments.centerYAnchor),
            addCommentButton.centerYAnchor.constraint(equalTo: stackViewComments.centerYAnchor),
            addCommentButton.heightAnchor.constraint(equalToConstant: 40),
            addCommentButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        view.addSubview(headerView)
    }
    
    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
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
        
        let alert = UIAlertController(title: "Add Comment".localized, message: "Enter your comment below:".localized, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Your comment here".localized
            textField.autocapitalizationType = .sentences
            textField.returnKeyType = .done
            textField.becomeFirstResponder()
        }
        
        let addAction = UIAlertAction(title: "Add".localized, style: .default) { [weak self] _ in
            guard let self = self,
                  let commentText = alert.textFields?.first?.text,
                  !commentText.isEmpty,
                  let courseSlug = viewModel?.getCourse()?.slug,
                  let token = self.userSessionManager.token else {
                let errorAlert = UIAlertController(title: "Error".localized, message: "Missing required data.".localized, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK".localized, style: .default))
                self?.present(errorAlert, animated: true, completion: nil)
                return
            }
            
            self.commentViewModel.addComment(courseSlug: courseSlug, commentText: commentText, token: token)
            
            self.commentViewModel.onCommentSuccess = { message in
                print("Comment added successfully: \(message)")
                // After successful POST, fetch updated course data
                self.fetchCourseData()
                
            }
            
            self.commentViewModel.onCommentFailure = { errorMessage in
                let errorAlert = UIAlertController(title: "Error".localized, message: errorMessage, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK".localized, style: .default))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func fetchCourseData() {
        guard let courseSlug = viewModel?.getCourse()?.slug ?? self.courseSlug,
              let token = userSessionManager.token else {
            print("Cannot fetch course data: missing courseSlug or token")
            return
        }
        
        viewModel?.fetchCourseData(courseSlug: courseSlug, token: token)
        viewModel?.onDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getComments().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell,
              let comment = viewModel?.getComments()[indexPath.row] else {
            return UITableViewCell()
        }
        
        if let avatarURL = URL(string: comment.user.avatar ?? "") {
            cell.profileImageView.sd_setImage(with: avatarURL, placeholderImage: UIImage(named: "profile_placeholder")?.imageFlippedForRightToLeftLayoutDirection())
        } else {
            cell.profileImageView.image = UIImage(named: "profile_placeholder")?.imageFlippedForRightToLeftLayoutDirection()
        }
        
        cell.nameLabel.text = comment.user.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy".localized
        let date = ISO8601DateFormatter().date(from: comment.createdAt) ?? Date()
        cell.dateLabel.text = dateFormatter.string(from: date)
        cell.commentLabel.text = comment.comment
        cell.selectionStyle = .none
        
        return cell
    }
}
