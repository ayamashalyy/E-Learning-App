//
//  NumberRequestCell.swift
//  E-Learning
//
//  Created by aya on 04/01/2025.
//

import UIKit

protocol NumberRequestCellDelegate: AnyObject {
    func didTapApproveButton(on cell: NumberRequestCell)
    func didTapRejectButton(on cell: NumberRequestCell)
}

class NumberRequestCell: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var myLearningCategory: UILabel!
    @IBOutlet weak var myLearningNameCourse: UILabel!
    @IBOutlet weak var myLearningConstractorName: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var myLearningImage2: UIImageView!
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var rejectBtn: UIButton!
    weak var delegate: NumberRequestCellDelegate?
    var tenantViewModel = TenantViewModel.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        outerView.layer.cornerRadius = 10
        outerView.layer.masksToBounds = true
        myLearningImage2.layer.cornerRadius = 8
        myLearningImage2.layer.masksToBounds = true
        
        innerView.layer.cornerRadius = 4
        innerView.layer.masksToBounds = true
        myLearningCategory.textColor = tenantViewModel.primaryColor
        outerView.layer.shadowColor = UIColor.gray.cgColor
        outerView.layer.shadowOpacity = 0.3
        outerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        outerView.layer.shadowRadius = 6
        outerView.layer.borderColor = UIColor.lightGray.cgColor
        outerView.layer.borderWidth = 0.5
        
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        self.selectedBackgroundView = highlightView
        
        approveBtn.setTitle("Approve".localized, for: .normal)
        approveBtn.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        approveBtn.setTitleColor(UIColor.white, for: .normal)
        approveBtn.setTitleColor(UIColor.white, for: .highlighted)
        approveBtn.setTitleColor(UIColor.white, for: .selected)
        approveBtn.backgroundColor = tenantViewModel.primaryColor
        approveBtn.layer.cornerRadius = 20
        
        rejectBtn.setTitle("Reject".localized, for: .normal)
        rejectBtn.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        rejectBtn.setTitleColor(UIColor.white, for: .normal)
        rejectBtn.setTitleColor(UIColor.white, for: .highlighted)
        rejectBtn.setTitleColor(UIColor.white, for: .selected)
        rejectBtn.backgroundColor = tenantViewModel.secondaryColor
        rejectBtn.layer.cornerRadius = 20
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: outerView.layer.cornerRadius).cgPath
    }
    
    func configure(category: String, courseName: String, instructorName: String, image: String?) {
        myLearningCategory.text = category
        myLearningNameCourse.text = courseName
        myLearningConstractorName.text = instructorName
        
        if let urlString = image, let url = URL(string: urlString) {
            myLearningImage2.sd_setImage(with: url, placeholderImage: UIImage(named: "myLearning"))
        } else {
            myLearningImage2.image = UIImage(named: "myLearning") ?? UIImage()
        }
    }
    
    @IBAction func approveButtonTapped(_ sender: UIButton) {
        delegate?.didTapApproveButton(on: self)
    }
    
    @IBAction func rejectButtonTapped(_ sender: UIButton) {
        delegate?.didTapRejectButton(on: self)
    }
}
