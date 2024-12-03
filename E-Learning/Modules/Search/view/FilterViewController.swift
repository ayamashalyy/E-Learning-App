//
//  FilterViewController.swift
//  E-Learning
//
//  Created by aya on 27/11/2024.
//

import UIKit

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiltrationCollectionViewCell", for: indexPath) as? FiltrationCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = sections[indexPath.section].items[indexPath.row]
        cell.FiltrationCategory.text = item
        if let selectedItems = selectedFilters[sections[indexPath.section].title], selectedItems.contains(item) {
            cell.FiltrationCategory.textColor = .white
            cell.outerView.backgroundColor = UIColor(named: "myCustom")
        } else {
            cell.outerView.backgroundColor = UIColor(named: "myLearning")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = sections[indexPath.section].items[indexPath.row]
        let labelWidth = item.width(usingFont: UIFont.systemFont(ofSize: 14))
        let padding: CGFloat = 50
        return CGSize(width: labelWidth + padding, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FilterSectionHeaderViewCollectionReusableView.identifier, for: indexPath) as! FilterSectionHeaderViewCollectionReusableView
        header.titleLabel.text = sections[indexPath.section].title
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let bottomInset: CGFloat = 10
        return UIEdgeInsets(top: 5, left: 10, bottom: bottomInset, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = sections[indexPath.section].items[indexPath.row]
        let sectionTitle = sections[indexPath.section].title
        
        if selectedFilters[sectionTitle] == nil {
            selectedFilters[sectionTitle] = []
        }
        
        if selectedFilters[sectionTitle]?.contains(selectedItem) == true {
            selectedFilters[sectionTitle]?.removeAll { $0 == selectedItem }
        } else {
            selectedFilters[sectionTitle]?.append(selectedItem)
        }
        
        collectionView.reloadItems(at: [indexPath])
        
        /*
         choose item only from section
         if let previousSelection = selectedFilters[sectionTitle]?.first {
               if let previousIndex = sections[indexPath.section].items.firstIndex(of: previousSelection) {
                   selectedFilters[sectionTitle]?.removeAll()
                   let previousIndexPath = IndexPath(item: previousIndex, section: indexPath.section)
                   collectionView.reloadItems(at: [previousIndexPath])
               }
           }
           
           selectedFilters[sectionTitle] = [selectedItem]
           collectionView.reloadItems(at: [indexPath])
         */
    }
}
