//
//  FeaturedCoursesCollectionView.swift
//  E-Learning
//
//  Created by aya on 20/11/2024.
//

import UIKit

class FeaturedCoursesCollectionView: UICollectionViewCell {
    static let identifier = "FeaturedCoursesnCell"
    private var courses: [String] = []
    
    private let innerFeaturedCoursesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 230, height: 240)
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(innerFeaturedCoursesCollectionView)
        innerFeaturedCoursesCollectionView.dataSource = self
        innerFeaturedCoursesCollectionView.delegate = self
        let nib = UINib(nibName: "FeaturedCoursesCollectionViewCell", bundle: nil)
        innerFeaturedCoursesCollectionView.register(nib, forCellWithReuseIdentifier: "FeaturedCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        innerFeaturedCoursesCollectionView.frame = contentView.bounds
    }
    
    func configure(with courses: [String]) {
        self.courses = courses
        innerFeaturedCoursesCollectionView.reloadData()
    }
}

extension FeaturedCoursesCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCell", for: indexPath) as! FeaturedCoursesCollectionViewCell
        let course = courses[indexPath.item]
        cell.courseTitle.text = course
        cell.configureCourseTitle()

        return cell
    }

    
}


