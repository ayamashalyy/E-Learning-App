//
//  RecentSearchesTableViewCell.swift
//  E-Learning
//
//  Created by aya on 26/11/2024.
//

import UIKit

class RecentSearchesTableViewCell: UITableViewCell {
    
    weak var delegate: recentSearchDelegate?
    
    @IBOutlet weak var recentSearchLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cencelBtn(_ sender: UIButton) {
        print("Cancel button tapped for: \(recentSearchLabel.text ?? "")")
        delegate?.delete(index: sender.tag)
        print("sender tag: \(sender.tag)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
