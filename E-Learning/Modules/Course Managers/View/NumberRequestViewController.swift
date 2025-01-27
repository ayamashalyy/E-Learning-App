//
//  NumberRequestViewController.swift
//  E-Learning
//
//  Created by aya on 04/01/2025.
//

import UIKit

class NumberRequestViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var learnerImage: UIImageView!
    @IBOutlet weak var learnerName: UILabel!
    var tenantViewModel = TenantViewModel.shared
    var backButtonImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        
        if let backButtonImage = backButtonImage {
            let tintedImage = backButtonImage.withTintColor(tenantViewModel.primaryColor ?? .blue, renderingMode: .alwaysOriginal)
            let backButton = UIBarButtonItem(image: tintedImage, style: .plain, target: self, action: #selector(cancelTapped))
            self.navigationItem.leftBarButtonItem = backButton
        }
        
        learnerImage.layer.cornerRadius = learnerImage.frame.height / 2
        learnerImage.layer.borderWidth = 0.8
        learnerImage.layer.borderColor = tenantViewModel.secondaryColor?.cgColor
        learnerImage.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cellClass: NumberRequestCell.self)
        
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension NumberRequestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as NumberRequestCell
        cell.configure(category: "Design",
                       courseName: "Google UX Design",
                       instructorName: "Jacob Jones",
                       image: UIImage(named: "myLearning") ?? UIImage())
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}


extension NumberRequestViewController: NumberRequestCellDelegate {
    func didTapApproveButton(on cell: NumberRequestCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        print("Approve button tapped at row \(indexPath.row)")
    }
    
    func didTapRejectButton(on cell: NumberRequestCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        print("Reject button tapped at row \(indexPath.row)")
    }
}
