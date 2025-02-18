//
//  MyTicketsViewModel.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/18.
//

import Foundation
import RxRelay

class MyTicketsViewModel {
    
    let orderDatas = BehaviorRelay<[MyOrderData]>(value: [])
    
    func getMyOrders() {
        APIClient.shared.getRequest(urlString: APIEndpoint.orders.url, queries: ["eventId": "", "isCancelled": "false", "isBeforeNow": "false"], responseType: OrdersResponse.self) { result in
            switch result {
            case .success(let response):
                if let orders = response.data  {
                    self.orderDatas.accept(orders)
                }
            case .failure(let error):
                print("get my orders api error: ", error.localizedDescription)
            }
        }
    }
    
}
