//
//  UserCredentialsManager.swift
//  E-Learning
//
//  Created by Aya Mashaly on 24/02/2025.
//

import Foundation

class UserCredentialsManager {
    
    static let shared = UserCredentialsManager()
    
    private init() {}
    
    var newPassword: String? {
        get { KeychainManager.getPasswordFromKeychain(key: UserDefaultsKeys.newPassword) }
        set {
            if let newValue = newValue {
                KeychainManager.savePasswordToKeychain(password: newValue, key: UserDefaultsKeys.newPassword)
            }
        }
    }
    
    var confirmPassword: String? {
        get { KeychainManager.getPasswordFromKeychain(key: UserDefaultsKeys.confirmPassword) }
        set {
            if let newValue = newValue {
                KeychainManager.savePasswordToKeychain(password: newValue, key: UserDefaultsKeys.confirmPassword)
            }
        }
    }
    
    func clearCredentials() {
        KeychainManager.deletePasswordFromKeychain(key: UserDefaultsKeys.newPassword)
        KeychainManager.deletePasswordFromKeychain(key: UserDefaultsKeys.confirmPassword)
    }
}
