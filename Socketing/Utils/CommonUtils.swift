//
//  CommonUtils.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/06.
//

import UIKit

struct CommonUtils {
    static func formatDateString(_ dateString: String) -> String? {
        guard dateString.count >= 10 else {
            return nil
        }
        let dateSubstring = dateString.prefix(10)
        return dateSubstring.replacingOccurrences(of: "-", with: ".")
    }

    static func loadThumbnailImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to decode image")
                return
            }

            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
    
    static func isTokenExpired() -> Bool {
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let parts = token.split(separator: ".")
        guard parts.count == 3 else {
            print("Invalid token format")
            return true
        }

        let payload = String(parts[1])

        guard let decodedData = base64UrlDecode(payload),
              let json = try? JSONSerialization.jsonObject(with: decodedData, options: []) as? [String: Any],
              let exp = json["exp"] as? TimeInterval else {
            print("Invalid token payload")
            return true
        }

        let expirationDate = Date(timeIntervalSince1970: exp)
        return Date() > expirationDate
    }

    private static func base64UrlDecode(_ base64Url: String) -> Data? {
        var base64 = base64Url.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")

        let paddingLength = 4 - (base64.count % 4)
        if paddingLength < 4 {
            base64 += String(repeating: "=", count: paddingLength)
        }

        return Data(base64Encoded: base64)
    }
}

