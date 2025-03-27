//
//  QuestionVC+UICollectionViewDragAndDropDelegate.swift
//  E-Learning
//
//  Created by Aya Mashaly on 22/03/2025.
//

import Foundation
import UIKit

extension QuestionVC: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    // This method starts the dragging process. It identifies the item the user wants to drag from the rightCollectionView,
    // prepares it to be moved, marks it as selected to change how it looks, and updates the UI to show this change.
    // It ensures dragging only happens in rightCollectionView and returns the item to be dragged.
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard collectionView == rightCollectionView,
              indexPath.row < selectedAnswers.count else { return [] }
        
        let item = selectedAnswers[indexPath.row]
        let itemProvider = NSItemProvider(object: NSString(string: item))
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        selectedRightIndex = indexPath
        return [dragItem]
    }
    
    // This method decides if dropping is allowed while the user is dragging an item. It checks if the drop is happening
    // in the rightCollectionView and if the drag started from this same collection. If yes, it allows the item to be moved
    // to a new position. If not, it blocks the drop completely, ensuring dragging and dropping only works within rightCollectionView.
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard collectionView == rightCollectionView else { return UICollectionViewDropProposal(operation: .forbidden) }
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    // This method handles what happens when the user drops the dragged item. It takes the item from its old position,
    // moves it to the new position in the rightCollectionView, updates the underlying data (rightOptions array), and refreshes
    // the UI to reflect this change. After the move is done, it clears the selection and reloads the collection to show the final result.
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard collectionView == rightCollectionView,
              let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        let items = coordinator.items
        for item in items {
            guard let sourceIndexPath = item.sourceIndexPath,
                  let itemString = item.dragItem.localObject as? String,
                  sourceIndexPath.row < selectedAnswers.count,
                  destinationIndexPath.row <= selectedAnswers.count else { continue }
            
            // Update selectedAnswers with the new order
            selectedAnswers.remove(at: sourceIndexPath.row)
            selectedAnswers.insert(itemString, at: destinationIndexPath.row)
            
            // Perform the UI update
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: { _ in
                self.selectedRightIndex = nil
            })
        }
    }
}
