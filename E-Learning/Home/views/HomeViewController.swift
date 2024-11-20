//
//  HomeViewController.swift
//  E-Learning
//
//  Created by aya on 19/11/2024.
//

import UIKit


private let reuseIdentifier = "HeaderCustomCell"
private let reuseIdentifier1 = "ContinueCell"
private let headerReuseIdentifier = "SectionHeaderView"
private let coursesTitleCellIdentifier = "CoursesTitleCell"
private let sectionHeaderViewCell = "SectionHeaderViewCell"

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let sectionTitles = ["Courses Categories", "Featured Courses", "Most Popular", "Career Path", "Latest Courses"]
    let coursesTitles = ["Data Science", "Design", "Business", "Law"]
    private var useFirstImage: Bool = true

    // MARK: - Initializers
    init() {
        super.init(collectionViewLayout: HomeViewController.createLayout())
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureCollectionView()
    }

    // MARK: - CollectionView Setup
    private func configureCollectionView() {
        let headerNib = UINib(nibName: "HeaderCollectionViewCell", bundle: nil)
        collectionView.register(headerNib, forCellWithReuseIdentifier: reuseIdentifier)

        let continueNib = UINib(nibName: "ContinueCollectionViewCell", bundle: nil)
        collectionView.register(continueNib, forCellWithReuseIdentifier: reuseIdentifier1)

        collectionView.register(coursesTitlesCellCollectionViewCell.self, forCellWithReuseIdentifier: coursesTitleCellIdentifier)
        collectionView.register(SectionHeaderView.self, forCellWithReuseIdentifier: sectionHeaderViewCell)

        collectionView.backgroundColor = .white
    }

    // MARK: - CollectionView DataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionTitles.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : (section == 3 ? coursesTitles.count : 1)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HeaderCollectionViewCell
            headerCell.configureCell(user: "Aya")
            return headerCell

        case 1:
            let continueCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath) as! ContinueCollectionViewCell
            return continueCell

        case 2, 4, 6, 8, 10:
            let sectionHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: sectionHeaderViewCell, for: indexPath) as! SectionHeaderView
            let sectionTitle = sectionTitles[indexPath.section / 2] // Adjust index for headers
            sectionHeaderCell.configure(title: sectionTitle)
            return sectionHeaderCell

        case 3:
            let coursesCell = collectionView.dequeueReusableCell(withReuseIdentifier: coursesTitleCellIdentifier, for: indexPath) as! coursesTitlesCellCollectionViewCell
            let title = coursesTitles[indexPath.row]
            let itemWidth = collectionView.bounds.width * 0.27
            let itemHeight = collectionView.bounds.height * 0.05

            coursesCell.configure(title: title, useFirstImage: useFirstImage, width: itemWidth, height: itemHeight)
            useFirstImage.toggle()
            return coursesCell

        default:
            return UICollectionViewCell()
        }
    }

    // MARK: - CollectionView Layout
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return Self.createHeaderSection()
            case 1:
                return Self.createFeaturedSection()
            case 2, 4, 6, 8, 10:
                return Self.createTitleSection()
            case 3:
                return Self.createCoursesSection()
            default:
                return nil
            }
        }
    }

    static func createHeaderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    static func createFeaturedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(210))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(210))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }

    static func createTitleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }

    static func createCoursesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.27), heightDimension: .absolute(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
}



/*
private let reuseIdentifier = "HeaderCustomCell"
private let reuseIdentifier1 = "ContinueCell"
private let headerReuseIdentifier = "SectionHeaderView"
private let coursesTitleCellIdentifier = "CoursesTitleCell"
private let SectionHeaderViewCell = "SectionHeaderViewCell"



class HomeViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
        
    let sectionTitles = ["Courses Categories", "Featured Courses", "Most Popular", "Career Path", "Latest Courses"]
    let coursesTitles = ["Data Science", "Design","Bussince", "Law"]
    private var useFirstImage: Bool = true

        
    init() {
            super.init(collectionViewLayout: UICollectionViewFlowLayout())
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let nib = UINib(nibName: "HeaderCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        let continueNib = UINib(nibName: "ContinueCollectionViewCell", bundle: nil)
        collectionView.register(continueNib, forCellWithReuseIdentifier: reuseIdentifier1)
        
        // no nib file for this
        collectionView.register(coursesTitlesCellCollectionViewCell.self, forCellWithReuseIdentifier: coursesTitleCellIdentifier)
        collectionView.register(SectionHeaderView.self, forCellWithReuseIdentifier: SectionHeaderViewCell)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
          return 12
      }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
           case 3:
               return coursesTitles.count
             default:
               return 1
           }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 100)
        case 1:
            return CGSize(width: collectionView.bounds.width - 20, height: 210)
        case 2 , 4 , 6 , 8 , 10:
            return CGSize(width: collectionView.bounds.width - 20, height: 50)
        case 3:
            return CGSize(width: collectionView.bounds.width * 0.27, height: 40)
        default:
            return .zero
        }
    }
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HeaderCollectionViewCell
            headerCell.configureCell(user: "Aya")
            return headerCell
            
        case 1:
            let continueCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier1, for: indexPath) as! ContinueCollectionViewCell
            return continueCell
            
        case 2:
            let coursesTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderViewCell, for: indexPath) as! SectionHeaderView
            let coursesTitle = sectionTitles[0]
            coursesTitleCell.configure(title:coursesTitle )
            return coursesTitleCell
            
        case 3:
            let coursesTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: coursesTitleCellIdentifier, for: indexPath) as! coursesTitlesCellCollectionViewCell
            let title = coursesTitles[indexPath.row]
            let itemWidth = collectionView.bounds.width * 0.27
            let itemHeight = collectionView.bounds.height * 0.05

            coursesTitleCell.configure(title: title, useFirstImage: useFirstImage, width: itemWidth, height: itemHeight)
            useFirstImage = !useFirstImage
            return coursesTitleCell
        case 4:
            let coursesTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderViewCell, for: indexPath) as! SectionHeaderView
            let coursesTitle = sectionTitles[1]
            coursesTitleCell.configure(title:coursesTitle )
            return coursesTitleCell
            
        // case 5
            
            
            
            
            
        case 6:
            let coursesTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderViewCell, for: indexPath) as! SectionHeaderView
            let coursesTitle = sectionTitles[2]
            coursesTitleCell.configure(title:coursesTitle )
            return coursesTitleCell
            
        /// case 7
            ///
            ///
            ///
            ///
            ///
        case 8:
            let coursesTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderViewCell, for: indexPath) as! SectionHeaderView
            let coursesTitle = sectionTitles[3]
            coursesTitleCell.configure(title:coursesTitle )
            return coursesTitleCell
            
    // case 9
            
            
        
            
            
            
        case 10:
            let coursesTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderViewCell, for: indexPath) as! SectionHeaderView
            let coursesTitle = sectionTitles[4]
            print("coursesTitle\(coursesTitle)" )
            coursesTitleCell.configure(title:coursesTitle )
            return coursesTitleCell
            
      // case 11
            
            
            
            
            
        default:
                  return UICollectionViewCell()
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
            case 5 :
                print("Selected Section Header Cell at section 5")
            case 6:
                print("Selected Header Cell at section 6, item \(indexPath.item)")
            case 7:
                print("Selected Continue Cell at section 7, item \(indexPath.item)")
            case 8:
                print("Selected Section Header Cell at section 8, item \(indexPath.item)")
            case 9:
                print("Selected Course Title at section 9,")
            case 10:
                print("Selected Section Header Cell at section 10, item \(indexPath.item)")
            case 11 :
                print("Selected Section Header Cell at section 11")
            case 12 :
                print("Selected Section Header Cell at section 12")
                
            default:
                break
            }
        }
    }
*/
