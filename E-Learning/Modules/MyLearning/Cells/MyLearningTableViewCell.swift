//
//  MyLearningTableViewCell.swift
//  E-Learning
//
//  Created by aya on 23/11/2024.
//

import UIKit

protocol MyLearningTableViewCellDelegate: AnyObject {
    func didTapShareCertificate(certificateURL: String)
}

class MyLearningTableViewCell: UITableViewCell {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var myLearningCategory: UILabel!
    @IBOutlet weak var myLearningNameCourse: UILabel!
    @IBOutlet weak var myLearningConstractorName: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var myLearningBtn: UIButton!
    @IBOutlet weak var myLearningProgressLabel: UILabel!
    @IBOutlet weak var myLearningProgress: UIProgressView!
    @IBOutlet weak var myLearningImage2: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    
    var tenantViewModel = TenantViewModel.shared
    var state: LearningState = .inProgress
    weak var delegate: MyLearningTableViewCellDelegate?
    private var viewModel: MyLearningCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        
        outerView.layer.cornerRadius = 10
        outerView.layer.masksToBounds = true
        outerView.layer.shadowColor = UIColor.gray.cgColor
        outerView.layer.shadowOpacity = 0.3
        outerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        outerView.layer.shadowRadius = 6
        outerView.layer.borderColor = UIColor.lightGray.cgColor
        outerView.layer.borderWidth = 0.5
        
        innerView.layer.cornerRadius = 4
        innerView.layer.masksToBounds = true
        
        myLearningImage2.layer.cornerRadius = 8
        myLearningImage2.layer.masksToBounds = true
        myLearningImage2.translatesAutoresizingMaskIntoConstraints = false
        
        myLearningCategory.textColor = tenantViewModel.primaryColor
        myLearningProgress.progressTintColor = tenantViewModel.secondaryColor
        
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        self.selectedBackgroundView = highlightView
        
        configureButton()
    }
    
    private func configureButton() {
        myLearningBtn.layer.cornerRadius = myLearningBtn.bounds.height / 2
        myLearningBtn.layer.masksToBounds = true
        myLearningBtn.backgroundColor = tenantViewModel.primaryColor
        myLearningBtn.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 8)
        myLearningBtn.layer.borderWidth = 0
        myLearningBtn.layer.shadowOpacity = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: outerView.layer.cornerRadius).cgPath
    }
    
    func configure(with viewModel: MyLearningCellViewModel) {
        self.viewModel = viewModel
        self.state = viewModel.state
        resetCell()
        myLearningCategory.text = viewModel.courseTitleCategory
        
        if let imageURL = URL(string: viewModel.courseImage) {
            myLearningImage2.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "myLearning"))
        } else {
            myLearningImage2.image = UIImage(named: "myLearning")
        }
        
        myLearningNameCourse.text = viewModel.courseTitle
        myLearningConstractorName.text = viewModel.instructorName
        let progressValue = Float(viewModel.courseProgress) / 100.0
        myLearningProgress.setProgress(progressValue, animated: true)
        myLearningProgressLabel.text = "\(viewModel.courseProgress)%"
        myLearningImage2.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        switch viewModel.state {
        case .inProgress:
            myLearningBtn.setTitle(NSLocalizedString("Continue!", comment: ""), for: .normal)
        case .assigned:
            myLearningBtn.setTitle(NSLocalizedString("Start now!", comment: ""), for: .normal)
        case .completed:
            myLearningBtn.setTitle(NSLocalizedString("Share Certification", comment: ""), for: .normal)
            configureCompletedButton()
        }
    }
    
    private func resetCell() {
        myLearningImage2.removeConstraints(myLearningImage2.constraints)
        myLearningBtn.setImage(nil, for: .normal)
        myLearningBtn.semanticContentAttribute = .unspecified
        myLearningBtn.imageEdgeInsets = .zero
        myLearningBtn.titleEdgeInsets = .zero
        myLearningBtn.contentEdgeInsets = .zero
        
        checkImage.isHidden = state == .inProgress || state == .assigned
        myLearningProgress.isHidden = state == .assigned
        myLearningProgressLabel.isHidden = state == .assigned
        myLearningBtn.imageView?.isHidden = state == .inProgress || state == .assigned
    }
    
    private func configureCompletedButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 8, weight: .medium)
        let shareImage = UIImage(named: "uil_share")?
            .withConfiguration(imageConfig)
            .withRenderingMode(.alwaysTemplate)
        
        myLearningBtn.setImage(shareImage?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        
        let isRTL = UIView.userInterfaceLayoutDirection(for: myLearningBtn.semanticContentAttribute) == .rightToLeft
        myLearningBtn.semanticContentAttribute = isRTL ? .forceLeftToRight : .forceRightToLeft
        myLearningBtn.imageEdgeInsets = isRTL ?
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) :
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        myLearningBtn.titleEdgeInsets = isRTL ?
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10) :
        UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        myLearningBtn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        myLearningBtn.layoutIfNeeded()
    }
    
    @IBAction func shareCertificateButton(_ sender: UIButton) {
        if state == .completed, let certificateURL = viewModel?.certificate {
            delegate?.didTapShareCertificate(certificateURL: certificateURL)
        }
    }
}
