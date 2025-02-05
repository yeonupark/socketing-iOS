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
    let email: String
//    let profileImage: String
//    let role: String
}

typealias UserResponse = ApiResponse<UserData>
