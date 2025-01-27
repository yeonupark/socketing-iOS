//
//  EventDetailViewModel.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/06.
//

import Foundation
import RxCocoa

class EventDetailViewModel {
    
    static let shared = EventDetailViewModel()
    let numberOfFriends = BehaviorRelay(value: 0)
    
    let event = BehaviorRelay<EventData>(value: EventData(id: "", title: "", eventDates: [], thumbnail: "", place: "", cast: "", ticketingStartTime: ""))
}
