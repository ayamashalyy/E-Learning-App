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
    ProfileItem(title: "Language", imageName: "language"),
    ProfileItem(title: "Account Center", imageName: "mdi_account-cog-outline"),
    ProfileItem(title: "My Certifications", imageName: "carbon_certificate"),
    ProfileItem(title: "About VINSYS", imageName: "mdi_about-circle-outline"),
    ProfileItem(title: "Terms and Conditions", imageName: "f7_book"),
    ProfileItem(title: "Privacy & Policy", imageName: "iconoir_privacy-policy"),
    ProfileItem(title: "Log out", imageName: "tabler_logout"),
]

class ProfileViewController: UIViewController {
    
    var profileLabel = UILabel()
    var tableView = UITableView(frame: .zero, style: .grouped)
    var profileImageView = UIImageView()
    var nameLabel = UILabel()
    var emailLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        
    }
    
    
    func setupViews() {
        
        profileLabel = UILabel()
        profileLabel.text = "Profile"
        profileLabel.textAlignment = .center
        profileLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileLabel)
        
        profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "profile")
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel = UILabel()
        nameLabel.text = "Moaz Mohamed"
        nameLabel.font = .boldSystemFont(ofSize: 18)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emailLabel = UILabel()
        emailLabel.text = "mohamedmoaz176@gmail.com"
        emailLabel.font = .systemFont(ofSize: 14)
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
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            profileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
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
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .white
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let TermsAndConditionsVC = storyboard.instantiateViewController(withIdentifier: "TermsAndConditions") as? TermsAndConditionsViewController else {
            fatalError("TermsAndConditionsViewController could not be instantiated. Ensure its Storyboard ID is set.")
        }
        
        guard let AboutVC = storyboard.instantiateViewController(withIdentifier: "About") as? AboutViewController else {
            fatalError("AboutViewController could not be instantiated. Ensure its Storyboard ID is set.")
        }
        
        guard let PrivacyAndPolicyVC = storyboard.instantiateViewController(withIdentifier: "PrivacyAndPolicy") as? PrivacyAndPolicyViewController else {
            fatalError("PrivacyAndPolicyViewController could not be instantiated. Ensure its Storyboard ID is set.")
        }
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                print("section 1 item 1")
                
            } else if indexPath.row == 1 {
                print("section 1 item 2")
                
            } else {
                print("section 1 item 3")
            }
        case 1:
            if indexPath.row == 0 {
                
                let navigationController = UINavigationController(rootViewController: AboutVC)
                navigationController.modalPresentationStyle = .fullScreen
                present(navigationController, animated: true, completion: nil)
                
            } else if indexPath.row == 1 {
                
                let navigationController = UINavigationController(rootViewController: TermsAndConditionsVC)
                navigationController.modalPresentationStyle = .fullScreen
                present(navigationController, animated: true, completion: nil)
                
            } else {
                
                let navigationController = UINavigationController(rootViewController: PrivacyAndPolicyVC)
                navigationController.modalPresentationStyle = .fullScreen
                present(navigationController, animated: true, completion: nil)
            }
        case 2:
            
            if indexPath.row == 0 {
                print("section 3 item 1")
            }
        default:
            break
            
        }
        
    }
}


