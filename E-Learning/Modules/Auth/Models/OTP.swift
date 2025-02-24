//
//  OTP.swift
//  E-Learning
//
//  Created by Aya Mashaly on 03/02/2025.
//

import Foundation

struct OTPRequest: Encodable {
    var email: String
    var otp: String
}

struct ForgetPasswordRequest: Encodable {
    let email: String
}

struct OTPResponse: Decodable {
    let message: String
}
