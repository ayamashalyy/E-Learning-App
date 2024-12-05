//
//  CourseContentViewController.swift
//  E-Learning
//
//  Created by aya on 04/12/2024.
//

import UIKit

struct Lesson {
    let number: Int
    let title: String
    let duration: String
    let type: String
    let isCompleted: Bool
}

class CourseContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    let lessons: [Lesson] = [
        Lesson(number: 1, title: "Lesson 1", duration: "10 min", type: "Video", isCompleted: true),
        Lesson(number: 2, title: "Lesson 2", duration: "10 min", type: "Video", isCompleted: true),
        Lesson(number: 3, title: "Lesson 3", duration: "10 min", type: "Reading", isCompleted: false),
        Lesson(number: 0, title: "Quiz 1", duration: "10 min", type: "14 Questions", isCompleted: false),
        Lesson(number: 4, title: "Lesson 4", duration: "10 min", type: "Video", isCompleted: false),
        Lesson(number: 5, title: "Introduction to Scrum Master", duration: "10 min", type: "Video", isCompleted: false)
    ]
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CourseContentTableViewCell.self, forCellReuseIdentifier: "CourseContentTableViewCell")
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CourseContentTableViewCell", for: indexPath) as? CourseContentTableViewCell else {
            return UITableViewCell()
        }
        
        let lesson = lessons[indexPath.row]
        cell.configure(with: lesson)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
