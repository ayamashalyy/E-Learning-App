//
//  AllCoursesCategoriesVC.swift
//  E-Learning
//
//  Created by Aya Mashaly on 08/03/2025.
//

import UIKit

class AllCoursesCategoriesVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var categoriesCollection: UICollectionView!
    let homeViewModel = HomeViewModel.shared
    private var tenantViewModel = TenantViewModel.shared
    let viewModel = SearchViewModel()
    let resultFeaturedCourses = TotalResultsAfterFilterViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FiltrationCollectionViewCell", bundle: nil)
        categoriesCollection.register(nib, forCellWithReuseIdentifier: "FiltrationCollectionViewCell")
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.courseCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiltrationCollectionViewCell", for: indexPath) as! FiltrationCollectionViewCell
        
        let coursesCategories = homeViewModel.getCourseCategoriesViewModels()
        let category = coursesCategories[indexPath.row]
        
        cell.FiltrationCategory.text = category.name
        cell.selectedBackgroundView = .none
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let coursesCategories = homeViewModel.getCourseCategoriesViewModels()
        let category = coursesCategories[indexPath.row]
        
        let labelWidth = category.name.width(usingFont: UIFont(name: "Roboto-Medium", size: 14) ?? .boldSystemFont(ofSize: 14))
        let padding: CGFloat = 60
        return CGSize(width: labelWidth + padding, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let coursesCategories = homeViewModel.getCourseCategoriesViewModels()
        let category = coursesCategories[indexPath.row]
        didSelectCourseCategories(category.id)
    }
    
    // MARK: - Logic to open filtered courses view
    func didSelectCourseCategories(_ categoryId: Int) {
        print("Selected Course: \(categoryId)")
        resultFeaturedCourses.title = "Filtered Courses"
        resultFeaturedCourses.setUpBackButton()
        resultFeaturedCourses.filterButton.isHidden = true
        resultFeaturedCourses.viewModel = self.viewModel
        resultFeaturedCourses.viewModel.selectedFiltersCount = 1
        
        let navigationController = UINavigationController(rootViewController: resultFeaturedCourses)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
        
        viewModel.fetchCourses(categoryId: categoryId) { success in
            if success {
                DispatchQueue.main.async {
                    self.resultFeaturedCourses.tableView.reloadData()
                }
            } else {
                print("Failed to fetch data")
            }
        }
    }
    
    // MARK: - setUpBackButton Methods
    func setUpBackButton() {
        let backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        
        if let backButtonImage = backButtonImage {
            let tintedImage = backButtonImage.withTintColor(tenantViewModel.primaryColor ?? .blue, renderingMode: .alwaysOriginal)
            let backButton = UIBarButtonItem(image: tintedImage, style: .plain, target: self, action: #selector(backButtonTapped))
            self.navigationItem.leftBarButtonItem = backButton
        }
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
