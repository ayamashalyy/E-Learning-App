//
//  FeaturedCoursesCollectionView.swift
//  E-Learning
//
//  Created by aya on 20/11/2024.
//

import UIKit

protocol FeaturedCoursesCollectionViewDelegate: AnyObject {
    func didSelectCourse(_ course: String)
}


class FeaturedCoursesCollectionView: UICollectionViewCell {
    static let identifier = "FeaturedCoursesnCell"
    private var courses: [FeaturedCourseModel] = []
    weak var delegate: FeaturedCoursesCollectionViewDelegate?
    
    private lazy var innerFeaturedCoursesCollectionView: UICollectionView = {
        let layout = RTLCollectionFlow()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 160, height: 190)
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(innerFeaturedCoursesCollectionView)
         contentView.addSubview(activityIndicator)
        innerFeaturedCoursesCollectionView.dataSource = self
        innerFeaturedCoursesCollectionView.delegate = self
        let nib = UINib(nibName: "FeaturedCoursesCollectionViewCell", bundle: nil)
        innerFeaturedCoursesCollectionView.register(nib, forCellWithReuseIdentifier: "FeaturedCell")
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        innerFeaturedCoursesCollectionView.frame = contentView.bounds
    }
    
    func configure(with courses: [FeaturedCourseModel]) {
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
        cell.courseTitle.text = course.title
        cell.courseConstractorTitle.text = course.instructorName
        
        if let imageURL = URL(string: course.image) {
            cell.courseImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"))
        } else {
            cell.courseImage.image = UIImage(named: "placeholder")
        }
        
        cell.selectedBackgroundView = .none
        return cell
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCourse = courses[indexPath.item]
        delegate?.didSelectCourse(selectedCourse.slug)
    }
}


