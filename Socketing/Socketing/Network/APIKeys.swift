//
//  APIKeys.swift
//  Socketing
//
//  Created by Yeonu Park on 2024/12/23.
//

enum APIkeys {
    static let baseURL = "https://socketing.hjyoon.me/api/"
    static let socketURL = "https://socket.hjyoon.me/"
    static let queueURL = "https://queue.hjyoon.me/"
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
