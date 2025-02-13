//
//  QueueViewModel.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/08.
//

import Foundation
import RxCocoa
import RxSwift
import SocketIO

class QueueViewModel {
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    let eventData = EventDetailViewModel.shared.event.value
    let isTurn = BehaviorRelay(value: false)
    
    let totalWaiting = BehaviorRelay(value: 0)
    let myPosition = BehaviorRelay(value: 0)
    
    let isNeverLogined = BehaviorRelay(value: false)
    let isLogouted = BehaviorRelay(value: false)

    init() {
        guard let url = URL(string: APIkeys.queueURL) else {
            return
        }
        manager = SocketManager(socketURL: url, config: [
//                .log(true),
                .compress,
                .forceWebsockets(true),
            ])
        socket = manager.defaultSocket
        
        self.setupSocketEvents()
    }
    
    func connectSocket() {
        guard let authToken = UserDefaults.standard.string(forKey: "authToken") else {
            self.isNeverLogined.accept(true)
            print("can't find authToken")
            return
        }
        guard let socket else {
            print("can't find socket")
            return
        }
        socket.connect(withPayload: ["token": authToken])
    }
    
    func disconnectSocket() {
        guard let socket else {
            print("can't find socket")
            return
        }
        socket.removeAllHandlers()
        socket.disconnect()
        print("Queue Socket disconnected")
    }
    
    private func setupSocketEvents() {
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Queue Socket connected : \(data)")
            self.emitJoinQueue()
        }
        
        socket.on(clientEvent: .error) { data, ack in
            self.isLogouted.accept(true)
            print("Queue Socket Error: ", data)
        }
        
//        socket.on(clientEvent: .disconnect) { data, _ in
//            print("Socket disconnected : \(data)")
//        }
        
        socket.on(ServerToClientEvent.tokenIssued.rawValue) { data, _ in
            guard let firstData = data.first as? [String: Any],
                  let response = JSONParser.decode(TokenResponse.self, from: firstData)
            else {
                print("Failed to parse tokenIssued data")
                return
            }
            
            UserDefaults.standard.set(response.token, forKey: "entranceToken")
            self.isTurn.accept(true)
            print("Entrance token saved and enter reservation page")
        }
        
        socket.on(ServerToClientEvent.updateQueue.rawValue) { data, _ in
            guard let firstData = data.first as? [String: Any],
                  let response = JSONParser.decode(UpdatedQueueResponse.self, from: firstData)
            else {
                print("Failed to parse updateQueue data")
                return
            }
            
            self.myPosition.accept(response.yourPosition)
            self.totalWaiting.accept(response.totalWaiting)
        }
        
        socket.on(ServerToClientEvent.seatsInfo.rawValue) { data, _ in
            guard let firstData = data.first as? [String: Any],
                  let response = JSONParser.decode(SeatsInfoResponse.self, from: firstData)
            else {
                print("Failed to parse seatsInfo data")
                return
            }
            print("Reserved seats: \(response)")
        }
        
    }
    
    private func emitJoinQueue() {
        
        let eventId = EventDetailViewModel.shared.event.value.id
        let eventDateId = EventDetailViewModel.shared.event.value.eventDates[0].id
        
        let eventName = ClientToServerEvent.joinQueue.rawValue
        
        let data: [String: String] = [
            JoinQueueParams.eventId.rawValue: eventId,
            JoinQueueParams.eventDateId.rawValue: eventDateId
        ]
        
        socket.emit(eventName, data)
        print("Join queue request sent")
    }
}

