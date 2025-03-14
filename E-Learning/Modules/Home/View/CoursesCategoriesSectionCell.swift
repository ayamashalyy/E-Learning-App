//
//  CoursesSectionCell.swift
//  E-Learning
//
//  Created by aya on 20/11/2024.
//

import UIKit

protocol CoursesCategoriesSectionCellDelegate: AnyObject {
    func didSelectCourseCategories(_ categoryId: Int)
}

class CoursesCategoriesSectionCell: UICollectionViewCell {
    static let identifier = "CoursesCategoriesSectionCell"
    var viewModel = CourseCategoriesViewModel()
    var tenantViewModel = TenantViewModel.shared
    weak var delegate: CoursesCategoriesSectionCellDelegate?
    
    private let innerCollectionView: UICollectionView = {
        let layout = RTLCollectionFlow()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 350, height: 30)
        layout.minimumInteritemSpacing = 0
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
        contentView.addSubview(innerCollectionView)
        contentView.addSubview(activityIndicator)
        innerCollectionView.dataSource = self
        innerCollectionView.delegate = self
        let nib = UINib(nibName: "CoursesCategoriesCollectionViewCell", bundle: nil)
        innerCollectionView.register(nib, forCellWithReuseIdentifier: "CoursesCell")
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        viewModel.onCategoriesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.innerCollectionView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        innerCollectionView.frame = contentView.bounds
    }
}

extension CoursesCategoriesSectionCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCategoriesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoursesCell", for: indexPath) as! CoursesCategoriesCollectionViewCell
        if let course = viewModel.getCategory(at: indexPath.item) {
            
            cell.titleCourse.text = course.name
            let color = UIColor(hex: course.color)
            cell.innerView.layer.backgroundColor = color.cgColor
            
            if let imageURL = URL(string: course.image) {
                cell.courseImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"))
            } else {
                cell.courseImage.image = UIImage(named: "placeholder")
            }
        }
        
        cell.selectedBackgroundView = .none
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForCategory(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedCourse = viewModel.getCategory(at: indexPath.item) {
            delegate?.didSelectCourseCategories(selectedCourse.id)
        }
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
}


