//
//  TotalResultsTableViewCell.swift
//  E-Learning
//
//  Created by aya on 26/11/2024.
//

import UIKit




class TotalResultsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var totalResultSearchImageView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var totalResultSearchCategory: UILabel!
    @IBOutlet weak var totalResultSearchNameCourse: UILabel!
    @IBOutlet weak var totalResultSearchConstractorName: UILabel!
    @IBOutlet weak var totalResultSearchImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerView.layer.cornerRadius = 10
        outerView.layer.masksToBounds = true
        
        totalResultSearchImageView.layer.cornerRadius = 8
        totalResultSearchImageView.layer.masksToBounds = true
        
        
        outerView.layer.shadowColor = UIColor.gray.cgColor
        outerView.layer.shadowOpacity = 0.3
        outerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        outerView.layer.shadowRadius = 6
        outerView.layer.borderColor = UIColor.lightGray.cgColor
        outerView.layer.borderWidth = 0.5
        
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        self.selectedBackgroundView = highlightView
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: outerView.layer.cornerRadius).cgPath
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
