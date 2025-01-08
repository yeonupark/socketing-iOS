//
//  QueueViewModel.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/08.
//

import Foundation
import RxSwift
import SocketIO

class QueueViewModel {
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!

    init() {
        guard let url = URL(string: APIkeys.queueURL) else {
            return
        }
        manager = SocketManager(socketURL: url, config: [
                .log(true),
                .compress,
                .forceWebsockets(true),
            ])
        socket = manager.defaultSocket
        
        self.setupSocketEvents()
    }
    
    func connectSocket() {
        guard let authToken = UserDefaults.standard.string(forKey: "authToken") else {
            print("can't find authToken")
            return
        }
        socket.connect(withPayload: ["token": authToken])
        print("Socket connected")
    }
    
    func disconnectSocket() {
        socket.removeAllHandlers()
        socket.disconnect()
        print("Socket disconnected")
    }
    
    private func setupSocketEvents() {
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected : \(data)")
            self.emitJoinQueue()
        }
        
        socket.on(clientEvent: .error) { data, ack in
            print("Socket Error: ", data)
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
            print("Entrance token saved: \(response.token)")
        }
        
        socket.on(ServerToClientEvent.updateQueue.rawValue) { data, _ in
            guard let firstData = data.first as? [String: Any],
                  let response = JSONParser.decode(UpdatedQueueResponse.self, from: firstData)
            else {
                print("Failed to parse tokenIssued data")
                return
            }
            
            print("My position: \(response.yourPosition)")
            print("Total waiting: \(response.totalWaiting)")
        }
        
        socket.on(ServerToClientEvent.seatsInfo.rawValue) { data, _ in
            guard let firstData = data.first as? [String: Any],
                  let response = JSONParser.decode(SeatsInfoResponse.self, from: firstData)
            else {
                print("Failed to parse tokenIssued data")
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
            JoinQueueRequest.eventId.rawValue: eventId,
            JoinQueueRequest.eventDateId.rawValue: eventDateId
        ]
        
        socket.emit(eventName, data)
        print("Join queue request sent")
    }
}

