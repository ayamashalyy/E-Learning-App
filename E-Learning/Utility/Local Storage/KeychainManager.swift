//
//  KeychainManager.swift
//  E-Learning
//
//  Created by Aya Mashaly on 16/02/2025.
//

import Foundation
import Security

class KeychainManager {
    
    static let shared = KeychainManager()
    
    static func savePasswordToKeychain(password: String, key: String) {
        // service, account, class, data, password
        let data = Data(password.utf8)
        
        let deleteQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        
        SecItemDelete(deleteQuery)
        
        let addQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
        ] as CFDictionary
        
        let status = SecItemAdd(addQuery, nil)
        if status == errSecSuccess {
            // print("successfully Saved")
        } else {
            print("Failed to save data: \(status)")
        }
    }
    
    static func getPasswordFromKeychain(key: String) -> String?{
        // service, account, class, return_data, matchLimit
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,                 // return data saved
            kSecMatchLimit: kSecMatchLimitOne     //one element return
        ] as CFDictionary
        
        var data: AnyObject?
        let status = SecItemCopyMatching(query, &data)
        
        if status == errSecSuccess, let retrievedData = data as? Data {
            let password = String(data: retrievedData, encoding: .utf8)
            print("Retrieved password for key \(key): \(password ?? "nil")")
            return password
        } else {
            print("Failed to retrieve password for key \(key), status: \(status)")
            return nil
        }
    }
    
    static func deletePasswordFromKeychain(key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        if status == errSecSuccess {
            print("Password deleted successfully")
        } else {
            print("Failed to delete password: \(status)")
        }
    }
    
}
