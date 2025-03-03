//
//  FilterItemsViewController+CollectionView.swift
//  E-Learning
//
//  Created by Aya Mashaly on 01/03/2025.
//

import Foundation
import UIKit

extension FilterItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            cell.outerView.backgroundColor = tenantViewModel.primaryColor
        } else {
            cell.outerView.backgroundColor = UIColor(named: "myLearning")
            cell.FiltrationCategory.textColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = sections[indexPath.section].items[indexPath.row]
        let labelWidth = item.width(usingFont: UIFont(name: "Roboto-Medium", size: 14) ?? .boldSystemFont(ofSize: 14))
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
        let bottomInset: CGFloat = 20
        return UIEdgeInsets(top: 5, left: 10, bottom: bottomInset, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = sections[indexPath.section].items[indexPath.row]
        let sectionTitle = sections[indexPath.section].title
        print("check filter - \(selectedItem)")
        print("check filter - \(sectionTitle)")
        // Check if the item is already selected
        if let selectedItems = selectedFilters[sectionTitle], selectedItems.contains(selectedItem) {
            // Item is already selected, so remove it (unselect)
            print("check filter - \(selectedItems)")
            selectedFilters[sectionTitle]?.removeAll { $0 == selectedItem }
        } else {
            // Item is not selected, so select it
            // First, remove any previously selected item in the same section
            selectedFilters[sectionTitle]?.removeAll()
            // Then, add the new selected item
            selectedFilters[sectionTitle] = [selectedItem]
        }
        // Update the selected filters count
        selectedFiltersCount = selectedFilters.reduce(0) { $0 + $1.value.count }
        print("check filter - \(selectedFiltersCount)")
        // Reload the entire section to update the appearance of all items
        collectionView.reloadSections(IndexSet(integer: indexPath.section))
    }
}
