//
//  MyTicketDetailViewModel.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/21.
//

import Foundation

class MyTicketDetailViewModel {
    
    var orderId: String?
    
    func cancelOrder(completionHandler: @escaping (Bool) -> Void) {
        
        guard let orderId else {
            return
        }
        
        let url = "\(APIEndpoint.orders.url)\(orderId)/cancel"
        APIClient.shared.postRequest(urlString: url, responseType: CancelOrderResponse.self, completion: { result in
            switch result {
            case .success(_):
                completionHandler(true)
            case .failure(_):
                completionHandler(false)
            }
        })
    }
}
