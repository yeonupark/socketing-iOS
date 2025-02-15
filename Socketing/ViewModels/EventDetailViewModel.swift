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
    
    func searchFriend(nickname: String, completionHandler: @escaping (Bool) -> Void) {
        let url = APIEndpoint.users.url+"email/"+nickname+"@jungle.com"
        print(url)
        APIClient.shared.getRequest(urlString: url, responseType: UserResponse.self) { result in
            switch result {
            case .success(_):
                let numberOfTickets = self.numberOfFriends.value + 1
                self.numberOfFriends.accept(numberOfTickets)
                completionHandler(true)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(false)
            }
        }
    }
}
