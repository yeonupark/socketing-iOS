//
//  MainViewModel.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/03.
//

import Foundation
//import RxSwift
import RxCocoa

class MainViewModel {
    
    let events = BehaviorRelay<[EventData]>(value: [])
    
    func getEvents() {
        APIClient.shared.getRequest(urlString: APIEndpoint.events.url, responseType: EventsResponse.self) { [weak self] result in
            
            switch result {
            case .success(let response):
                if let eventData = response.data  {
                    self?.events.accept(eventData)
                }
            case .failure(let error):
                print("get events api error: ", error.localizedDescription)
            }
        }
    }
}
