//
//  Events.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/05.
//

import Foundation

struct EventData: Decodable {
    let id: String
    let title: String
    let eventDates: [EventDate]
    let thumbnail: String
    let place: String
    let cast: String
//    let svg: String?
    let ticketingStartTime: String
}

struct EventDate: Decodable {
    let id: String
    let date: String
}

typealias EventsResponse = ApiResponse<[EventData]>
//typealias SingleEventResponse = ApiResponse<EventData>
