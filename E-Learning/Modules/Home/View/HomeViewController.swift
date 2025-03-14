//
//  HomeViewController.swift
//  E-Learning
//
//  Created by aya on 19/11/2024.
//

import UIKit

private let reuseIdentifier = "WelcomeCell"
private let reuseIdentifier1 = "ContinueCell"
private let headerReuseIdentifier = "SectionHeaderView"
private let coursesTitleCellIdentifier = "CoursesTitleCell"
private let SectionHeaderViewCell = "SectionHeaderViewCell"
private let reuseIdentifier2 = "CoursesCell"
private let reuseIdentifier3 = "FeaturedCell"


class HomeViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout, FeaturedCoursesCollectionViewDelegate, CoursesCategoriesSectionCellDelegate, SectionHeaderViewDelegate {
    
    // MARK: - Properties
    
    private let sectionTitles = ["Courses Categories".localized, "Featured Courses".localized, "Most Popular".localized, "Latest Courses".localized]
    private var tenantViewModel = TenantViewModel.shared
    private var userSessionManager = UserSessionManager.shared
    private var homeViewModel = HomeViewModel.shared
    let viewModel = SearchViewModel()
    let resultFeaturedCourses = TotalResultsAfterFilterViewController()
    let allCoursesCategories = AllCoursesCategoriesVC()
    
    // MARK: - Lifecycle
    
    init() {
        super.init(collectionViewLayout: RTLCollectionFlow())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        registerNibFiles()
        fetchHomeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func didUpdateProfile(name: String, email: String) {
        userSessionManager.name = name
        collectionView.reloadData()
    }
    
    // MARK: - Data Fetching
    func fetchHomeData() {
        guard let token = userSessionManager.token else { return }
        homeViewModel.onDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        homeViewModel.fetchHomeData(token: token)
    }
    
    
    // MARK: - Cell Registration
    
    func registerNibFiles() {
        let nib = UINib(nibName: "WelcomeCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        let continueNib = UINib(nibName: "ProgressContinueCollectionViewCell", bundle: nil)
        collectionView.register(continueNib, forCellWithReuseIdentifier: reuseIdentifier1)
        
        collectionView.register(CoursesCategoriesSectionCell.self, forCellWithReuseIdentifier: CoursesCategoriesSectionCell.identifier)
        collectionView.register(FeaturedCoursesCollectionView.self, forCellWithReuseIdentifier: FeaturedCoursesCollectionView.identifier)
        collectionView.register(SectionHeaderView.self, forCellWithReuseIdentifier: SectionHeaderViewCell)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WelcomeCollectionViewCell
            headerCell.configureCell(user: userSessionManager.name ?? "Aya")
            return headerCell
            
        case 1:
            let continueCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath) as! ProgressContinueCollectionViewCell
            continueCell.selectedBackgroundView = .none
            return continueCell
            
        case 2:
            let coursesTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderViewCell, for: indexPath) as! SectionHeaderView
            coursesTitleCell.delegate = self
            coursesTitleCell.tag = indexPath.section
            coursesTitleCell.configure(title: sectionTitles[0], showAction: true )
            return coursesTitleCell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoursesCategoriesSectionCell.identifier, for: indexPath) as! CoursesCategoriesSectionCell
            if homeViewModel.isLoading {
                cell.showLoadingIndicator()
            } else {
                cell.hideLoadingIndicator()
                let courseCategories = homeViewModel.getCourseCategoriesViewModels()
                cell.viewModel.updateCategories(courseCategories)
            }
            
            cell.delegate = self
            return cell
            
        case 4:
            let coursesTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderViewCell, for: indexPath) as! SectionHeaderView
            coursesTitleCell.delegate = self
            coursesTitleCell.tag = indexPath.section
            coursesTitleCell.configure(title: sectionTitles[1], showAction: true)
            return coursesTitleCell
            
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCoursesCollectionView.identifier, for: indexPath) as! FeaturedCoursesCollectionView
            if homeViewModel.isLoading {
                cell.showLoadingIndicator()
            } else {
                cell.hideLoadingIndicator()
                let featuredCourses = homeViewModel.getFeaturedCourseViewModels()
                cell.viewModel.updateCourses(featuredCourses)
            }
            cell.delegate = self
            return cell
            
            
        case 6:
            let coursesTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderViewCell, for: indexPath) as! SectionHeaderView
            let coursesTitle = sectionTitles[2]
            coursesTitleCell.configure(title:coursesTitle, showAction: false )
            return coursesTitleCell
            
        case 7:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCoursesCollectionView.identifier, for: indexPath) as! FeaturedCoursesCollectionView
            if homeViewModel.isLoading {
                cell.showLoadingIndicator()
            } else {
                cell.hideLoadingIndicator()
                let mostPopular = homeViewModel.getMostCourseViewModels()
                cell.viewModel.updateCourses(mostPopular)
            }
            cell.delegate = self
            return cell
            
            
        case 8:
            let coursesTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderViewCell, for: indexPath) as! SectionHeaderView
            let coursesTitle = sectionTitles[3]
            coursesTitleCell.configure(title:coursesTitle, showAction: false )
            return coursesTitleCell
            
        case 9:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCoursesCollectionView.identifier, for: indexPath) as! FeaturedCoursesCollectionView
            if homeViewModel.isLoading {
                cell.showLoadingIndicator()
            } else {
                cell.hideLoadingIndicator()
                let latestCourses = homeViewModel.getLatestCourseViewModels()
                cell.viewModel.updateCourses(latestCourses)
            }
            cell.delegate = self
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.frame.width , height: 80)
        case 1:
            return CGSize(width: collectionView.frame.width , height: 190)
        case 2 , 4 , 6 , 8:
            return CGSize(width: collectionView.frame.width - 20, height: 40)
        case 3:
            return CGSize(width: collectionView.frame.width , height: 60)
        case 5:
            return CGSize(width: collectionView.frame.width , height: 200)
        case 7:
            return CGSize(width: collectionView.frame.width , height: 200)
        case 9:
            return CGSize(width: collectionView.frame.width , height: 200)
        default:
            return .zero
        }
    }
    
    // MARK: - Delegate Methods
    
    func didSelectCourse(courseSlug: String) {
        let nextViewController = CourseOverviewViewController()
        nextViewController.courseSlug = courseSlug
        let navigationController = UINavigationController(rootViewController: nextViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    func didSelectCourseCategories(_ categoryId: Int) {
        print("Selected Course: \(categoryId)")
        resultFeaturedCourses.title = "Filtered Courses"
        resultFeaturedCourses.setUpBackButton()
        resultFeaturedCourses.filterButton.isHidden = true
        resultFeaturedCourses.viewModel = self.viewModel
        resultFeaturedCourses.viewModel.selectedFiltersCount = 1
        
        viewModel.selectedCategoryId = categoryId
        viewModel.selectedInstructorId = nil
        viewModel.selectedFilters.removeAll()
        viewModel.isFeatured = nil
        
        let navigationController = UINavigationController(rootViewController: resultFeaturedCourses)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
        
        viewModel.currentPage = 1
        viewModel.fetchCourses(categoryId: categoryId) { success in
            if success {
                DispatchQueue.main.async {
                    self.resultFeaturedCourses.tableView.reloadData()
                }
            } else {
                print("Failed to fetch data for category \(categoryId)")
            }
        }
    }
    
    func didTapSeeAll(in section: Int) {
        
        if section == 2{
            allCoursesCategories.title = "Categories Courses".localized
            allCoursesCategories.setUpBackButton()
            let navigationController = UINavigationController(rootViewController: allCoursesCategories)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
        
        if section == 4 {
            resultFeaturedCourses.title = "Featured Courses".localized
            resultFeaturedCourses.setUpBackButton()
            resultFeaturedCourses.filterButton.isHidden = true
            resultFeaturedCourses.viewModel = self.viewModel
            resultFeaturedCourses.viewModel.selectedFiltersCount = 1
            
            viewModel.selectedCategoryId = nil
            viewModel.selectedInstructorId = nil
            viewModel.selectedFilters.removeAll()
            viewModel.isFeatured = true
            
            let navigationController = UINavigationController(rootViewController: resultFeaturedCourses)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
            
            viewModel.currentPage = 1
            viewModel.fetchCourses(isFeatured: true) { success in
                if success {
                    DispatchQueue.main.async {
                        self.resultFeaturedCourses.tableView.reloadData()
                    }
                } else {
                    print("Failed to fetch Featured Courses")
                }
            }
        }
    }
}


/*
 
 let storyboard = UIStoryboard(name: "Main", bundle: nil)
 if let nextViewController = storyboard.instantiateViewController(withIdentifier: "CourseViewController") as? CourseViewController {
 //nextViewController.courseTitle = course
 let navigationController = UINavigationController(rootViewController: nextViewController)
 navigationController.modalPresentationStyle = .fullScreen
 present(navigationController, animated: true, completion: nil)
 
 */
