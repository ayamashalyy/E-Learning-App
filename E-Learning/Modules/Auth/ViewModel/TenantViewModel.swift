//
//  TenantViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 25/01/2025.
//

import Foundation
import UIKit

class TenantViewModel {
    
    static let shared = TenantViewModel()
    
    private var tenant: Tenant?
    var onDataLoaded: ((Tenant) -> Void)?
    var onError: ((String) -> Void)?
    private let apiService = APIService()
    private var storedOrganizationName: String?
    var organizationName: String?
    var primaryColor: UIColor?
    var secondaryColor: UIColor?
    var urlTenant: String? {
        didSet {
            saveUrlTenantToUserDefaults()
        }
    }
    
    private init() {
        loadColorsFromUserDefaults()
        loadUrlTenantFromUserDefaults()
    }
    
    func fetchTenantData() {
        
        guard let organizationName = organizationName, !organizationName.isEmpty else {
            onError?("Organization name is not set.")
            return
        }
        
        let baseURL = APIEndpoints.baseURL
        let url = "\(baseURL)\(organizationName)"
        print("Fetching tenant data from \(url)")
        apiService.fetchData(from: url) { [weak self] (response: TenantResponse?, Error) in
            if let response = response, response.exists {
                self?.tenant = response.tenant
                self?.urlTenant = response.url
                self?.storedOrganizationName = response.tenant.siteName
                self?.primaryColor = UIColor(hex: response.tenant.primaryColor)
                self?.secondaryColor = UIColor(hex:response.tenant.secondaryColor)
                self?.onDataLoaded?(response.tenant)
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
    
    func validateOrganizationName(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard let url = URL(string: "https://lms-test-api.netlify.app/api/domains/check/\(trimmedName)") else {
            print("Invalid URL")
            return false
        }
        let pathComponent = url.lastPathComponent.lowercased()
        return trimmedName == pathComponent
    }
    
    func saveColorsToUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(tenant?.primaryColor, forKey: UserDefaultsKeys.primaryColor)
        defaults.set(tenant?.secondaryColor, forKey: UserDefaultsKeys.secondaryColor)
    }
    
    private func loadColorsFromUserDefaults() {
        let defaults = UserDefaults.standard
        if let primaryColorHex = defaults.string(forKey: UserDefaultsKeys.primaryColor) {
            primaryColor = UIColor(hex: primaryColorHex)
        }
        if let secondaryColorHex = defaults.string(forKey: UserDefaultsKeys.secondaryColor) {
            secondaryColor = UIColor(hex: secondaryColorHex)
        }
    }
    
    private func saveUrlTenantToUserDefaults() {
        if let urlTenant = self.urlTenant {
            UserDefaults.standard.set(urlTenant, forKey: UserDefaultsKeys.urlTenant)
        }
    }
    
    private func loadUrlTenantFromUserDefaults() {
        if let savedUrlTenant = UserDefaults.standard.string(forKey: UserDefaultsKeys.urlTenant) {
            self.urlTenant = savedUrlTenant
        }
    }
}
