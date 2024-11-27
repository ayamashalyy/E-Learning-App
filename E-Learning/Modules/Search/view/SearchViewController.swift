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
    }
    
    var currentState: SearchState = .recentSearches
    
    var searchView = UIView()
    var searchTextField = UITextField()
    var searchButton = UIButton()
    var cancelButton = UIButton()
    var tableView = UITableView()
    var searchLabel = UILabel()
    
    
    var recentSearches: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadRecentSearches()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentState = .recentSearches
        tableView.reloadData()
    }
    
    
    
    func setupViews() {
        searchLabel = UILabel()
        searchLabel.text = "Search"
        searchLabel.textAlignment = .center
        searchLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        searchLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchLabel)
        
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
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            searchLabel.widthAnchor.constraint(equalToConstant: 300),
            searchLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 20),
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
    }
    
    @objc func cancelButtonTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        currentState = .recentSearches
        tableView.reloadData()
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


extension SearchViewController {
    func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: "recentSearches")
    }
    
    func loadRecentSearches() {
        if let savedSearches = UserDefaults.standard.array(forKey: "recentSearches") as? [String] {
            recentSearches = savedSearches
        }
    }
    
}



extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentState {
        case .recentSearches:
            return recentSearches.count
        case .totalResults:
            return 20
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch currentState {
        case .recentSearches:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecentSearchesTableViewCell else {
                return UITableViewCell()
            }
            cell.recentSearchLabel.text = recentSearches[indexPath.row]
            cell.onCancelTapped = { [weak self] in
                self?.recentSearches.remove(at: indexPath.row)
                self?.saveRecentSearches()
                tableView.reloadData()
            }
            
            return cell
            
        case .totalResults:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalResultsTableViewCell", for: indexPath) as? TotalResultsTableViewCell else {
                return UITableViewCell()
            }
            
            cell.totalResultSearchCategory.text = "Design"
            cell.totalResultSearchNameCourse.text = "Google UX Design"
            cell.totalResultSearchConstractorName.text = "Jacob Jones"
            cell.totalResultSearchImage.image = UIImage(named: "myLearning")
            
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor(named: "myCustom")
        
        switch currentState {
        case .recentSearches:
            titleLabel.text = "Recent Searches"
        case .totalResults:
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
        
        return headerView    }
    
    @objc func filterButtonTapped() {
        print("Filter button tapped")
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
        switch currentState {
        case .totalResults:
            return 120
        case .recentSearches:
            return 50
        }
    }
}
