//
//  Authentication.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/04.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginData: Decodable {
    let tokenType: String
    let expiresIn: Int
    let accessToken: String
}

typealias LoginResponse = ApiResponse<LoginData>
