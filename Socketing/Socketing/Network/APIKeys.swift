//
//  APIKeys.swift
//  Socketing
//
//  Created by Yeonu Park on 2024/12/23.
//

import Foundation

enum APIkeys {
    static let baseURL = ProcessInfo.processInfo.environment["BASE_URL"] ?? ""
    static let socketURL = ProcessInfo.processInfo.environment["SOCKET_URL"] ?? ""
    static let queueURL = ProcessInfo.processInfo.environment["QUEUE_URL"] ?? ""
}

enum APIEndpoint {
    case authentication
    case events
    case users
    
    var url: String {
        switch self {
        case .authentication:
            return "\(APIkeys.baseURL)auth/"
        case .events:
            return "\(APIkeys.baseURL)events/"
        case .users:
            return "\(APIkeys.baseURL)users/"
        }
    }
}
