//
//  CareerPathCollectionView.swift
//  E-Learning
//
//  Created by aya on 20/11/2024.
//

import UIKit

class CareerPathCollectionView: UICollectionViewCell {
    static let identifier = "CareerPathsCell"
    private var courses: [String] = []
    
    private let innerCareerPathCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 230)
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(innerCareerPathCollectionView)
        innerCareerPathCollectionView.dataSource = self
        innerCareerPathCollectionView.delegate = self
        let nib = UINib(nibName: "CareerPathsCollectionViewCell", bundle: nil)
        innerCareerPathCollectionView.register(nib, forCellWithReuseIdentifier: "CareerCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        innerCareerPathCollectionView.frame = contentView.bounds
    }
    
    func configure(with courses: [String]) {
        self.courses = courses
        innerCareerPathCollectionView.reloadData()
    }
}

extension CareerPathCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CareerCell", for: indexPath) as! CareerPathsCollectionViewCell
        let course = courses[indexPath.item]
        cell.careerPathTitle.text = course
        let color: UIColor
        if indexPath.item % 2 == 0 {
            color = UIColor(named: "myCustom") ?? UIColor.yellow
        } else {
            color = UIColor(named: "second") ?? UIColor.blue
        }
        cell.configure(color: color)

        return cell
    }
    
    
}

