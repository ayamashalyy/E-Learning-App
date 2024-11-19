//
//  ContinueCollectionViewCell.swift
//  E-Learning
//
//  Created by aya on 19/11/2024.
//

import UIKit

class ContinueCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var outerView: UIView!
    @IBAction func arrow(_ sender: UIButton) {
    }
    
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var titleCourse: UILabel!
    @IBOutlet weak var constratorNameCourse: UILabel!
    @IBOutlet weak var courseProgressRaico: UILabel!
    @IBOutlet weak var courseProgress: UIProgressView!
    @IBOutlet weak var innerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerView.layer.cornerRadius = 10
        outerView.layer.masksToBounds = true
        outerView.layer.borderColor = UIColor.gray.cgColor
        outerView.layer.borderWidth = 1.0
        
        
        innerView.layer.cornerRadius = 6
        innerView.layer.masksToBounds = true
        innerView.layer.borderColor = UIColor.gray.cgColor
        innerView.layer.borderWidth = 1.0
        
        
    }

}
