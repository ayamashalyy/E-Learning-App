//
//  WelcomeCollectionViewCell.swift
//  E-Learning
//
//  Created by Aya Mashaly on 27/02/2025.
//

import UIKit

class WelcomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var decLabel: UILabel!
    @IBOutlet weak var HelloLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    var tenantViewModel = TenantViewModel.shared
    
    @IBAction func btn_1(_ sender: UIButton) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        HelloLabel.text = "Hello,".localized
        HelloLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        HelloLabel.textColor = tenantViewModel.secondaryColor
        userLabel.font = UIFont(name: "Roboto-Bold", size: 25)
        decLabel.text = "Start Your Learning Journey.".localized
        decLabel.font = UIFont(name: "Roboto-Medium", size: 14)
    }
    
    func configureCell(user: String) {
        userLabel.text = user
        
    }
}
