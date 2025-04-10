//
//  MyLearningViewController.swift
//  E-Learning
//
//  Created by aya on 19/11/2024.
//

import UIKit
import SDWebImage

class MyLearningViewController: UIViewController, MyLearningTableViewCellDelegate {
    
    // MARK: - Properties
    
    lazy var tenantViewModel = TenantViewModel.shared
    
    @IBOutlet weak var myLearningLabel: UILabel!
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tabelView: UITableView!
    let viewModel = LearningViewModel()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        myLearningLabel.text = "My Learning".localized
        setupTableView()
        setupSegmentedControl()
        
        viewModel.onDataUpdated = { [weak self] in
            self?.tabelView.reloadData()
        }
        
        guard let token = UserSessionManager.shared.token else { return }
        viewModel.fetchMyLearning(token: token)
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.showsVerticalScrollIndicator = false
        tabelView.register(UINib(nibName: "MyLearningTableViewCell", bundle: nil), forCellReuseIdentifier: "MyLearningTableViewCell")
    }
    
    private func setupSegmentedControl() {
        
        guard let segmentedControl = mySegmentedControl else { return }
        
        segmentedControl.setTitle(NSLocalizedString("In Progress", comment: ""), forSegmentAt: 0)
        segmentedControl.setTitle(NSLocalizedString("Assigned", comment: ""), forSegmentAt: 1)
        segmentedControl.setTitle(NSLocalizedString("Completed", comment: ""), forSegmentAt: 2)
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.selectedSegmentTintColor = tenantViewModel.primaryColor
        
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        segmentedControl.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 15, weight: .bold)
        ], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Roboto-Medium", size: 15) ?? .systemFont(ofSize: 15, weight: .medium)
        ], for: .selected)
        
    }
    
    // MARK: - Actions
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        
        tabelView.reloadData()
    }
    
    // MARK: - Delegate Method
    
    func didTapShareCertificate(certificateURL: String) {
        print("Certificate URL: \(certificateURL)")
        guard let url = URL(string: certificateURL) else {
            print("Invalid certificate URL: \(certificateURL)")
            return
        }
        
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
        
        SDWebImageManager.shared.loadImage(with: url, options: .highPriority, progress: nil) { [weak self] (image, data, error, cacheType, finished, imageURL) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
                
                if let image = image, error == nil {
                    let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                    activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact]
                    self.present(activityViewController, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Failed to load certificate image", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
