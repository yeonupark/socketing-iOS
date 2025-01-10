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

class SocketViewModel {
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    init() {
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
        print("Socket disconnected")
    }
    
    private func setupSocketEvents() {
        
        socket.on(clientEvent: .connect) { data, ack in
            print("Socket connected : \(data)")
            self.emitJoinRoom()
        }
        
        socket.on(clientEvent: .error) { data, ack in
            print("Socket Error: ", data)
        }
        
//        socket.on(clientEvent: .disconnect) { data, _ in
//            print("Socket disconnected : \(data)")
//        }
        
        socket.on(SocketServerToClientEvent.roomJoined.rawValue) { data, _ in
            guard let firstData = data.first as? [String: Any],
                  let response = JSONParser.decode(RoomJoinedResponse.self, from: firstData)
            else {
                print("Failed to parse roomJoined data")
                return
            }
            
            print(response.message)
            print("room data: ", response.areas)
        }
        
//        socket.on(SocketServerToClientEvent.serverTime.rawValue) { data, _ in
//            guard let firstData = data.first
//            else {
//                print("Failed to get serverTime data")
//                return
//            }
//            
//            print("server time: \(firstData)")
//        }

//        socket.on(ServerToClientEvent.seatsInfo.rawValue) { data, _ in
//            guard let firstData = data.first as? [String: Any],
//                  let response = JSONParser.decode(SeatsInfoResponse.self, from: firstData)
//            else {
//                print("Failed to parse seatsInfo data")
//                return
//            }
//            print("Reserved seats: \(response)")
//        }
        
    }
    
    private func emitJoinRoom() {
        let eventName = SocketClientToServerEvent.joinRoom.rawValue
        
        let eventId = EventDetailViewModel.shared.event.value.id
        let eventDateId = EventDetailViewModel.shared.event.value.eventDates[0].id
        
        let data: [String: String] = [
            JoinRoomParams.eventId.rawValue: eventId,
            JoinRoomParams.eventDateId.rawValue: eventDateId
        ]
        
        socket.emit(eventName, data)
        print("Join room request sent")
    }

}
