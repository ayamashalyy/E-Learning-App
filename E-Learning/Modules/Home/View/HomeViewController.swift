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


class HomeViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout, FeaturedCoursesCollectionViewDelegate, CoursesCategoriesSectionCellDelegate {
    
    // MARK: - Properties
    
    private let sectionTitles = ["Courses Categories".localized, "Featured Courses".localized, "Most Popular".localized, "Latest Courses".localized]
    private var viewModel = CourseCategoriesViewModel()
    private var tenantViewModel = TenantViewModel.shared
    private var userSessionManager = UserSessionManager.shared
    
    let coursesTitles = ["Data Science", "Design","Bussince", "Law"]
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
        getCoursesCategories()
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
    
    func getCoursesCategories() {
        // Fetch data
        viewModel.onDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.fetchCourseCategories()
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
            let coursesTitle = sectionTitles[0]
            coursesTitleCell.configure(title:coursesTitle, showAction: true )
            return coursesTitleCell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoursesCategoriesSectionCell.identifier, for: indexPath) as! CoursesCategoriesSectionCell
            let courseCategories = (0..<viewModel.numberOfCategories()).map { viewModel.cellViewModel(at: $0)
            }
            cell.configure(with: courseCategories)
            cell.delegate = self
            return cell
            
        case 4:
            let coursesTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderViewCell, for: indexPath) as! SectionHeaderView
            let coursesTitle = sectionTitles[1]
            coursesTitleCell.configure(title:coursesTitle, showAction: true )
            return coursesTitleCell
            
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCoursesCollectionView.identifier, for: indexPath) as! FeaturedCoursesCollectionView
            cell.configure(with: ["Google UX Design", "Google UX Design", "Google UX Design"])
            cell.delegate = self
            return cell
            
            
        case 6:
            let coursesTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderViewCell, for: indexPath) as! SectionHeaderView
            let coursesTitle = sectionTitles[2]
            coursesTitleCell.configure(title:coursesTitle, showAction: false )
            return coursesTitleCell
            
        case 7:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCoursesCollectionView.identifier, for: indexPath) as! FeaturedCoursesCollectionView
            cell.configure(with: ["Google UX Design", "Google UX Design", "Google UX Design"])
            cell.delegate = self
            return cell
            
            
        case 8:
            let coursesTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderViewCell, for: indexPath) as! SectionHeaderView
            let coursesTitle = sectionTitles[3]
            coursesTitleCell.configure(title:coursesTitle, showAction: false )
            return coursesTitleCell
            
        case 9:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCoursesCollectionView.identifier, for: indexPath) as! FeaturedCoursesCollectionView
            cell.configure(with: ["Google UX Design", "Google UX Design", "Google UX Design"])
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
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("Selected Header Cell at section 0, item \(indexPath.item)")
        case 1:
            print("Selected Continue Cell at section 1, item \(indexPath.item)")
        case 2:
            print("Selected Section Header Cell at section 2, item \(indexPath.item)")
        case 3:
            print("Selected Course Title at section 3, item \(indexPath.item)")
            let selectedCourse = coursesTitles[indexPath.row]
            print("Selected Course: \(selectedCourse)")
        case 4:
            print("Selected Section Header Cell at section 4, item \(indexPath.item)")
            let nextViewController = CourseOverviewViewController(nibName: "CourseOverviewViewController", bundle: nil)
            let navigationController = UINavigationController(rootViewController: nextViewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        case 5 :
            print("Selected Section Header Cell at section 5")
        case 6:
            print("Selected Header Cell at section 6, item \(indexPath.item)")
        case 7:
            print("Selected Continue Cell at section 7, item \(indexPath.item)")
        case 8:
            print("Selected Section Header Cell at section 8, item \(indexPath.item)")
        case 9 :
            print("Selected Section Header Cell at section 9")
        default:
            break
        }
    }
    
    // MARK: - Delegate Methods
    
    func didSelectCourse(_ course: String) {
        print("تم اختيار الدورة: \(course)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nextViewController = storyboard.instantiateViewController(withIdentifier: "CourseViewController") as? CourseViewController {
            //nextViewController.courseTitle = course
            let navigationController = UINavigationController(rootViewController: nextViewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    func didSelectCourseCategories(_ course: String) {
        print("Selected Course: \(course)")
    }
}
