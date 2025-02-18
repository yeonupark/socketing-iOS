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
    var logined = false
    
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
    
    func isTokenExpired() -> Bool {
            let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
            let parts = token.split(separator: ".")
            guard parts.count == 3 else {
                print("Invalid token format")
                return true
            }

            let payload = String(parts[1])

            guard let decodedData = base64UrlDecode(payload),
                  let json = try? JSONSerialization.jsonObject(with: decodedData, options: []) as? [String: Any],
                  let exp = json["exp"] as? TimeInterval else {
                print("Invalid token payload")
                return true
            }

            let expirationDate = Date(timeIntervalSince1970: exp)
            return Date() > expirationDate
        }

        private func base64UrlDecode(_ base64Url: String) -> Data? {
            var base64 = base64Url.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")

            let paddingLength = 4 - (base64.count % 4)
            if paddingLength < 4 {
                base64 += String(repeating: "=", count: paddingLength)
            }

            return Data(base64Encoded: base64)
        }
}
