//
//  Socket.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/10.
//

import Foundation

enum SocketClientToServerEvent: String {
    case joinRoom
    case joinArea
    case selectSeats
    case reserveSeats
    case requestOrder
    case exitArea
    case exitRoom
}

enum SocketServerToClientEvent: String {
    case roomJoined
    case areaJoined
    case areaExited
    case roomExited
    case seatsSelected
    case orderMade
    case orderApproved
//    case reservedSeatsStatistics
//    case serverTime
//    case error
}

enum JoinRoomParams: String {
    case eventId
    case eventDateId
}

enum JoinAreaParams: String {
    case eventId
    case eventDateId
    case areaId
}

enum SelectSeatsParams: String {
    case seatId
    case eventId
    case eventDateId
    case areaId
    case numberOfSeats
}

enum ReserveSeatsParams {
    case seatIds
    case eventId
    case eventDateId
    case areaId
    case userId
}

enum RequestOrderParams {
    case userId
    case orderId
    case eventId
    case eventDateId
    case areaId
    case paymentMethod
}

enum ExitAreaParams {
    case eventId
    case eventDateId
    case areaId
}

enum ExitRoomParams {
    case eventId
    case eventDateId
}

struct AreaData: Decodable {
    let id: String
    let label: String
    let price: Double
    let svg: String
}

struct RoomJoinedResponse: Decodable {
    let message: String
    let areas: [AreaData]
}
