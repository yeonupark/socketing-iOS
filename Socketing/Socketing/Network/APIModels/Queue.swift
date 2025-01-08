//
//  Queue.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/08.
//

import Foundation

enum ClientToServerEvent: String {
    case joinQueue
}

enum ServerToClientEvent: String {
    case tokenIssued
    case updateQueue
    case seatsInfo
}

enum JoinQueueRequest: String {
    case eventId
    case eventDateId
}

struct TokenResponse: Decodable {
    let token: String
}

struct UpdatedQueueResponse: Decodable {
    let yourPosition: Int
    let totalWaiting: Int
}

struct SeatsInfoResponseData: Decodable {
    let seat_id: String
}

struct SeatsInfoResponse: Decodable {
    let seatsInfo: [SeatsInfoResponseData]
}
