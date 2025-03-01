//
//  InstructorViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 28/02/2025.
//

import Foundation

class InstructorViewModel {
    
    private var apiService = APIService()
    var instructors: [Instructor] = []
    var onDataFetched: (() -> Void)?
    
    func fetchInstructors() {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        
        let url = "\(subDomain)/instructors"
        
        apiService.fetchData(from: url) { [weak self] (response: InstructorResponse?, error) in
            guard let self = self, let response = response else { return }
            self.instructors = response.data
            self.onDataFetched?()
        }
    }
    
    func numberOfInstructors() -> Int {
        return instructors.count
    }
    
    func instructorName(at index: Int) -> String {
        return instructors[index].name
    }
    
    func instructorImage(at index: Int) -> String {
        return instructors[index].image
    }
}
