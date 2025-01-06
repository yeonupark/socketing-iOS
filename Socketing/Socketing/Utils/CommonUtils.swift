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
}

