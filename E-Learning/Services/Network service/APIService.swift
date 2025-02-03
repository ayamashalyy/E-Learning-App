//
//  APIService.swift
//  E-Learning
//
//  Created by Aya Mashaly on 25/01/2025.
//

import Foundation
import Alamofire

class APIService {
    
    
    func fetchData<T: Decodable>(from url: String, completion: @escaping (T?) -> Void) {
        
        AF.request(url).responseDecodable(of: T.self) {  response in
            switch response.result {
            case .success(let decodedData):
                DispatchQueue.main.async {
                    completion(decodedData)
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func postData<T: Decodable, U: Encodable>(to url: String, data: U, completion: @escaping (T?) -> Void) {
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let decodedData):
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                case .failure(let error):
                    print("Error posting data: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
    }
}
