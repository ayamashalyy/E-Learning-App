//
//  HomeViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 05/03/2025.
//

import Foundation

class HomeViewModel {
    private var apiService = APIService()
    private var homeData: HomeResponse?
    var onDataFetched: (() -> Void)?
    
    func fetchHomeData(token: String) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/home"
        print("Request URL: \(url)")
        
        apiService.fetchData(from: url, token: token) { [weak self] (homeResponse: HomeResponse?, error )in
            guard let self = self else { return }
            if let homeResponse = homeResponse {
                self.homeData = homeResponse
               // print("Home data fetched successfully: \(homeResponse)")
                self.onDataFetched?()
            } else if let error = error {
                print("Error fetching home data: \(error)")
            }
        }
    }
    
    func getHomeData() -> HomeResponse? {
        return homeData
    }
}
