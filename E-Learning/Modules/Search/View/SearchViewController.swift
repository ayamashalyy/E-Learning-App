//
//  SearchViewController.swift
//  E-Learning
//
//  Created by aya on 19/11/2024.
//

import UIKit

class SearchViewController: UIViewController{
    
    // MARK: - Properties
    var recentSearchesViewController: RecentSearchesViewController!
    var totalResultsBeforeFilterViewController: TotalResultsBeforeFilterViewController!
    var totalResultsAfterFilterViewController: TotalResultsAfterFilterViewController!
    var filterViewController: FilterItemsViewController!
    var viewModel = SearchViewModel()
    var courseCategoriesViewModel = CourseCategoriesViewModel()
    var instructorViewModel = InstructorViewModel()
    var tenantViewModel = TenantViewModel.shared
    
    // MARK: - UI Components
    var searchView = UIView()
    var searchTextField = UITextField()
    var searchButton = UIButton()
    var cancelButton = UIButton()
    var searchLabel = UILabel()
    var noRecentSearchImageView: UIImageView!
    var backButtonImage: UIImage!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Search".localized
        configureNavigationBar()
        viewModel.loadRecentSearches()
        setupViews()
        setupConstraints()
        setupSubControllers()
        updateUIForCurrentState()
        fetchCategoriesAndInstructors()
        recentSearchesViewController.tableView.reloadData()
        viewModel.onComplete = {
            self.updateUIForCurrentState()
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
        
        noRecentSearchImageView = UIImageView(image: UIImage(named: "search"))
        noRecentSearchImageView.contentMode = .scaleAspectFit
        noRecentSearchImageView.translatesAutoresizingMaskIntoConstraints = false
        noRecentSearchImageView.isHidden = true
        view.addSubview(noRecentSearchImageView)
    }
    
    func setupConstraints() {
        
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
            noRecentSearchImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noRecentSearchImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noRecentSearchImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            noRecentSearchImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])
    }
    
    // MARK: - Setup RecentSearchesViewController
    private func setupRecentSearchesViewController() {
        recentSearchesViewController = RecentSearchesViewController()
        recentSearchesViewController.viewModel = viewModel
        recentSearchesViewController.delegate = self
        recentSearchesViewController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Setup TotalResultsBeforeFilterViewController
    private func setupTotalResultsBeforeFilterViewController() {
        totalResultsBeforeFilterViewController = TotalResultsBeforeFilterViewController()
        totalResultsBeforeFilterViewController.viewModel = viewModel
        totalResultsBeforeFilterViewController.delegate = self
        totalResultsBeforeFilterViewController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Setup TotalResultsAfterFilterViewController
    private func setupTotalResultsAfterFilterViewController() {
        totalResultsAfterFilterViewController = TotalResultsAfterFilterViewController()
        totalResultsAfterFilterViewController.viewModel = viewModel
        totalResultsAfterFilterViewController.delegate = self
        totalResultsAfterFilterViewController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    // MARK: - Setup FilterViewController
    private func setupFilterItemsViewController() {
        filterViewController = FilterItemsViewController()
        filterViewController.viewModel = viewModel
        filterViewController.delegate = self
        filterViewController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Setup Sub-Controllers
    private func setupSubControllers() {
        setupRecentSearchesViewController()
        setupTotalResultsBeforeFilterViewController()
        setupTotalResultsAfterFilterViewController()
        setupFilterItemsViewController()
    }
    // MARK: - Update UI Based on Current State
    func updateUIForCurrentState() {
        
        recentSearchesViewController.view.removeFromSuperview()
        totalResultsBeforeFilterViewController.view.removeFromSuperview()
        totalResultsAfterFilterViewController.view.removeFromSuperview()
        filterViewController.view.removeFromSuperview()
        
        switch  viewModel.currentState {
        case .recentSearches:
            addChild(recentSearchesViewController)
            view.addSubview(recentSearchesViewController.view)
            recentSearchesViewController.didMove(toParent: self)
            
            NSLayoutConstraint.activate([
                recentSearchesViewController.view.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10),
                recentSearchesViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                recentSearchesViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                recentSearchesViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            recentSearchesViewController.tableView.isHidden = false
            recentSearchesViewController.tableView.reloadData()
            
        case .totalResultsBeforeFilter:
            addChild(totalResultsBeforeFilterViewController)
            view.addSubview(totalResultsBeforeFilterViewController.view)
            totalResultsBeforeFilterViewController.didMove(toParent: self)
            
            NSLayoutConstraint.activate([
                totalResultsBeforeFilterViewController.view.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10),
                totalResultsBeforeFilterViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                totalResultsBeforeFilterViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                totalResultsBeforeFilterViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            totalResultsBeforeFilterViewController.tableView.reloadData()
            
        case .totalResultsAfterFilter:
            addChild(totalResultsAfterFilterViewController)
            view.addSubview(totalResultsAfterFilterViewController.view)
            totalResultsAfterFilterViewController.didMove(toParent: self)
            
            NSLayoutConstraint.activate([
                totalResultsAfterFilterViewController.view.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10),
                totalResultsAfterFilterViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                totalResultsAfterFilterViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                totalResultsAfterFilterViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            searchView.isHidden = false
            totalResultsAfterFilterViewController.tableView.reloadData()
            
        case .filterView:
            addChild(filterViewController)
            view.addSubview(filterViewController.view)
            filterViewController.didMove(toParent: self)
            
            NSLayoutConstraint.activate([
                filterViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                filterViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                filterViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                filterViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            searchView.isHidden = true
            filterViewController.collectionView.reloadData()
            
        case .emptySearch:
            noRecentSearchImageView.isHidden = false
            recentSearchesViewController.tableView.isHidden = true
        }
    }
    
    // MARK: - fetchCategoriesAndInstructors
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
        
        viewModel.sections = [
            SearchViewModel.Section(title: "Category".localized, items: categories),
            SearchViewModel.Section(title: "Instructor".localized, items: instructors)
        ]
        filterViewController.collectionView.reloadData()
    }
}
