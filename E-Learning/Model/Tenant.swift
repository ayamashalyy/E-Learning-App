//
//  Tenant.swift
//  E-Learning
//
//  Created by Aya Mashaly on 25/01/2025.
//

import Foundation

struct TenantResponse: Codable {
    let exists: Bool
    let tenant: Tenant
    
    enum CodingKeys: String, CodingKey {
        case exists
        case tenant
    }
}

struct Tenant: Codable {
    let siteName: String
    let siteDescription: String
    let siteLogo: String
    let siteEmail: String
    let primaryColor: String
    let secondaryColor: String
    
    enum CodingKeys: String, CodingKey {
        case siteName = "site_name"
        case siteDescription = "site_description"
        case siteLogo = "site_logo"
        case siteEmail = "site_email"
        case primaryColor = "primary_color"
        case secondaryColor = "secondary_color"
    }
}


