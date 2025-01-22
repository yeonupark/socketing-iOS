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
    
    private let eventId = EventDetailViewModel.shared.event.value.id
    private let eventDateId = EventDetailViewModel.shared.event.value.eventDates[0].id
    let currentAreaId = BehaviorRelay(value: "")
    
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
        
        
        socket.on(SocketServerToClientEvent.areaJoined.rawValue) { data, _ in
            guard let firstData = data.first as? [String: Any],
                  let response = JSONParser.decode(AreaJoinedResponse.self, from: firstData)
            else {
                print("Failed to parse areaJoined data")
                return
            }
            print(response.message)
            print("first seat data: \(response.seats[0])")
        }
        
        
    }
    
    private func emitJoinRoom() {
        let eventName = SocketClientToServerEvent.joinRoom.rawValue
        
        let data: [String: String] = [
            JoinRoomParams.eventId.rawValue: eventId,
            JoinRoomParams.eventDateId.rawValue: eventDateId
        ]
        
        socket.emit(eventName, data)
        print("Join room request sent")
    }
    
    func emitJoinArea() {
        let eventName = SocketClientToServerEvent.joinArea.rawValue
        
        let data: [String: String] = [
            JoinAreaParams.eventId.rawValue: eventId,
            JoinAreaParams.eventDateId.rawValue: eventDateId,
            JoinAreaParams.areaId.rawValue: currentAreaId.value
        ]
        
        socket.emit(eventName, data)
        print("Join area request sent: ", currentAreaId.value)
    }
    
    func emitExitArea() {
        let eventName = SocketClientToServerEvent.exitArea.rawValue
        
        let data: [String: String] = [
            ExitAreaParams.eventId.rawValue: eventId,
            ExitAreaParams.eventDateId.rawValue: eventDateId,
            ExitAreaParams.areaId.rawValue: currentAreaId.value
        ]
        
        socket.emit(eventName, data)
        print("Exit area request sent")
    }
    
    private func wrapSVGsInHTML(areas: [AreaData]) -> String {
        let svgElements = areas.map { area in
            
            let modifiedSvg = area.svg.replacingOccurrences(
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
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1350 1350" preserveAspectRatio="xMidYMid meet">
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
