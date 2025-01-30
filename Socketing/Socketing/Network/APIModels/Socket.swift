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

enum ReserveSeatsParams: String {
    case seatIds
    case eventId
    case eventDateId
    case areaId
    case userId
}

enum RequestOrderParams: String {
    case userId
    case orderId
    case eventId
    case eventDateId
    case areaId
    case paymentMethod
}

enum ExitAreaParams: String {
    case eventId
    case eventDateId
    case areaId
}

enum ExitRoomParams: String {
    case eventId
    case eventDateId
}

struct AreaData: Decodable {
    let id: String
    let label: String
    let price: Int
    let svg: String?
}

struct RoomJoinedResponse: Decodable {
    let message: String
    let areas: [AreaData]
}

struct SeatData: Decodable {
    let id: String
    let cx: CGFloat
    let cy: CGFloat
    let row: Int
    let number: Int
    var selectedBy: String?
    var reservedUserId: String?
    let expirationTime: String?
//    let areaId: String
}

struct AreaJoinedResponse: Decodable {
    let message: String
    let seats: [SeatData]
}

struct SeatsSelectedResponse: Decodable {
    let seatId: String
    let selectedBy: String?
    let updatedAt: String
    let expirationTime: String?
    let reservedUserId: String?
}

struct OrderData: Decodable {
    let id: String
    let createdAt: String
    let expirationTime: String
    let seats: [SeatData]
    let area: AreaData
}

struct OrderMadeResponse: Decodable {
    let data: OrderData
}
