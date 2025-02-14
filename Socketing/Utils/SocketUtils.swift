//
//  SocketUtils.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/09.
//

import Foundation

struct JSONParser {
    
    static func decode<T: Decodable>(_ type: T.Type, from data: Any) -> T? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else {
            print("Failed to serialize JSON")
            return nil
        }
        
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedObject
        } catch {
            print("Failed to decode JSON: \(error.localizedDescription)")
            return nil
        }
    }
}

