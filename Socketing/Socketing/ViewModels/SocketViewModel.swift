//
//  SocketViewModel.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/09.
//

import Foundation
import RxCocoa
import RxSwift
import SocketIO
import UIKit

class SocketViewModel {
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    var socketId: String!
    
    let eventData = EventDetailViewModel.shared.event.value
    
    let currentAreaId = BehaviorRelay(value: "")
    private let userId = UserDefaults.standard.string(forKey: "userId")
    private let numberOfFriends = EventDetailViewModel.shared.numberOfFriends.value
    
    var areaInfo: [String: String] = [:]
    let htmlContent = BehaviorRelay(value: "")
    let seatsDataRelay = PublishRelay<[SeatData]>()
    private var seatsData = [SeatData]()
    
    let selectedSeats = BehaviorRelay<[SeatData]>(value: [])
    let orderData = BehaviorRelay<OrderData?>(value: nil)
    let reservationData = BehaviorRelay<ReservationData?>(value: nil)
    
    let bookButtonEnabled: Driver<Bool>
    let bookButtonColor: Driver<UIColor>
    
    let payButtonEnabled = BehaviorRelay(value: false)
    let payButtonColor: Driver<UIColor>
    
    private let serverTime = BehaviorRelay<Date>(value: Date())
    
    let paymentTimeLeft = BehaviorRelay(value: 0)
    let isPaymentTimeOut = BehaviorRelay(value: false)
    private var paymentTimerDisposable: Disposable?
    
    let seatTimeLeft = BehaviorRelay(value: 0)
    private var seatTimerDisposable: Disposable?
    
    private let disposeBag = DisposeBag()
    
    init() {
        
        bookButtonEnabled = selectedSeats
            .asDriver(onErrorJustReturn: [])
            .map { !$0.isEmpty }

        bookButtonColor = bookButtonEnabled
            .map { isEnabled in
                return isEnabled ? UIColor.systemPink : UIColor.lightGray
            }
            .asDriver(onErrorJustReturn: UIColor.lightGray)
        
        payButtonColor = payButtonEnabled
            .map { isEnabled in
                return isEnabled ? UIColor.systemPink : UIColor.lightGray
            }
            .asDriver(onErrorJustReturn: UIColor.lightGray)
        
        guard let url = URL(string: APIkeys.socketURL) else {
            return
        }
        manager = SocketManager(socketURL: url, config: [
            //                .log(true),
            .compress,
            .forceWebsockets(true),
        ])
        socket = manager.defaultSocket
        
        self.setupSocketEvents()
        
        bind()
    }
    
    func bind() {
        
        currentAreaId
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { areaId in
                if areaId != "" {
                    self.emitJoinArea()
                }
            })
            .disposed(by: disposeBag)
        
        orderData
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { data in
                if data != nil {
                    self.resetPaymentTimer()
                } else {
                    self.stopPaymentTimer()
                }
            })
            .disposed(by: disposeBag)
        
        selectedSeats
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { seats in
                if seats.count > 0 {
                    self.resetSeatTimer()
                } else {
                    self.stopSeatTimer()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func connectSocket() {
        guard let entranceToken = UserDefaults.standard.string(forKey: "entranceToken") else {
            print("can't find entranceToken")
            return
        }
        socket.connect(withPayload: ["token": entranceToken])
        print("Reservation Socket connected")
    }
    
    func disconnectSocket() {
        socket.removeAllHandlers()
        socket.disconnect()
        print("Reservation Socket disconnected")
    }
    
    private func setupSocketEvents() {
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected : \(data)")
            self.socketId = self.socket.sid
            self.emitJoinRoom()
        }
        
        socket.on(clientEvent: .error) { data, ack in
            print("Socket Error: ", data)
        }
        
//        socket.on(clientEvent: .disconnect) { data, _ in
//            print("Socket disconnected : \(data)")
//        }
        
        socket.on(SocketServerToClientEvent.serverTime.rawValue) { data, _ in
            let dataArray = data
            
            guard dataArray.count == 1,
                  let serverTimeString = dataArray[0] as? String else {
                print("Failed to parse serverTime data")
                return
            }
            let serverTime = self.dateFromISO8601(serverTimeString)
            self.serverTime.accept(serverTime ?? Date.now)
        }
        
        socket.on(SocketServerToClientEvent.roomJoined.rawValue) { data, _ in
            guard let firstData = data.first as? [String: Any],
                  let response = JSONParser.decode(RoomJoinedResponse.self, from: firstData)
            else {
                print("Failed to parse roomJoined data")
                return
            }
            
            print(response.message)
            for area in response.areas {
                self.areaInfo[area.id] = area.label
            }
            self.htmlContent.accept(self.wrapSVGsInHTML(areas: response.areas))
        }
        
        socket.on(SocketServerToClientEvent.areaJoined.rawValue) { data, _ in
            guard let firstData = data.first as? [String: Any],
                  let response = JSONParser.decode(AreaJoinedResponse.self, from: firstData)
            else {
                print("Failed to parse areaJoined data")
                return
            }
            print(response.message)
            self.seatsData = response.seats
            self.seatsDataRelay.accept(self.seatsData)
        }
        
        socket.on(SocketServerToClientEvent.roomExited.rawValue) { data, _ in
            guard let firstData = data.first as? [String: Any],
                  let response = JSONParser.decode(RoomExitedResponse.self, from: firstData)
            else {
                print("Failed to parse roomExited data")
                return
            }
            print(response.message)
            self.seatsData = []
            self.seatsDataRelay.accept(self.seatsData)
        }
        
        socket.on(SocketServerToClientEvent.seatsSelected.rawValue) { data, _ in
            guard let firstData = data.first as? [[String: Any]],
                  let response = JSONParser.decode([SeatsSelectedResponse].self, from: firstData)
            else {
                print("Failed to parse seatsSelected data")
                return
            }
            self.updateSeats(seats: response)
        }
        
        socket.on(SocketServerToClientEvent.orderMade.rawValue) { data, _ in
            guard let firstData = data.first as? [String: Any],
                  let response = JSONParser.decode(OrderMadeResponse.self, from: firstData)
            else {
                print("Failed to parse orderMade data")
                return
            }
            
            self.orderData.accept(response.data)
            self.updateReservedSeats(seats: response.data.seats)
        }
        
        socket.on(SocketServerToClientEvent.orderApproved.rawValue) { data, _ in
            guard let firstData = data.first as? [String: Any],
                  let response = JSONParser.decode(OrderApprovedResponse.self, from: firstData)
            else {
                print("Failed to parse orderApproved data")
                return
            }
            
            self.reservationData.accept(response.data)
        }
    }
    
    private func emitJoinRoom() {
        let eventName = SocketClientToServerEvent.joinRoom.rawValue
        
        let data: [String: String] = [
            JoinRoomParams.eventId.rawValue: eventData.id,
            JoinRoomParams.eventDateId.rawValue: eventData.eventDates[0].id
        ]
        
        socket.emit(eventName, data)
        print("Join room request sent")
    }
    
    private func emitJoinArea() {
        let eventName = SocketClientToServerEvent.joinArea.rawValue
        
        let data: [String: String] = [
            JoinAreaParams.eventId.rawValue: eventData.id,
            JoinAreaParams.eventDateId.rawValue: eventData.eventDates[0].id,
            JoinAreaParams.areaId.rawValue: currentAreaId.value
        ]
        
        socket.emit(eventName, data)
        print("Join area request sent: ", currentAreaId.value)
    }
    
    func emitExitRoom() {
        emitExitArea()
        let eventName = SocketClientToServerEvent.exitRoom.rawValue
        
        let data: [String: String] = [
            ExitRoomParams.eventId.rawValue: eventData.id,
            ExitRoomParams.eventDateId.rawValue: eventData.eventDates[0].id
        ]
        
        socket.emit(eventName, data)
        print("Exit room request sent")
    }
    
    func emitExitArea() {
        self.selectedSeats.accept([])
        let eventName = SocketClientToServerEvent.exitArea.rawValue
        
        let data: [String: String] = [
            ExitAreaParams.eventId.rawValue: eventData.id,
            ExitAreaParams.eventDateId.rawValue: eventData.eventDates[0].id,
            ExitAreaParams.areaId.rawValue: currentAreaId.value
        ]
        
        socket.emit(eventName, data)
        print("Exit area request sent")
    }
    
    func emitSelectSeats(seatId: String) {
        let eventName = SocketClientToServerEvent.selectSeats.rawValue
        
        let data: [String: Any] = [
            SelectSeatsParams.eventId.rawValue: eventData.id,
            SelectSeatsParams.eventDateId.rawValue: eventData.eventDates[0].id,
            SelectSeatsParams.areaId.rawValue: currentAreaId.value,
            SelectSeatsParams.seatId.rawValue: seatId,
            SelectSeatsParams.numberOfSeats.rawValue: numberOfFriends+1
        ]
        socket.emit(eventName, data)
        print("Select seats request sent")

    }
    
    func emitReserveSeats() {
        let seatIds = selectedSeats.value.map { $0.id }
        let eventName = SocketClientToServerEvent.reserveSeats.rawValue
        
        let data: [String: Any] = [
            ReserveSeatsParams.eventId.rawValue: eventData.id,
            ReserveSeatsParams.eventDateId.rawValue: eventData.eventDates[0].id,
            ReserveSeatsParams.areaId.rawValue: currentAreaId.value,
            ReserveSeatsParams.seatIds.rawValue: seatIds,
            ReserveSeatsParams.userId.rawValue: userId
        ]
        socket.emit(eventName, data)
        print("Reserve seats request sent")
    }
    
    func emitRequestOrder() {
        let eventName = SocketClientToServerEvent.requestOrder.rawValue
        
        guard let orderId = orderData.value?.id else {
            return
        }
        
        let data: [String: Any] = [
            RequestOrderParams.eventId.rawValue: eventData.id,
            RequestOrderParams.eventDateId.rawValue: eventData.eventDates[0].id,
            RequestOrderParams.areaId.rawValue: currentAreaId.value,
            ReserveSeatsParams.userId.rawValue: userId,
            RequestOrderParams.orderId.rawValue: orderId,
            RequestOrderParams.paymentMethod.rawValue: PaymentMethods.socketPay.rawValue
        ]
        socket.emit(eventName, data)
        print("Request order request sent")
    }
    
    private func updateSeats(seats: [SeatsSelectedResponse]) {
        let seatIds = Set(seats.map { $0.seatId })
        let currentSeatsIds = Set(selectedSeats.value.map { $0.id })
        let selectedBy = seats.first?.selectedBy
        let reservedUserId = seats.first?.reservedUserId
        let expirationTime = seats.first?.expirationTime
        
        if seatIds == currentSeatsIds {
            self.selectedSeats.accept([])
        }
        
        var mySeats: [SeatData] = []
        for (index, seat) in seatsData.enumerated() {
            if seatIds.contains(seat.id) {
                seatsData[index].selectedBy = selectedBy
                seatsData[index].reservedUserId = reservedUserId
                seatsData[index].expirationTime = expirationTime
                if selectedBy == self.socketId {
                    mySeats.append(seatsData[index])
                }
            }
        }
        seatsDataRelay.accept(seatsData)
        
        if selectedBy == self.socketId {
            self.selectedSeats.accept(mySeats)
        }
    }
    
    private func updateReservedSeats(seats: [SeatData]) {
        let seatIds = seats.map { $0.id }
        for (index, seat) in seatsData.enumerated() {
            if seatIds.contains(seat.id) {
                seatsData[index].reservedUserId = seats.first?.reservedUserId
            }
        }
        seatsDataRelay.accept(seatsData)
    }
    
    private func stopPaymentTimer() {
        paymentTimerDisposable?.dispose()
        paymentTimerDisposable = nil
    }
    
    private func stopSeatTimer() {
        seatTimerDisposable?.dispose()
        seatTimerDisposable = nil
    }
    
    private func resetPaymentTimer() {
        stopPaymentTimer()
        
        let expirationTime = dateFromISO8601(orderData.value?.expirationTime ?? "") ?? Date()
        let currentTime = serverTime.value
        let initialTimeLeft = max(0, Int(expirationTime.timeIntervalSince(currentTime)))
        
        paymentTimeLeft.accept(initialTimeLeft)
        
        if initialTimeLeft == 0 {
            return
        }
        
        paymentTimerDisposable = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let updatedTimeLeft = max(0, self.paymentTimeLeft.value - 1)
                self.paymentTimeLeft.accept(updatedTimeLeft)
                
                if updatedTimeLeft == 0 {
                    isPaymentTimeOut.accept(true)
                }
            })
    }
    
    private func resetSeatTimer() {
        stopSeatTimer()
        
        let expirationTime = dateFromISO8601(selectedSeats.value.first?.expirationTime ?? "") ?? Date()
        let currentTime = serverTime.value
        let initialTimeLeft = max(0, Int(expirationTime.timeIntervalSince(currentTime)))
        
        seatTimeLeft.accept(initialTimeLeft)
        
        if initialTimeLeft == 0 {
            return
        }
        
        seatTimerDisposable = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let updatedTimeLeft = max(0, self.seatTimeLeft.value - 1)
                self.seatTimeLeft.accept(updatedTimeLeft)
            })
    }
    
    private func dateFromISO8601(_ string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: string)
    }
    
    private func wrapSVGsInHTML(areas: [AreaData]) -> String {
        
        let svgElements = areas.map { area in
            guard let svg = area.svg else {
                return ""
            }
            let modifiedSvg = svg.replacingOccurrences(
                of: #"<g\s+id=["'].*?["']"#,
                with: "<g",
                options: .regularExpression
            )

            return """
            <g id='\(area.id)' class='clickable-area'>
                \(modifiedSvg)
            </g>
            """
        }.joined(separator: "\n")

        return """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
        <style>
            body {
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                width: 100vw;
                height: 100vh;
                background-color: #f0f0f0;
                overflow: auto;
            }
            svg {
                width: 100%;
                height: auto;
                max-width: 100%;
                max-height: 100%;
                transition: all 0.3s ease-in-out;
            }
        </style>
        </head>
        <body>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 1000" preserveAspectRatio="xMidYMid meet">
                \(svgElements)
            </svg>
            <script>
                document.addEventListener('DOMContentLoaded', () => {
                    const svg = document.querySelector('svg');
        
                    svg.addEventListener('click', (event) => {
                        let target = event.target;

                        // 클릭 가능한 영역의 가장 바깥쪽 g 태그를 찾음
                        while (target && !target.classList.contains('clickable-area')) {
                            target = target.parentElement;
                        }

                        if (target) {
                            window.webkit.messageHandlers.svgHandler.postMessage(target.id);
                        }
                    });
                });
            </script>
        </body>
        </html>
        """
    }
}
