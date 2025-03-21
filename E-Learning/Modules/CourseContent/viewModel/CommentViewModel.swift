//
//  CommentViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 21/03/2025.
//

import Foundation

class CommentViewModel {
    private var apiService = APIService()
    
    var onCommentSuccess: ((String) -> Void)?
    var onCommentFailure: ((String) -> Void)?
    
    func addComment(courseSlug: String, commentText: String, token: String) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        let url = "\(subDomain)/course/\(courseSlug)/comment"
        let body = ["comment": commentText]
        
        print("Posting comment to URL: \(url), Body: \(body), Token: \(token)")
        
        apiService.postData(to: url, data: body, token: token) { [weak self] (response: CommentResponse?, error: Error?) in
            guard let self = self else { return }
            if let error = error {
                self.onCommentFailure?("Failed to add comment: \(error.localizedDescription)")
            } else if let response = response {
                self.onCommentSuccess?(response.message)
            }
        }
    }
}
