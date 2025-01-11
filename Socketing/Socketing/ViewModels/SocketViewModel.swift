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
    
    let htmlContent = BehaviorRelay(value: "")
    
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
            self.htmlContent.accept(self.wrapSVGsInHTML(areas: response.areas))
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
    
    private func wrapSVGsInHTML(areas: [AreaData]) -> String {
        let svgElements = areas.map { area in
            "<g id='\(area.id)'>\(area.svg)</g>"
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
            }
            svg {
                width: 100%;
                height: auto;
                max-width: 100%;
                max-height: 100%;
            }
        </style>
        </head>
        <body>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1350 1350" preserveAspectRatio="xMidYMid meet">
                \(svgElements)
            </svg>
            <script>
                document.addEventListener('DOMContentLoaded', () => {
                    const svg = document.querySelector('svg');
                    
                    svg.addEventListener('click', (event) => {
                        const target = event.target.closest('g');
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
