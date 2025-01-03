//
//  APIModels.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/03.
//

import Foundation

class APIModels {

    struct ApiErrorResponse: Codable {
        let code: Int
        let message: String
        let details: [Detail]?

        struct Detail: Codable {
            let field: String
            let message: String
        }
    }

    // MARK: - ApiResponse
    struct ApiResponse<T: Codable>: Codable {
        let code: Int
        let message: String
        let data: T?
    }

    // MARK: - Event
    struct Event: Codable {
        let id: String
        let title: String
        let eventDates: [EventDate]
        let thumbnail: String
        let place: String
        let cast: String
        let ageLimit: Int
        let svg: String?
        let createdAt: String?
        let updatedAt: String?
        let ticketingStartTime: String
    }

    // MARK: - EventDate
    struct EventDate: Codable {
        let id: String
        let date: String
        let event: Event?
        let createdAt: String?
        let updatedAt: String?
    }

    // MARK: - Type Aliases
    typealias EventsResponse = ApiResponse<[Event]>
    typealias SingleEventResponse = ApiResponse<Event>

}
