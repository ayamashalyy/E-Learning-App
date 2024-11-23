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
        
        setupTableView()
        setupSegmentedControl()
        
    }
    
    private func setupTableView() {
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.register(UINib(nibName: "MyLearningTableViewCell", bundle: nil), forCellReuseIdentifier: "MyLearningTableViewCell")
    }
    
    private func setupSegmentedControl() {
        
        guard let segmentedControl = mySegmentedControl else { return }
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.tintColor = UIColor.white
        
        
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .normal)
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 15, weight: .bold)
        ], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .bold)], for: .normal)
        
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        
        tabelView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch mySegmentedControl.selectedSegmentIndex {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return 7
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyLearningTableViewCell", for: indexPath) as? MyLearningTableViewCell else {
            fatalError("Unable to dequeue MyLearningTableViewCell")
        }
        
        switch mySegmentedControl.selectedSegmentIndex {
        case 0:
            print("0")
            let isInProgress = true
            cell.configureCell(isInProgress: isInProgress)
        case 1:
            print("1")
            let isInAssigned = true  
            cell.configureCell(isInAssigned: isInAssigned)
        case 2:
            print("2")
            let isInCompleted = true
            cell.configureCell(isInCompleted: isInCompleted)
        default:
            print("unknown")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    
    
    
}
