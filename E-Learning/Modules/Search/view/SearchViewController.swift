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
        case totalResults
        case filterView
    }
    
    struct Section {
        let title: String
        let items: [String]
    }
    
    let sections: [Section] = [
        Section(title: "Category", items: ["Data Science", "Design", "Business", "Language Learning"]),
        Section(title: "Learning Type", items: ["Course", "Career Path"]),
        Section(title: "Level", items: ["Beginner", "Intermediate", "Advanced"]),
        Section(title: "Price", items: ["Paid", "Free"]),
        Section(title: "Language", items: ["English", "Arabic"])
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
    var selectedFilters: [String: [String]] = [:]
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Search"
        configureNavigationBar()
        loadRecentSearches()
        setupViews()
        setupConstraints()
        collectionView.allowsMultipleSelection = true
        
    }
    
    private func configureNavigationBar() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .foregroundColor: UIColor.black
        ]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
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
            currentState = .totalResults
            noRecentSearchImageView.isHidden = true
            filterContainerView.isHidden = true
            tableView.isHidden = false
            self.title = "Search"
            self.navigationItem.leftBarButtonItem = nil
            tableView.reloadData()
            
        } else {
            currentState = .recentSearches
            tableView.reloadData()
            updateNoRecentSearchImage()
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
        searchTextField.placeholder = "Search"
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
        cancelButton.setImage(UIImage(named: "multiply"), for: .normal)
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
            noRecentSearchImageView.widthAnchor.constraint(equalToConstant: 200),
            noRecentSearchImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            searchView.widthAnchor.constraint(equalToConstant: 250),
            searchView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            searchTextField.centerXAnchor.constraint(equalTo: searchView.centerXAnchor),
            searchTextField.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: 40),
            searchTextField.widthAnchor.constraint(equalToConstant: 200),
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
            filterContainerView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 25),
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
        layout.itemSize = CGSize(width: 250, height: 40)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        
        filterContainerView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filterContainerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: filterContainerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: filterContainerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: filterContainerView.bottomAnchor)
        ])
    }
    
    @objc func searchButtonTapped() {
        guard let text = searchTextField.text, !text.isEmpty else {
            
            let alert = UIAlertController(title: "Error", message: "Please enter a search term.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        recentSearches.insert(text, at: 0)
        saveRecentSearches()
        currentState = .totalResults
        tableView.reloadData()
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        updateNoRecentSearchImage()
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
        if currentState == .recentSearches {
            return recentSearches.count
        } else if currentState == .totalResults {
            return 20
        }
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentState == .recentSearches {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecentSearchesTableViewCell else {
                return UITableViewCell()
            }
            cell.recentSearchLabel.text = recentSearches[indexPath.row]
            cell.onCancelTapped = { [weak self] in
                self?.recentSearches.remove(at: indexPath.row)
                self?.saveRecentSearches()
                self?.updateNoRecentSearchImage()
                tableView.reloadData()
            }
            return cell
        }
        else if currentState == .totalResults {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalResultsTableViewCell", for: indexPath) as? TotalResultsTableViewCell else {
                return UITableViewCell()
            }
            cell.totalResultSearchCategory.text = "Design"
            cell.totalResultSearchNameCourse.text = "Google UX Design"
            cell.totalResultSearchConstractorName.text = "Jacob Jones"
            cell.totalResultSearchImage.image = UIImage(named: "myLearning")
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if recentSearches.isEmpty && currentState == .recentSearches {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor(named: "myCustom")
        
        if currentState == .recentSearches {
            titleLabel.text = "Recent Searches"
        } else if currentState == .totalResults {
            titleLabel.text = "210 Total Results"
        }
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        if currentState == .totalResults {
            let filterButton = UIButton(type: .system)
            filterButton.setImage(UIImage(named: "ion_filter"), for: .normal)
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
        noRecentSearchImageView.isHidden = true
        filterContainerView.isHidden = false
        
        self.title = "Filtration"
        if let tabBarItem = self.tabBarController?.tabBar.items?[self.tabBarController?.selectedIndex ?? 0] {
            tabBarItem.title = "Search"
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .foregroundColor: UIColor.black
        ]
        
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        let backButtonImage = UIImage(named: "Icon 1")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backToSearch))
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    @objc func backToSearch() {
        currentState = .totalResults
        tableView.isHidden = false
        noRecentSearchImageView.isHidden = true
        filterContainerView.isHidden = true
        tableView.reloadData()
        
        self.title = "Search"
        if let tabBarItem = self.tabBarController?.tabBar.items?[self.tabBarController?.selectedIndex ?? 0] {
            tabBarItem.title = "Search"
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .foregroundColor: UIColor.black
        ]
        
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        self.navigationItem.leftBarButtonItem = nil
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = UIColor(named: "myCustom")
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            header.widthAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSearch = recentSearches[indexPath.row]
        searchTextField.text = selectedSearch
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentState == .totalResults {
            return 120
        } else if currentState == .recentSearches {
            return 50
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
