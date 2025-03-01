//
//  SearchViewController.swift
//  E-Learning
//
//  Created by aya on 19/11/2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    struct Section {
        let title: String
        let items: [String]
    }
    
    // MARK: - Properties
    var currentState: SearchState = .recentSearches
    var viewModel = SearchViewModel()
    var courseCategoriesViewModel = CourseCategoriesViewModel()
    var instructorViewModel = InstructorViewModel()
    var recentSearches: [String] = []
    var selectedFilters: [String: [String]] = [:]
    var sections: [Section] = []
    var tenantViewModel = TenantViewModel.shared
    var selectedFiltersCount: Int!
    
    // MARK: - UI Components
    var searchView = UIView()
    var searchTextField = UITextField()
    var searchButton = UIButton()
    var cancelButton = UIButton()
    var tableView = UITableView()
    var searchLabel = UILabel()
    var noRecentSearchImageView: UIImageView!
    var filterContainerView: UIView!
    var collectionView: UICollectionView!
    var applyButton: UIButton!
    var backButtonImage: UIImage!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Search".localized
        configureNavigationBar()
        loadRecentSearches()
        setupViews()
        setupConstraints()
        collectionView.allowsMultipleSelection = true
        fetchCategoriesAndInstructors()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if currentState == .filterView {
            currentState = .totalResultsBeforeFilter
            noRecentSearchImageView.isHidden = true
            filterContainerView.isHidden = true
            tableView.isHidden = false
            searchView.isHidden = false
            self.title = "Search".localized
            self.navigationItem.leftBarButtonItem = nil
            tableView.reloadData()
            
        } else {
            currentState = .recentSearches
            tableView.reloadData()
            updateNoRecentSearchImage()
            searchTextField.text = ""
        }
    }
    
    // MARK: - Navigation Bar Configuration
    private func configureNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font: UIFont(name: "Roboto-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor.black
        ]
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - Recent Searches Handling
    func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: Constants.recentSearchesKey)
    }
    
    private func loadRecentSearches() {
        if let savedSearches = UserDefaults.standard.array(forKey: Constants.recentSearchesKey) as? [String] {
            recentSearches = savedSearches
        }
    }
    
    // MARK: - UI Setup
    func setupViews() {
        
        searchView = UIView()
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.backgroundColor = UIColor(named: "myLearning")
        searchView.layer.cornerRadius = 10
        searchView.clipsToBounds = true
        view.addSubview(searchView)
        
        searchTextField = UITextField()
        searchTextField.placeholder = "Search".localized
        searchTextField.backgroundColor = UIColor(named: "myLearning")
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.delegate = self
        searchView.addSubview(searchTextField)
        
        searchButton = UIButton(type: .system)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setImage(UIImage(named: "mingcute_search-line"), for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchView.addSubview(searchButton)
        
        cancelButton = UIButton(type: .system)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(UIImage(named: "multiply")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        cancelButton.imageView?.contentMode = .scaleAspectFit
        searchView.addSubview(cancelButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "RecentSearchesTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "TotalResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "TotalResultsTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        noRecentSearchImageView = UIImageView(image: UIImage(named: "search"))
        noRecentSearchImageView.contentMode = .scaleAspectFit
        noRecentSearchImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noRecentSearchImageView)
        
        filterContainerView = UIView()
        filterContainerView.translatesAutoresizingMaskIntoConstraints = false
        filterContainerView.isHidden = true
        view.addSubview(filterContainerView)
        
        setupFilterView()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            noRecentSearchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noRecentSearchImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noRecentSearchImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            noRecentSearchImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
            
        ])
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            searchView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            searchTextField.centerXAnchor.constraint(equalTo: searchView.centerXAnchor),
            searchTextField.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: 40),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            searchButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchButton.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 15),
            searchButton.widthAnchor.constraint(equalToConstant: 30),
            searchButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -15),
            cancelButton.widthAnchor.constraint(equalToConstant: 14),
            cancelButton.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            filterContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            filterContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            filterContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Filter View Setup
    func setupFilterView() {
        
        let layout = RTLCollectionFlow()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UINib(nibName: "FiltrationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FiltrationCollectionViewCell")
        collectionView.register(
            FilterSectionHeaderViewCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FilterSectionHeaderViewCollectionReusableView.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        filterContainerView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filterContainerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: filterContainerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: filterContainerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: filterContainerView.bottomAnchor)
        ])
        
        applyButton = UIButton(type: .system)
        applyButton.setTitle("Apply".localized, for: .normal)
        applyButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 15)
        applyButton.setTitleColor(UIColor.white, for: .normal)
        applyButton.backgroundColor = tenantViewModel.primaryColor
        applyButton.layer.cornerRadius = 20
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(applyButton)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        filterContainerView.addSubview(applyButton)
        
        NSLayoutConstraint.activate([
            applyButton.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 16),
            applyButton.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -16),
            applyButton.bottomAnchor.constraint(equalTo: filterContainerView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            applyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    // MARK: - Filter Button Action
    @objc func filterButtonTapped() {
        
        currentState = .filterView
        tableView.isHidden = true
        searchView.isHidden = true
        noRecentSearchImageView.isHidden = true
        filterContainerView.isHidden = false
        
        self.title = "Filtration".localized
        if let tabBarItem = self.tabBarController?.tabBar.items?[self.tabBarController?.selectedIndex ?? 0] {
            tabBarItem.title = "Search".localized
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Roboto-Bold", size: 20) ?? .boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.black
        ]
        
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        
        if let backButtonImage = backButtonImage {
            let tintedImage = backButtonImage.withTintColor(tenantViewModel.primaryColor ?? .blue, renderingMode: .alwaysOriginal)
            let backButton = UIBarButtonItem(image: tintedImage, style: .plain, target: self, action: #selector(applyButtonTapped))
            self.navigationItem.leftBarButtonItem = backButton
        }
        
    }
    
    
    func updateNoRecentSearchImage() {
        if recentSearches.isEmpty {
            noRecentSearchImageView.isHidden = false
        } else {
            noRecentSearchImageView.isHidden = true
        }
    }
    
    func fetchCategoriesAndInstructors() {
        courseCategoriesViewModel.fetchCourseCategories()
        instructorViewModel.fetchInstructors()
        
        courseCategoriesViewModel.onDataFetched = { [weak self] in
            guard let self = self else { return }
            self.updateSections()
        }
        
        instructorViewModel.onDataFetched = { [weak self] in
            guard let self = self else { return }
            self.updateSections()
        }
    }
    
    private func updateSections() {
        let categories = courseCategoriesViewModel.courseCategories.map { $0.name }
        let instructors = instructorViewModel.instructors.map { $0.name }
        
        sections = [
            Section(title: "Category".localized, items: categories),
            Section(title: "Instructor".localized, items: instructors)
        ]
        collectionView.reloadData()
    }
}
