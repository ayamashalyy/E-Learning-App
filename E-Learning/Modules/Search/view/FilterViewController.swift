//
//  FilterViewController.swift
//  E-Learning
//
//  Created by aya on 27/11/2024.
//

import UIKit

class FilterViewController: UIViewController {
    
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
    
    var searchView = UIView()
    var searchTextField = UITextField()
    var searchImage = UIImageView()
    var cancelButton = UIButton()
    var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        self.navigationItem.title = "Filtration"
        let backButtonImage = UIImage(named: "Icon 1")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(cancelTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func setupViews() {
        searchView = UIView()
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.backgroundColor = UIColor(named: "myLearning")
        searchView.layer.cornerRadius = 10
        searchView.clipsToBounds = true
        view.addSubview(searchView)
        
        searchImage = UIImageView()
        searchImage.translatesAutoresizingMaskIntoConstraints = false
        searchImage.image = UIImage(named: "mingcute_search-line")
        searchImage.contentMode = .scaleAspectFit
        searchView.addSubview(searchImage)
        
        searchTextField = UITextField()
        searchTextField.placeholder = "Search"
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.backgroundColor = UIColor(named: "myLearning")
        searchView.addSubview(searchTextField)
        
        cancelButton = UIButton(type: .system)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(UIImage(named: "multiply"), for: .normal)
        cancelButton.imageView?.contentMode = .scaleAspectFit
        searchView.addSubview(cancelButton)
        
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
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            searchView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            searchView.widthAnchor.constraint(equalToConstant: 250),
            searchView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            searchImage.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchImage.leadingAnchor.constraint(equalTo: searchView.leadingAnchor, constant: 15),
            searchImage.widthAnchor.constraint(equalToConstant: 30),
            searchImage.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            searchTextField.centerXAnchor.constraint(equalTo: searchView.centerXAnchor),
            searchTextField.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: searchImage.leadingAnchor, constant: 40),
            searchTextField.widthAnchor.constraint(equalToConstant: 200),
            searchTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: searchView.trailingAnchor, constant: -15),
            cancelButton.widthAnchor.constraint(equalToConstant: 14),
            cancelButton.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func cancelButtonTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiltrationCollectionViewCell", for: indexPath) as? FiltrationCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = sections[indexPath.section].items[indexPath.row]
        cell.FiltrationCategory.text = item
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = sections[indexPath.section].items[indexPath.row]
        let labelWidth = item.width(usingFont: UIFont.systemFont(ofSize: 14))
        let padding: CGFloat = 40
        return CGSize(width: labelWidth + padding, height: 55)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterSectionHeaderViewCollectionReusableView.identifier, for: indexPath) as! FilterSectionHeaderViewCollectionReusableView
        header.titleLabel.text = sections[indexPath.section].title
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let bottomInset: CGFloat = 15
        return UIEdgeInsets(top: 5, left: 10, bottom: bottomInset, right: 10)
    }
    
}
