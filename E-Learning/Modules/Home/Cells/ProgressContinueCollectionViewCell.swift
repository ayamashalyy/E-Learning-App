//
//  ProgressContinueCollectionViewCell.swift
//  E-Learning
//
//  Created by Aya Mashaly on 27/02/2025.
//

import UIKit

class ProgressContinueCollectionViewCell: UICollectionViewCell {
    
    var tenantViewModel = TenantViewModel.shared
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var arrow: UIButton!
    @IBOutlet weak var continueLabel: UILabel!
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var titleCourse: UILabel!
    @IBOutlet weak var constratorNameCourse: UILabel!
    @IBOutlet weak var courseProgressRaico: UILabel!
    @IBOutlet weak var courseProgress: UIProgressView!
    @IBOutlet weak var innerView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        outerView.layer.cornerRadius = 10
        outerView.layer.masksToBounds = true
        outerView.layer.shadowColor = UIColor.gray.cgColor
        outerView.layer.borderColor = UIColor.lightGray.cgColor
        outerView.layer.borderWidth = 0.5
        outerView.backgroundColor = tenantViewModel.primaryColor
        continueLabel.text = "Continue where you left off".localized
        continueLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        titleCourse.font = UIFont(name: "Roboto-Bold", size: 16)
        constratorNameCourse.font = UIFont(name: "Roboto-Regular", size: 12)
        courseProgressRaico.font = UIFont(name: "Roboto-Bold", size: 12)
        arrow.setImage(UIImage(named: "arrow")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        courseProgress.progressTintColor = tenantViewModel.secondaryColor
        innerView.layer.cornerRadius = 6
        innerView.layer.masksToBounds = true
        innerView.layer.shadowColor = UIColor.gray.cgColor
        innerView.layer.borderColor = UIColor.lightGray.cgColor
        innerView.layer.borderWidth = 0.5
        
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        self.selectedBackgroundView = highlightView
    }
    
    func configure(with viewModel: ProgressContinueViewModel) {
        
        if viewModel.course != nil {
            titleCourse.text = viewModel.getCourseTitle()
            constratorNameCourse.text = viewModel.getCategoryName()
            courseProgressRaico.text = viewModel.getProgressPercentageString()
            courseProgress.progress = viewModel.getProgressFloat()
            
            if let imageUrl = viewModel.getImageUrl() {
                courseImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder")) { (image, error, cacheType, url) in
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                    }
                }
            } else {
                courseImage.image = UIImage(named: "placeholder")
            }
            
            // Show the cell
            self.isHidden = false
        } else {
            // Hide the cell if there's no course
            self.isHidden = true
        }
    }
    
    @IBAction func arrow(_ sender: UIButton) {
    }
}
