//
//  APIKeys.swift
//  Socketing
//
//  Created by Yeonu Park on 2024/12/23.
//

import Foundation

enum APIkeys {
    static let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
    static let socketURL = Bundle.main.object(forInfoDictionaryKey: "SOCKET_URL") as! String
    static let queueURL = Bundle.main.object(forInfoDictionaryKey: "QUEUE_URL") as! String
}

enum APIEndpoint {
    case authentication
    case events
    case users
    case orders
    
    var url: String {
        switch self {
        case .authentication:
            return "\(APIkeys.baseURL)auth/"
        case .events:
            return "\(APIkeys.baseURL)events/"
        case .users:
            return "\(APIkeys.baseURL)users/"
        case .orders:
            return "\(APIkeys.baseURL)orders/"
        }
    }
}
