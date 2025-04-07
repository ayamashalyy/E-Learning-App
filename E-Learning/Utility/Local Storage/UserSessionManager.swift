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
    
    private let defaults = UserDefaults.standard
    
    var token: String? {
        get { defaults.string(forKey: UserDefaultsKeys.userToken) }
        set {
            if newValue != token {
                defaults.set(newValue, forKey: UserDefaultsKeys.userToken)
                print("#debug: user-defaults - token: \(String(describing: newValue))")
            }
        }
    }
    
    var refreshToken: String? {
        get { defaults.string(forKey: UserDefaultsKeys.refreshToken) }
        set {
            if newValue != refreshToken {
                defaults.set(newValue, forKey: UserDefaultsKeys.refreshToken)
                print("#debug: user-defaults - refreshToken: \(String(describing: newValue))")
                
            }
        }
    }
    
    var name: String? {
        get { defaults.string(forKey: UserDefaultsKeys.userName) }
        set {
            if newValue != name {
                defaults.set(newValue, forKey: UserDefaultsKeys.userName)
            }
        }
    }
    
    var email: String? {
        get { defaults.string(forKey: UserDefaultsKeys.userEmail) }
        set {
            if newValue != email {
                defaults.set(newValue, forKey: UserDefaultsKeys.userEmail)
            }
        }
    }
    
    var role: String? {
        get { defaults.string(forKey: UserDefaultsKeys.userRole) }
        set {
            if newValue != role {
                defaults.set(newValue, forKey: UserDefaultsKeys.userRole)
                print("#debug: user-defaults - role: \(String(describing: newValue))")
            }
        }
    }
    
    var avatar: String? {
        get { defaults.string(forKey: UserDefaultsKeys.userAvatar) }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.userAvatar)
        }
    }
    
    func clearUserSession() {
        defaults.removeObject(forKey: UserDefaultsKeys.userToken)
        defaults.removeObject(forKey: UserDefaultsKeys.refreshToken)
        defaults.removeObject(forKey: UserDefaultsKeys.userName)
        defaults.removeObject(forKey: UserDefaultsKeys.userEmail)
        defaults.removeObject(forKey: UserDefaultsKeys.userAvatar)
        defaults.removeObject(forKey: UserDefaultsKeys.userRole)
    }
}
