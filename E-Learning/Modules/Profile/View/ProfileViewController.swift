//
//  ProfileViewController.swift
//  E-Learning
//
//  Created by aya on 19/11/2024.
//

import UIKit

struct ProfileItem {
    let title: String
    let imageName: String
}

var items: [ProfileItem] = [
    ProfileItem(title: "Language".localized, imageName: "language"),
    ProfileItem(title: "Account Center".localized, imageName: "mdi_account-cog-outline"),
    ProfileItem(title: "My Certifications".localized, imageName: "carbon_certificate"),
    ProfileItem(title: "About VINSYS".localized, imageName: "mdi_about-circle-outline"),
    ProfileItem(title: "Terms and Conditions".localized, imageName: "f7_book"),
    ProfileItem(title: "Privacy & Policy".localized, imageName: "iconoir_privacy-policy"),
    ProfileItem(title: "Log out".localized, imageName: "tabler_logout"),
]

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var profileLabel = UILabel()
    var tableView = UITableView(frame: .zero, style: .grouped)
    var profileImageView = UIImageView()
    var nameLabel = UILabel()
    var emailLabel = UILabel()
    lazy var imagePickerController = UIImagePickerController()
    let profileUpdateViewModel = ProfileUpdateViewModel()
    var userSessionManager = UserSessionManager.shared
    var tenantViewModel = TenantViewModel.shared
    private let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        userSessionManager.loadUserCredentialsFromUserDefaults()
        if let token = userSessionManager.token {
            viewModel.fetchProfile(token: token) { [weak self] result in
                switch result {
                case .success(let profileResponse):
                    DispatchQueue.main.async {
                        self?.nameLabel.text = profileResponse.user.name
                        self?.emailLabel.text = profileResponse.user.email
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Error fetching profile: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    
    func setupViews() {
        
        profileLabel = UILabel()
        profileLabel.text = "Profile".localized
        profileLabel.textAlignment = .center
        profileLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileLabel)
        
        profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "profile")
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        profileImageView.addGestureRecognizer(tapGesture)
        
        nameLabel = UILabel()
        nameLabel.text = userSessionManager.name
        nameLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel = UILabel()
        emailLabel.text = userSessionManager.email
        emailLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        emailLabel.textColor = .gray
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(ProfileItemCell.self, forCellReuseIdentifier: "ProfileItemCell")
        view.addSubview(tableView)
        
    }
    
    @objc func selectImage() {
        
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = .fullScreen
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
            profileImageView.layer.cornerRadius = 50
            profileImageView.clipsToBounds = true
            
            // Convert the image to data and send it to update the profile
            if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
                updateProfileWithImage(imageData)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func updateProfileWithImage(_ imageData: Data) {
        guard let token = userSessionManager.token,
              let name = nameLabel.text,
              let email = emailLabel.text else { return }
        
        
        profileUpdateViewModel.updateProfile(name: name, email: email, avatar: imageData, token: token) { result in
            switch result {
            case .success():
                print("Profile updated successfully.")
            case .failure(let error):
                print("Failed to update profile: \(error.localizedDescription)")
            }
        }
    }
    
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            profileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileLabel.widthAnchor.constraint(equalToConstant: 300),
            profileLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            
            profileImageView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileItemCell", for: indexPath) as! ProfileItemCell
        
        let item: ProfileItem
        let isLanguage: Bool
        
        if indexPath.section == 0 {
            item = items[indexPath.row]
            isLanguage = (indexPath.row == 0)
        } else if indexPath.section == 1 {
            item = items[indexPath.row + 3]
            isLanguage = false
        } else {
            item = items[6]
            isLanguage = false
        }
        
        cell.configure(for: item, isLanguage: isLanguage)
        
        cell.arrowButtonAction = { [weak self] in
            guard let self = self else { return }
            
            switch item.title {
            case "Account Center".localized:
                let nextViewController = AccountCenterViewController()
                let navigationController = UINavigationController(rootViewController: nextViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
                
            case "About VINSYS".localized:
                let nextController = AboutViewController()
                let navigationController = UINavigationController(rootViewController: nextController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
                
            case "Terms and Conditions".localized:
                let nextController = TermsAndConditionsViewController()
                let navigationController = UINavigationController(rootViewController: nextController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
                
            case "Privacy & Policy".localized:
                let nextController = PrivacyAndPolicyViewController()
                let navigationController = UINavigationController(rootViewController: nextController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
                
                //                case "Log out".localized:
                
                
            default:
                break
            }
            
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}


