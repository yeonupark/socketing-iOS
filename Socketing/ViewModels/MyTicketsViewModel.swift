//
//  MyTicketsViewModel.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/18.
//

import Foundation
import RxRelay
import RxSwift

enum TicketsMenu: String {
    case UpComing = "예정된 공연"
    case Past = "지난 공연"
    case Cancelled = "취소된 공연"
    
    var intValue: Int {
        switch self {
        case .UpComing:
            return 0
        case .Past:
            return 1
        case .Cancelled:
            return 2
        }
    }
}

class MyTicketsViewModel {
    
    let orderDatas = BehaviorRelay<[MyOrderData]>(value: [])
    let pastEvents = BehaviorRelay<[MyOrderData]>(value: [])
    let upcomingEvents = BehaviorRelay<[MyOrderData]>(value: [])
    let filteredOrderDatas = BehaviorRelay<[MyOrderData]>(value: [])
    
    let disposeBag = DisposeBag()
    
    func getMyOrders() {
        APIClient.shared.getRequest(urlString: APIEndpoint.orders.url, queries: ["eventId": "", "isCancelled": "false", "isBeforeNow": "false"], responseType: OrdersResponse.self) { result in
            switch result {
            case .success(let response):
                if let orders = response.data  {
                    self.orderDatas.accept(orders)
                    self.filterOrders(by: 0)
                }
            case .failure(let error):
                print("get my orders api error: ", error.localizedDescription)
            }
        }
    }

    func filterOrders(by index: Int) {
        let currentTime = Date()
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let filtered: [MyOrderData] = orderDatas.value.filter { order in
            guard let eventDate = dateFormatter.date(from: order.eventDate) else {
                return false
            }
            switch index {
            case TicketsMenu.UpComing.intValue:
                return eventDate >= currentTime && order.orderCanceledAt == nil
            case TicketsMenu.Past.intValue:
                return eventDate < currentTime && order.orderCanceledAt == nil
            case TicketsMenu.Cancelled.intValue:
                return order.orderCanceledAt != nil
            default:
                return false
            }
        }

        filteredOrderDatas.accept(filtered)
    }


}
