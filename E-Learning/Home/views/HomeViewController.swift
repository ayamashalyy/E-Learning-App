//
//  HomeViewController.swift
//  E-Learning
//
//  Created by aya on 19/11/2024.
//

import UIKit

private let reuseIdentifier = "HeaderCustomCell"

class HomeViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
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
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
          return 1
      }

      override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return 1
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HeaderCollectionViewCell
            cell.configureCell(user: "Aya")
            return cell
        }

  

}
