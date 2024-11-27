//
//  RecentSearchesTableViewCell.swift
//  E-Learning
//
//  Created by aya on 26/11/2024.
//

import UIKit

class RecentSearchesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recentSearchLabel: UILabel!
    
    var onCancelTapped: (() -> Void)?
    
    @IBAction func cencelBtn(_ sender: UIButton) {
        print("Cancel button tapped for: \(recentSearchLabel.text ?? "")")
        onCancelTapped?()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
