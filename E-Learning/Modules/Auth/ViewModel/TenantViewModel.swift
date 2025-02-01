//
//  TenantViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 25/01/2025.
//

import Foundation
import UIKit
import SDWebImage

class TenantViewModel {
    
    static let shared = TenantViewModel()
    
    private var tenant: Tenant?
    var onDataLoaded: ((Tenant) -> Void)?
    var onLogoLoaded: ((Data?) -> Void)?
    var onError: ((String) -> Void)?
    private let apiService = APIService()
    private var storedOrganizationName: String?
    private var organizationName: String?
    var primaryColor: UIColor?
    var secondaryColor: UIColor?
    
    private init() {
        loadColorsFromUserDefaults()
    }
    
    func fetchTenantData() {
        
        guard let organizationName = organizationName, !organizationName.isEmpty else {
            onError?("Organization name is not set.")
            return
        }
        
        let baseURL = "https://lms-test-api.netlify.app/api/domains/check/"
        let url = "\(baseURL)\(organizationName)"
        print("Fetching tenant data from \(url)")
        apiService.fetchData(from: url) { [weak self] (response: TenantResponse?) in
            if let response = response, response.exists {
                self?.tenant = response.tenant
                self?.storedOrganizationName = response.tenant.siteName
                self?.primaryColor = UIColor(hex: response.tenant.primaryColor)
                self?.secondaryColor = UIColor(hex:response.tenant.secondaryColor)
                self?.onDataLoaded?(response.tenant)
                self?.loadLogoImage(from: response.tenant.siteLogo)
                self?.saveColorsToUserDefaults()
            } else {
                DispatchQueue.main.async {
                    self?.onError?("Tenant data not found or organization does not exist.")
                    self?.storedOrganizationName = nil
                }
            }
        }
    }
    
    func setOrganizationName(_ name: String) {
        self.organizationName = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
    
    private func loadLogoImage(from urlString: String) {
        guard let logoURL = URL(string: urlString) else {
            print("Invalid logo URL")
            self.onLogoLoaded?(nil)
            return
        }
        
        SDWebImageManager.shared.loadImage(
            with: logoURL,
            options: .highPriority,
            progress: nil
        ) { [weak self] image, data, error, cacheType, finished, url in
            if let error = error {
                print("Failed to load logo image: \(error.localizedDescription)")
                self?.onLogoLoaded?(nil)
                return
            }
            
            guard let data = data else {
                print("Invalid image data")
                self?.onLogoLoaded?(nil)
                return
            }
            
            DispatchQueue.main.async {
                self?.onLogoLoaded?(data)
            }
        }
    }
    
    func validateOrganizationName(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard let url = URL(string: "https://lms-test-api.netlify.app/api/domains/check/\(trimmedName)") else {
            print("Invalid URL")
            return false
        }
        let pathComponent = url.lastPathComponent.lowercased()
        return trimmedName == pathComponent
    }
    
    func getTenant() -> Tenant? {
        return tenant
    }
    
    func getPrimaryColor() -> UIColor? {
        return primaryColor
    }
    
    func getSecondaryColor() -> UIColor? {
        return secondaryColor
    }
    
    func saveColorsToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(tenant?.primaryColor, forKey: "primaryColor")
        defaults.set(tenant?.secondaryColor, forKey: "secondaryColor")
    }
    
    private func loadColorsFromUserDefaults() {
        let defaults = UserDefaults.standard
        if let primaryColorHex = defaults.string(forKey: "primaryColor") {
            primaryColor = UIColor(hex: primaryColorHex)
        }
        if let secondaryColorHex = defaults.string(forKey: "secondaryColor") {
            secondaryColor = UIColor(hex: secondaryColorHex)
        }
    }
}
