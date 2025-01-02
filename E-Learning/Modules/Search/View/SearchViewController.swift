//
//  SearchViewController.swift
//  E-Learning
//
//  Created by aya on 19/11/2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    enum SearchState {
        case recentSearches
        case totalResultsBeforeFilter
        case totalResultsAfterFilter
        case filterView
    }
    
    struct Section {
        let title: String
        let items: [String]
    }
    
    let sections: [Section] = [
        Section(title: "Category".localized, items: ["Data Science".localized, "Design".localized, "Business".localized, "Language Learning".localized]),
        Section(title: "Level".localized, items: ["Beginner".localized, "Intermediate".localized, "Advanced".localized]),
    ]
    
    var currentState: SearchState = .recentSearches
    var recentSearches: [String] = []
    var searchView = UIView()
    var searchTextField = UITextField()
    var searchButton = UIButton()
    var cancelButton = UIButton()
    var tableView = UITableView()
    var searchLabel = UILabel()
    var noRecentSearchImageView: UIImageView!
    var filterContainerView: UIView!
    var allResults: [Course] = []
    var filteredResults: [Course] = []
    var selectedFilters: [String: [String]] = [:]
    var collectionView: UICollectionView!
    var applyButton: UIButton!
    var selectedFiltersCount: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Search".localized
        configureNavigationBar()
        loadRecentSearches()
        setupViews()
        setupConstraints()
        collectionView.allowsMultipleSelection = true
        
    }
    
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
    
    private func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: Constants.recentSearchesKey)
    }
    
    private func loadRecentSearches() {
        if let savedSearches = UserDefaults.standard.array(forKey: Constants.recentSearchesKey) as? [String] {
            recentSearches = savedSearches
        }
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
    
    
    func setupFilterView() {
        
        let layout = UICollectionViewFlowLayout()
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
        applyButton.backgroundColor = UIColor(named: "myCustom")
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
    
    @objc func searchButtonTapped() {
        guard let text = searchTextField.text, !text.isEmpty else {
            
            let alert = UIAlertController(title: "Error", message: "Please enter a search term.".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        recentSearches.insert(text, at: 0)
        saveRecentSearches()
        currentState = .totalResultsBeforeFilter
        tableView.reloadData()
        updateNoRecentSearchImage()
        resetFilters()
    }
    
    @objc func cancelButtonTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        currentState = .recentSearches
        tableView.isHidden = false
        filterContainerView.isHidden = true
        tableView.reloadData()
        updateNoRecentSearchImage()
        
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchButtonTapped()
        }
        return true
    }
}




extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch currentState {
        case .recentSearches:
            return recentSearches.count
        case .totalResultsBeforeFilter:
            return 20
        case .totalResultsAfterFilter:
            return 10
        case .filterView:
            return 0
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentState == .recentSearches {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecentSearchesTableViewCell else {
                return UITableViewCell()
            }
            cell.recentSearchLabel.text = recentSearches[indexPath.row]
            cell.selectionStyle = .none
            cell.onCancelTapped = { [weak self] in
                self?.recentSearches.remove(at: indexPath.row)
                self?.saveRecentSearches()
                self?.updateNoRecentSearchImage()
                tableView.reloadData()
            }
            return cell
        }
        else if currentState == .totalResultsBeforeFilter {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalResultsTableViewCell", for: indexPath) as? TotalResultsTableViewCell else {
                return UITableViewCell()
            }
            cell.totalResultSearchCategory.text = "Design"
            cell.totalResultSearchNameCourse.text = "Google UX Design"
            cell.totalResultSearchConstractorName.text = "Jacob Jones"
            cell.totalResultSearchImage.image = UIImage(named: "myLearning")?.imageFlippedForRightToLeftLayoutDirection()
            cell.selectionStyle = .none
            return cell
        } else if currentState == .totalResultsAfterFilter {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalResultsTableViewCell", for: indexPath) as? TotalResultsTableViewCell else {
                return UITableViewCell()
            }
            cell.totalResultSearchCategory.text = "Design"
            cell.totalResultSearchNameCourse.text = "Google UX Design"
            cell.totalResultSearchConstractorName.text = "Jacob Jones"
            cell.totalResultSearchImage.image = UIImage(named: "myLearning")?.imageFlippedForRightToLeftLayoutDirection()
            cell.selectionStyle = .none
            return cell
            
        } else {
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if recentSearches.isEmpty && currentState == .recentSearches {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        
        
        if currentState == .recentSearches {
            titleLabel.text = "Recent Searches".localized
            titleLabel.textColor = UIColor(named: "myCustom")
        } else if currentState == .totalResultsBeforeFilter {
            titleLabel.text = "\(20) \(NSLocalizedString("Total Results", comment: ""))"
        }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        if currentState == .totalResultsBeforeFilter {
            let filterButton = UIButton(type: .system)
            filterButton.setImage(UIImage(named: "ion_filter")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
            filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(filterButton)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                filterButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
                filterButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                filterButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10)
            ])
        } else if currentState == .totalResultsAfterFilter {
            let resultsCountLabel = UILabel()
            resultsCountLabel.text = "10".localized
            resultsCountLabel.font = UIFont(name: "Roboto-Medium", size: 16)
            resultsCountLabel.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(resultsCountLabel)
            
            let resultsTextLabel = UILabel()
            resultsTextLabel.text = "Total Results".localized
            resultsTextLabel.font = UIFont(name: "Roboto-Medium", size: 16)
            resultsTextLabel.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(resultsTextLabel)
            
            let filtersLabel = UILabel()
            filtersLabel.text = "(\(selectedFiltersCount ?? 0) \(NSLocalizedString("Filters", comment: "")))"
            filtersLabel.font = UIFont(name: "Roboto-Medium", size: 16)
            filtersLabel.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(filtersLabel)
            
            let filterButton = UIButton(type: .system)
            filterButton.setImage(UIImage(named: "icon_filter-remove")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
            filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(filterButton)
            
            NSLayoutConstraint.activate([
                resultsCountLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                resultsCountLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                
                resultsTextLabel.leadingAnchor.constraint(equalTo: resultsCountLabel.trailingAnchor, constant: 5),
                resultsTextLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                
                filtersLabel.leadingAnchor.constraint(equalTo: resultsTextLabel.trailingAnchor, constant: 5),
                filtersLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                
                filterButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
                filterButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
            
        } else {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
        }
        
        return headerView
    }
    
    
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
        
        let backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(applyButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    @objc func applyButtonTapped() {
        
        applyFilters()
        currentState = .totalResultsAfterFilter
        tableView.isHidden = false
        filterContainerView.isHidden = true
        searchView.isHidden = false
        tableView.reloadData()
        
        self.title = "Search".localized
        if let tabBarItem = self.tabBarController?.tabBar.items?[self.tabBarController?.selectedIndex ?? 0] {
            tabBarItem.title = "Search".localized
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Roboto-Bold", size: 20) ?? .boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.black
        ]
        
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        self.navigationItem.leftBarButtonItem = nil
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor(named: "myCustom")
            header.textLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSearch = recentSearches[indexPath.row]
        searchTextField.text = selectedSearch
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentState == .totalResultsBeforeFilter {
            return 120
        } else if currentState == .recentSearches {
            return 50
        } else if currentState == .totalResultsAfterFilter {
            return 120
        }
        return 0
    }
    
    
    func updateNoRecentSearchImage() {
        if recentSearches.isEmpty {
            noRecentSearchImageView.isHidden = false
        } else {
            noRecentSearchImageView.isHidden = true
        }
    }
}
