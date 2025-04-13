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
    let logoutViewModel = LogoutViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProfileData()
    }
    
    func fetchProfileData() {
        if let token = userSessionManager.token {
            viewModel.fetchProfile(token: token) { [weak self] result in
                switch result {
                case .success(let profileResponse):
                    DispatchQueue.main.async {
                        
                        self?.nameLabel.text = profileResponse.user.name
                        self?.emailLabel.text = profileResponse.user.email
                        
                        if let avatarURLString = profileResponse.user.avatar, let avatarURL = URL(string: avatarURLString) {
                            self?.loadImage(from: avatarURL)
                            print("Loaded avatar from API URL: \(avatarURLString)")
                        } else if let base64String = UserSessionManager.shared.avatar, let imageData = Data(base64Encoded: base64String) {
                            self?.profileImageView.image = UIImage(data: imageData)
                            print("Loaded avatar from UserDefaults")
                        } else {
                            self?.profileImageView.image = UIImage(named: "User-100")
                            print("No avatar found, using default")
                        }
                        
                        print("Avatar URL from API: \(profileResponse.user.avatar ?? "nil")")
                        print("Avatar from UserDefaults: \(UserSessionManager.shared.avatar?.prefix(50) ?? "nil")")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("Error fetching profile: \(error.localizedDescription)")
                        if let base64String = UserSessionManager.shared.avatar, let imageData = Data(base64Encoded: base64String) {
                            self?.profileImageView.image = UIImage(data: imageData)
                            print("Loaded avatar from UserDefaults after error")
                        } else {
                            self?.profileImageView.image = UIImage(named: "User-100")
                            print("No avatar found, using default after error")
                        }
                    }
                }
            }
        } else {
            print("No token available, cannot fetch profile")
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
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        profileImageView.addGestureRecognizer(tapGesture)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel = UILabel()
        emailLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        emailLabel.textColor = .gray
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
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
            if let imageData = selectedImage.jpegData(compressionQuality: 0.5) {
                updateProfileWithImage(imageData)
            }
            else {
                print("No image selected or image is not of expected type.")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func loadImage(from url: URL) {
        profileImageView.sd_setImage(with: url, placeholderImage: self.profileImageView.image) { [weak self] (image, error, cacheType, url) in
            guard let self = self else { return }
            if let image = image {
                self.profileImageView.image = image
                print("Image loaded successfully from URL")
            } else if let error = error {
                print("Error loading image from URL: \(error.localizedDescription)")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func updateProfileWithImage(_ imageData: Data) {
        guard let token = userSessionManager.token,
              let password = UserCredentialsManager.shared.newPassword,
              let password_confirmation = UserCredentialsManager.shared.confirmPassword,
              let name = nameLabel.text,
              let email = emailLabel.text, !name.isEmpty, !email.isEmpty else {
            print("Missing required data: Name or email is empty.")
            return
        }
        
        print("name: \(name), email: \(email), token: \(token), password: \(password), password_confirmation: \(password_confirmation) ")
        profileUpdateViewModel.updateProfile(name: name, email: email, avatar: imageData, password: password, password_confirmation: password_confirmation, token: token) { result in
            switch result {
            case .success(let data):
                let base64String = imageData.base64EncodedString()
                
                self.userSessionManager.avatar = base64String
                
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(data: imageData)
                    self.fetchProfileData()
                }
                
                print("Profile updated successfully and avatar saved locally.")
                
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Profile updated successfully with response: \(responseString)")
                } else {
                    print("Profile updated successfully, but no response data.")
                }
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
                break
            case "Terms and Conditions".localized:
                break
            case "Privacy & Policy".localized:
                break
            case "Log out".localized:
                logoutUser()
            default:
                break
            }
            
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func logoutUser() {
        guard let token = userSessionManager.token else { return }
        
        logoutViewModel.postLogout(token: token) { [weak self] result in
            switch result {
            case .success(let message):
                print(message)
                UserSessionManager.shared.clearUserSession()
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.primaryColor)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.secondaryColor)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.urlTenant)
                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.selectedTenant)
                UserCredentialsManager.shared.clearCredentials()
                UserSessionManager.shared.clearUserSession()
                self?.navigateToLoginScreen()
                
            case .failure(let error):
                print("Logout failed: \(error.localizedDescription)")
            }
        }
    }
    
    func navigateToLoginScreen() {
        let selectOrganizationViewController = SelectOrganizationViewController()
        let navigationController = UINavigationController(rootViewController: selectOrganizationViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
}


