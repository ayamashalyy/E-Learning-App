//
//  MyLearningViewController.swift
//  E-Learning
//
//  Created by aya on 19/11/2024.
//

import UIKit

class MyLearningViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tabelView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.register(UINib(nibName: "MyLearningTableViewCell", bundle: nil), forCellReuseIdentifier: "MyLearningTableViewCell")
        
        
        guard let segmentedControl = mySegmentedControl else { return }
        
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.tintColor = UIColor.clear
        
        
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 15, weight: .bold)
        ], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)], for: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyLearningTableViewCell", for: indexPath) as? MyLearningTableViewCell else {
            fatalError("Unable to dequeue MyLearningTableViewCell")
        }
        
//        cell.myLearningCategory.text = "Category \(indexPath.row + 1)"
//        cell.myLearningNameCourse.text = "Course Name \(indexPath.row + 1)"
//        cell.myLearningConstractorName.text = "Instructor Name \(indexPath.row + 1)"
//        cell.myLearningProgressLabel.text = "\(indexPath.row * 10)%"
//        cell.myLearningProgress.progress = Float(indexPath.row) / 10.0
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    
    
    
}
