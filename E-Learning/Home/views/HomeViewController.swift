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

class HomeViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
        
        let sectionTitles = ["Courses Categories", "Featured Courses", "Most Popular", "Career Path"]
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
    
        
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)

    }
    
//    // Set the section to be scrollable horizontally
//      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//          if section == 2 {
//              return 16
//          }
//          return 10 // Default spacing for other sections
//      }

//    if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//        print("dddd")
//        flowLayout.scrollDirection = .horizontal
//    }
//    print("after")
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
          return 3
      }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
           case 0:
               return 1
           case 1:
               return 1
           case 2:
               return coursesTitles.count
             default:
               return 0
           }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 100)
        case 1:
            return CGSize(width: collectionView.bounds.width - 20, height: 210)
        case 2: // Custom size for section 2's cell
            return CGSize(width: collectionView.bounds.width * 0.3, height: 40)
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
            let coursesTitleCell = collectionView.dequeueReusableCell(withReuseIdentifier: coursesTitleCellIdentifier, for: indexPath) as! coursesTitlesCellCollectionViewCell
            let title = coursesTitles[indexPath.row]

            let itemWidth = collectionView.bounds.width * 0.3
            let itemHeight: CGFloat = 40
            // Configure the cell with the dynamic title and image flag
            coursesTitleCell.configure(title: title, useFirstImage: useFirstImage, width: itemWidth, height: itemHeight)
            useFirstImage = !useFirstImage

            return coursesTitleCell
        default:
                  return UICollectionViewCell()
              }
          }
  

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero // No header for the first section
        }
        return CGSize(width: collectionView.bounds.width, height: 50)
    }


    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        // Omit header for the first 2 sections (section 0 and section 1)
        if indexPath.section == 0 {
            return UICollectionReusableView() // Return empty view for section 0 and section 1
        }
        if indexPath.section == 0 {
            return UICollectionReusableView() // Return empty view for section 0 and section 1
        }
        
        // For sections after the first two (section 2 and onward), configure the header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
        
       let title = sectionTitles[indexPath.section - 2] // Adjust index for section 2 onward

        header.configure(title: title, section: indexPath.section, target: self, action: #selector(headerButtonTapped(_:)))
        
        return header
    }


    
    @objc private func headerButtonTapped(_ sender: UIButton) {
        let section = sender.tag
        print("Button tapped in section \(section)")
        // Perform section-specific actions
        // make - 2 after add remain section
        switch section - 2 {
        case 0:
            print("Navigating to all Courses Categories")
        case 1:
            print("Navigating to all Featured Courses")
        case 2:
            print("Navigating to all Most Popular")
        case 3:
            print("Navigating to all Career Path")
        default:
            break
        }
    }


}
