//
//  CourseContentViewController.swift
//  E-Learning
//
//  Created by aya on 04/12/2024.
//

import UIKit

class CourseContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, sendData   {
    
    private var viewModel: CourseOverviewViewModel?
    
    var tableView = UITableView()
    private let noDataImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "No Search Result")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupNoDataImageView()
        updateUI()
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else {
            print("ViewModel is nil in updateUI")
            tableView.isHidden = true
            noDataImageView.isHidden = false
            return
        }
        let sectionsCount = viewModel.getSectionsCount()
        let hasLessons = sectionsCount > 0 && viewModel.getSections().contains { $0.lessons?.isEmpty == false }
        
        print("updateUI: sectionsCount = \(sectionsCount), hasLessons = \(hasLessons)")
        print("Sections: \(viewModel.getSections())")
        
        tableView.isHidden = !hasLessons
        noDataImageView.isHidden = hasLessons
        tableView.reloadData()
    }
    
    func sendData(_ data: Any) {
        if let viewModel = data as? CourseOverviewViewModel {
            print("Received viewModel in sendData: \(viewModel)")
            self.viewModel = viewModel
            updateUI()
        } else {
            print("Failed to cast data to CourseOverviewViewModel")
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CourseContentTableViewCell.self, forCellReuseIdentifier: "CourseContentTableViewCell")
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNoDataImageView() {
        view.addSubview(noDataImageView)
        NSLayoutConstraint.activate([
            noDataImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataImageView.topAnchor.constraint(equalTo: view.topAnchor),
            noDataImageView.widthAnchor.constraint(equalToConstant: 400),
            noDataImageView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        let validSections = viewModel.getSections().filter { !($0.lessons?.isEmpty ?? true) }
        return validSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        let validSections = viewModel.getSections().filter { !($0.lessons?.isEmpty ?? true) }
        return validSections[section].lessons?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CourseContentTableViewCell", for: indexPath) as? CourseContentTableViewCell,
              let viewModel = viewModel else {
            return UITableViewCell()
        }
        let allSections = viewModel.getSections()
        let validSections = allSections.filter { !($0.lessons?.isEmpty ?? true) }
        
        let originalSectionIndex = allSections.firstIndex { $0.title == validSections[indexPath.section].title } ?? 0
        
        let lessonIndexPath = IndexPath(row: indexPath.row, section: originalSectionIndex)
        cell.configure(with: viewModel, indexPath: lessonIndexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let viewModel = viewModel else { return nil }
        let validSections = viewModel.getSections().filter { !($0.lessons?.isEmpty ?? true) }
        return validSections[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = PageViewController()
        let navigationController = UINavigationController(rootViewController: nextViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
