//
//  UserSessionManager.swift
//  E-Learning
//
//  Created by Aya Mashaly on 05/02/2025.
//

import Foundation

class UserSessionManager {
    
    static let shared = UserSessionManager()
    
    private init() {}
    
    // The properties here are defined with `didSet` to ensure that whenever the value of any property is changed,
    // the data is automatically saved to UserDefaults.
    // `didSet` is a property observer that is called after the value is modified, so we use it to update UserDefaults
    // after any property is changed.
    
    // For example: When the `token` value is modified, `didSet` is called automatically, and it saves the new value to UserDefaults.
    // Similarly, the data for other properties (like `name`, `email`, `newPassword`, `confirmPassword`) will be saved in the same way.
    
    var token: String? {
        didSet {
            saveUserCredentialsToUserDefaults()
        }
    }
    
    var name: String? {
        didSet {
            saveUserCredentialsToUserDefaults()
        }
    }
    
    var email: String? {
        didSet {
            saveUserCredentialsToUserDefaults()
        }
    }
    
    var newPassword: String? {
        didSet {
            saveUserCredentialsToUserDefaults()
        }
    }
    
    var confirmPassword: String? {
        didSet {
            saveUserCredentialsToUserDefaults()
        }
    }
    
    
    func saveUserCredentialsToUserDefaults() {
        let defaults = UserDefaults.standard
        
        if let token = token {
            defaults.set(token, forKey: UserDefaultsKeys.userToken)
        }
        if let name = name {
            defaults.set(name, forKey: UserDefaultsKeys.userName)
        }
        if let email = email {
            defaults.set(email, forKey: UserDefaultsKeys.rememberEmail)
        }
        if let newPassword = newPassword {
            KeychainManager.savePasswordToKeychain(password: newPassword, key: UserDefaultsKeys.newPassword)
            defaults.set(newPassword, forKey: UserDefaultsKeys.newPassword)
        }
        if let confirmPassword = confirmPassword {
            KeychainManager.savePasswordToKeychain(password: confirmPassword, key: UserDefaultsKeys.confirmPassword)
        }
    }
    
    func loadUserCredentialsFromUserDefaults() {
        let defaults = UserDefaults.standard
        
        if let token = defaults.string(forKey: UserDefaultsKeys.userToken) {
            self.token = token
        }
        if let name = defaults.string(forKey: UserDefaultsKeys.userName) {
            self.name = name
        }
        if let email = defaults.string(forKey: UserDefaultsKeys.rememberEmail) {
            self.email = email
        }
        if let newPassword = KeychainManager.getPasswordFromKeychain(key: UserDefaultsKeys.newPassword) {
            self.newPassword = newPassword
        }
        if let confirmPassword = KeychainManager.getPasswordFromKeychain(key: UserDefaultsKeys.confirmPassword) {
            self.confirmPassword = confirmPassword
        }
    }
}
