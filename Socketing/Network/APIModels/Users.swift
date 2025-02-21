//
//  Users.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/05.
//

import Foundation

struct UserData: Decodable {
    let id: String
    let nickname: String
    let email: String?
}

struct NicknameUpdateRequest: Encodable {
    let nickname: String
}

typealias UserResponse = ApiResponse<UserData>
