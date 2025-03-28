//
//  QuizViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 23/03/2025.
//

import Foundation
import Alamofire

class QuizViewModel {
    
    private var quizResponse: QuizSubmitResponse?
    var quizCourse: QuizResponse?
    private var quizReview: QuizReviewResponse?
    var onQuizSubmitted: (() -> Void)?
    private var apiService = APIService()
    
    func getQuiz(courseSlug: String, quizId: Int, token: String, completion: @escaping (QuizResponse?, String?, Error?) -> Void) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        let url = "\(subDomain)/quiz/\(courseSlug)/\(quizId)"
        print("Fetching quiz with URL: \(url), Token: \(token)")
        
        apiService.fetchData(from: url, token: token) { (response: QuizResponse?, error: Error?) in
            if let response = response {
                self.quizCourse = response
                DispatchQueue.main.async {
                    if let message = response.message, message == "You have already passed this quiz" {
                        completion(nil, "You have already passed this quiz", nil)
                    } else {
                        completion(response, nil, nil)
                    }
                }
            } else if let error = error {
                if case let AFError.responseValidationFailed(reason) = error,
                   case let .unacceptableStatusCode(code) = reason, code == 403 {
                    DispatchQueue.main.async {
                        completion(nil, "You have already passed this quiz", nil)
                    }
                } else {
                    print("Failed to fetch quiz: \(error)")
                    DispatchQueue.main.async {
                        completion(nil, nil, error)
                    }
                }
            }
        }
    }
    
    func fetchQuizReview(courseSlug: String, quizId: Int, token: String, completion: @escaping (QuizReviewResponse?, Error?) -> Void) {
            let subDomain = TenantViewModel.shared.urlTenant ?? ""
            let url = "\(subDomain)/quiz/\(courseSlug)/\(quizId)/review"
            print("Fetching quiz review with URL: \(url), Token: \(token)")
            
            apiService.fetchData(from: url, token: token) { (response: QuizReviewResponse?, error: Error?) in
                if let response = response {
                    self.quizReview = response
                    print("Quiz review fetched successfully: \(response.data.quizScore), Passed: \(response.data.isPassed)")
                    DispatchQueue.main.async {
                        completion(response, nil)
                    }
                } else if let error = error {
                    print("Error fetching quiz review: \(error)")
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
    
    func submitQuiz(courseSlug: String, quizId: Int, answers: [[String: Any]], token: String) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        let url = "\(subDomain)/quiz/\(courseSlug)/\(quizId)/submit"
        let body: [String: Any] = ["answers": answers]
        
        print("Token: \(token)")
        print("URL: \(url)")
        print("Body as JSON: \(body)")
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Body as JSON: \(jsonString)")
        } else {
            print("Failed to serialize Body: \(body)")
        }
        
        var headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        if !token.isEmpty {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: QuizSubmitResponse.self) { [weak self] response in
                guard let self = self else {
                    print("Self is nil, cannot proceed")
                    return
                }
                
                if let data = response.data, let rawResponse = String(data: data, encoding: .utf8) {
                    print("Raw Response: \(rawResponse)")
                }
                
                switch response.result {
                case .success(let decodedResponse):
                    print("Quiz submitted successfully: \(decodedResponse.message), Score: \(decodedResponse.score), Passed: \(decodedResponse.isPassed)")
                    self.quizResponse = decodedResponse
                    print("before test")
                    DispatchQueue.main.async {
                        print("Calling onQuizSubmitted")
                        self.onQuizSubmitted?()
                    }
                    print("after test")
                case .failure(let error):
                    print("Error submitting quiz: \(error)")
                    if let underlyingError = error.underlyingError {
                        print("Underlying error: \(underlyingError)")
                    }
                    if let responseCode = response.response?.statusCode {
                        print("Response status code: \(responseCode)")
                    }
                    self.quizResponse = nil
                    DispatchQueue.main.async {
                        print("Calling onQuizSubmitted with error")
                        self.onQuizSubmitted?()
                    }
                }
            }
    }
    
    func getQuizTitle() -> String? {
        return quizCourse?.data?.title
    }
    
    func getQuizQuestions() -> [QuestionCourses]? {
        return quizCourse?.data?.questions
    }
    
    func getQuizMessage() -> String? {
        return quizResponse?.message
    }
    
    func isQuizPassed() -> Bool {
        return quizResponse?.isPassed ?? false
    }
    
    func getQuizScore() -> Double? {
        return quizResponse?.score
    }
    
    func getPassPercentage() -> Int? {
        return quizResponse?.passPercentage
    }
}
