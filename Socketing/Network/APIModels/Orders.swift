//
//  Orders.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/18.
//

import Foundation

struct MyOrderData: Decodable {
    let orderId: String
    let orderCreatedAt: String
    let orderCanceledAt: String?
    let eventDateId: String
    let eventDate: String
    let eventTitle: String
    let eventThumbnail: String
    let eventPlace: String
    let eventCast: String
    let reservations: [SeatOrderData]
}

struct SeatOrderData: Decodable {
    let seatAreaLabel: String
    let seatRow: Int
    let seatNumber: Int
    let seatAreaPrice: Int
}

struct CancelOrderData: Decodable {
    
}

typealias OrdersResponse = ApiResponse<[MyOrderData]>
typealias CancelOrderResponse = ApiResponse<CancelOrderData>
