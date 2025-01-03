//
//  Common.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/03.
//

import Foundation

struct ApiErrorResponse: Decodable {
    let code: Int
    let message: String
    let details: [Detail]?

    struct Detail: Codable {
        let field: String
        let message: String
    }
}

struct ApiResponse<T: Decodable>: Decodable {
    let code: Int
    let message: String
    let data: T?
}
