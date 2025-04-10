//
//  FilterItemsViewController.swift
//  E-Learning
//
//  Created by Aya Mashaly on 01/03/2025.
//

import UIKit

protocol FilterItemsViewControllerDelegate: AnyObject {
    func didTapApplyButton()
}

class FilterItemsViewController: UIViewController {
    
    // MARK: - Properties
    var tenantViewModel = TenantViewModel.shared
    var collectionView: UICollectionView!
    var applyButton: UIButton!
    var viewModel: SearchViewModel!
    weak var delegate: FilterItemsViewControllerDelegate?
    
    var sections: [SearchViewModel.Section] {
        return viewModel.sections
    }
    
    var selectedFilters: [String: [String]] {
        get { return viewModel.selectedFilters }
        set { viewModel.selectedFilters = newValue }
    }
    
    var selectedFiltersCount: Int {
        get { return viewModel.selectedFiltersCount }
        set { viewModel.selectedFiltersCount = newValue }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        view.backgroundColor = .white
        
        let layout = RTLCollectionFlow()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.allowsMultipleSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: "FiltrationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FiltrationCollectionViewCell")
        collectionView.register(FilterSectionHeaderViewCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FilterSectionHeaderViewCollectionReusableView.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        applyButton = UIButton(type: .system)
        applyButton.setTitle("Apply".localized, for: .normal)
        applyButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 15)
        applyButton.setTitleColor(UIColor.white, for: .normal)
        applyButton.backgroundColor = tenantViewModel.primaryColor
        applyButton.layer.cornerRadius = 20
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        view.addSubview(applyButton)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -10),
            
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            applyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func applyButtonTapped() {
        delegate?.didTapApplyButton()
    }
}
