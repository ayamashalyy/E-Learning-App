//
//  CoursesSectionCell.swift
//  E-Learning
//
//  Created by aya on 20/11/2024.
//

import UIKit

class CoursesSectionCell: UICollectionViewCell {
    static let identifier = "CoursesSectionCell"
    private var courses =  ["Data Science", "Design","Bussince", "Law"]
    
    private let innerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 350, height: 30)
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(innerCollectionView)
        innerCollectionView.dataSource = self
        innerCollectionView.delegate = self
        let nib = UINib(nibName: "CoursesCollectionViewCell", bundle: nil)
        innerCollectionView.register(nib, forCellWithReuseIdentifier: "CoursesCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        innerCollectionView.frame = contentView.bounds
    }
    
    func configure(with courses: [String]) {
        self.courses = courses
        innerCollectionView.reloadData()
    }
}

extension CoursesSectionCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoursesCell", for: indexPath) as! CoursesCollectionViewCell
        let course = courses[indexPath.item]
        let color: UIColor
        if indexPath.item % 2 == 0 {
            color = UIColor(named: "yellow2") ?? UIColor.yellow
        } else {
            color = UIColor(named: "myCustom2") ?? UIColor.blue
        }
        
        cell.configure(with: course, color: color)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = courses[indexPath.item]
        let font = UIFont.systemFont(ofSize: 20)
        let textWidth = text.width(usingFont: font)
        let padding: CGFloat = 50
        return CGSize(width: textWidth + padding, height: 60)
    }
    
}

extension String {
    func width(usingFont font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = self.size(withAttributes: attributes)
        return size.width
    }
}


