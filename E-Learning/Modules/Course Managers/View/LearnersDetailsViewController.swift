//
//  LearnersDetailsViewController.swift
//  E-Learning
//
//  Created by aya on 03/01/2025.
//

import UIKit

class LearnersDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var learnerImage: UIImageView!
    @IBOutlet weak var learnerName: UILabel!
    @IBAction func assignCourse(_ sender: UIButton) {
    }
    
    @IBOutlet weak var assignCourse: UIButton!
    
    @IBOutlet weak var request: UIButton!
    @IBAction func request(_ sender: UIButton) {
    }
    var requestCount: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(cancelTapped))
        self.navigationItem.leftBarButtonItem = backButton
        learnerImage.layer.cornerRadius = learnerImage.frame.height / 2
        learnerImage.layer.borderWidth = 0.8
        learnerImage.layer.borderColor = UIColor(named: "second")?.cgColor
        learnerImage.clipsToBounds = true
        setupButtons()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cellClass: DetailsDataOfLearnersCell.self)
    }
    
    func setupButtons(){
        assignCourse.setTitle("Assign Course".localized, for: .normal)
        assignCourse.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        assignCourse.setTitleColor(UIColor.white, for: .normal)
        assignCourse.backgroundColor = UIColor(named: "myCustom")
        assignCourse.layer.cornerRadius = 20
        
        request.setTitle(String(format: NSLocalizedString("request_count", comment: ""), requestCount), for: .normal)
        request.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        request.setTitleColor(UIColor.white, for: .normal)
        request.backgroundColor = UIColor(named: "myCustom")
        request.layer.cornerRadius = 20
        
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension LearnersDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as DetailsDataOfLearnersCell
        cell.configure(category: "Design",
                       courseName: "Google UX Design",
                       instructorName: "Jacob Jones",
                       progress: 0.4,
                       image: UIImage(named: "myLearning") ?? UIImage())
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
