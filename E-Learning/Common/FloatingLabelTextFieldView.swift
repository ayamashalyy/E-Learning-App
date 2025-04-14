//
//  FloatingLabelTextFieldView.swift
//  E-Learning
//
//  Created by Aya Mashaly on 13/04/2025.
//

import UIKit

class FloatingLabelTextFieldView: UIView, UITextFieldDelegate {
    
    var onTextFieldShouldReturn: (() -> Bool)?
    private let customLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.textColor = UIColor(named: "third")
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textInsets = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        return label
    }()
    
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(named: "third")?.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var labelCenterYConstraint: NSLayoutConstraint!
    private var labelLeadingConstraint: NSLayoutConstraint!
    private var placeholderText: String = ""
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        self.addSubview(borderView)
        self.addSubview(textField)
        self.addSubview(customLabel)
        textField.tintColor = UIColor(named: "third")
        textField.delegate = self
        textField.isUserInteractionEnabled = true
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: self.topAnchor),
            borderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: borderView.centerYAnchor),
            textField.widthAnchor.constraint(equalTo: borderView.widthAnchor, constant: -30),
            textField.heightAnchor.constraint(equalTo: borderView.heightAnchor, constant: -30)
        ])
        
        
        labelCenterYConstraint = customLabel.centerYAnchor.constraint(equalTo: borderView.centerYAnchor)
        labelLeadingConstraint = customLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            labelCenterYConstraint,
            labelLeadingConstraint
        ])
    }
    
    // MARK: - Floating Animations
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textField should return: \(customLabel.text ?? "Unknown")")
        return onTextFieldShouldReturn?() ?? true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("User started editing textField with placeholder: \(customLabel.text ?? "Unknown")")
        animateLabelToFloatingState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            animateLabelToInitialState()
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        animateLabelToFloatingState()
    }
    
    private func animateLabelToFloatingState() {
        UIView.animate(withDuration: 0.3) {
            self.labelCenterYConstraint.constant = -25
            self.labelLeadingConstraint.constant = 12
            self.customLabel.font = UIFont(name: "Roboto-Regular", size: 14)
            self.customLabel.textColor = .black
            self.textField.textColor = UIColor(named: "third")
            self.borderView.layer.borderColor = UIColor(named: "third")?.cgColor
            self.customLabel.backgroundColor = .white
            self.customLabel.textAlignment = .center
            self.customLabel.layer.cornerRadius = 8
            self.customLabel.clipsToBounds = true
            self.customLabel.layer.zPosition = 1
            self.textField.placeholder = ""
            self.viewLayoutIfNeeded()
        }
    }
    
    private func animateLabelToInitialState() {
        UIView.animate(withDuration: 0.3) {
            self.labelCenterYConstraint.constant = 0
            self.labelLeadingConstraint.constant = 10
            self.customLabel.font = UIFont(name: "Roboto-Regular", size: 14)
            self.customLabel.textColor = UIColor(named: "third")
            self.customLabel.backgroundColor = .clear
            self.customLabel.textAlignment = .left
            self.textField.placeholder = self.placeholderText
            self.borderView.layer.borderColor = UIColor(named: "third")?.cgColor
            self.viewLayoutIfNeeded()
        }
    }
    
    private func viewLayoutIfNeeded() {
        self.layoutIfNeeded()
    }
    
    // MARK: - Public API
    
    func setLabelText(_ text: String) {
        customLabel.text = text
    }
    
    func getText() -> String? {
        return textField.text
    }
}


class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
