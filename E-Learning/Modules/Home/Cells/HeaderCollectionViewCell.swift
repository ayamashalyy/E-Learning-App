//
//  HeaderCollectionViewCell.swift
//  E-Learning
//
//  Created by aya on 19/11/2024.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var decLabel: UILabel!
    @IBOutlet weak var HelloLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBAction func btn_1(_ sender: UIButton) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        HelloLabel.text = "Hello,".localized
        decLabel.text = "Start Your Learning Journey.".localized
    }
    
    func configureCell(user: String) {
        userLabel.text = user
        
    }
}
