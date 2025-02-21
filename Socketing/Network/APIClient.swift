//
//  APIClient.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/04.
//

import Foundation

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url
    }
}

class APIClient {
    
    static let shared = APIClient()
    
    private init() {}
    
    func getRequest<T: Decodable>(
        urlString: String,
        queries: [String: String]? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        guard var url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        if let queries = queries {
            url = url.withQueries(queries) ?? url
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } 
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let responseError = NSError(domain: "Invalid HTTP response", code: 0, userInfo: nil)
                completion(.failure(responseError))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                
                if let data = data {
                    do {
                        let apiError = try JSONDecoder().decode(ApiErrorResponse.self, from: data)
                        let errorInfo = NSError(
                            domain: "Server Error",
                            code: apiError.code,
                            userInfo: [NSLocalizedDescriptionKey: apiError.message]
                        )
                        completion(.failure(errorInfo))
                    } catch {
                        let genericError = NSError(
                            domain: "Server Error",
                            code: httpResponse.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: "Failed to parse error response"]
                        )
                        completion(.failure(genericError))
                    }
                } else {
                    let noDataError = NSError(
                        domain: "Server Error",
                        code: httpResponse.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "No error data received"]
                    )
                    completion(.failure(noDataError))
                }
                return
            }
            
            guard let data = data else {
                let dataError = NSError(domain: "No data received", code: 0, userInfo: nil)
                completion(.failure(dataError))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodedResponse))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }
        task.resume()
    }
    
    func postRequest<T: Decodable, U: Encodable>(
        urlString: String,
        requestBody: U,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
        } catch let encodingError {
            completion(.failure(encodingError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let responseError = NSError(domain: "Invalid HTTP response", code: 0, userInfo: nil)
                completion(.failure(responseError))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                
                if let data = data {
                    do {
                        let apiError = try JSONDecoder().decode(ApiErrorResponse.self, from: data)
                        let errorInfo = NSError(
                            domain: "Server Error",
                            code: apiError.code,
                            userInfo: [NSLocalizedDescriptionKey: apiError.message]
                        )
                        completion(.failure(errorInfo))
                    } catch {
                        let genericError = NSError(
                            domain: "Server Error",
                            code: httpResponse.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: "Failed to parse error response"]
                        )
                        completion(.failure(genericError))
                    }
                } else {
                    let noDataError = NSError(
                        domain: "Server Error",
                        code: httpResponse.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "No error data received"]
                    )
                    completion(.failure(noDataError))
                }
                return
            }
            
            guard let data = data else {
                let dataError = NSError(domain: "No data received", code: 0, userInfo: nil)
                completion(.failure(dataError))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodedResponse))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }
        task.resume()
    }
    
    func postRequest<T: Decodable>(
        urlString: String,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let responseError = NSError(domain: "Invalid HTTP response", code: 0, userInfo: nil)
                completion(.failure(responseError))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                if let data = data {
                    do {
                        let apiError = try JSONDecoder().decode(ApiErrorResponse.self, from: data)
                        let errorInfo = NSError(
                            domain: "Server Error",
                            code: apiError.code,
                            userInfo: [NSLocalizedDescriptionKey: apiError.message]
                        )
                        completion(.failure(errorInfo))
                    } catch {
                        let genericError = NSError(
                            domain: "Server Error",
                            code: httpResponse.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: "Failed to parse error response"]
                        )
                        completion(.failure(genericError))
                    }
                } else {
                    let noDataError = NSError(
                        domain: "Server Error",
                        code: httpResponse.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "No error data received"]
                    )
                    completion(.failure(noDataError))
                }
                return
            }
            
            guard let data = data else {
                let dataError = NSError(domain: "No data received", code: 0, userInfo: nil)
                completion(.failure(dataError))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodedResponse))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }
        task.resume()
    }

    func deleteRequest(
            urlString: String,
            completion: @escaping (Result<Void, Error>) -> Void
        ) {
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    let responseError = NSError(domain: "Invalid HTTP response", code: 0, userInfo: nil)
                    completion(.failure(responseError))
                    return
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    if let data = data {
                        do {
                            let apiError = try JSONDecoder().decode(ApiErrorResponse.self, from: data)
                            let errorInfo = NSError(
                                domain: "Server Error",
                                code: apiError.code,
                                userInfo: [NSLocalizedDescriptionKey: apiError.message]
                            )
                            completion(.failure(errorInfo))
                        } catch {
                            let genericError = NSError(
                                domain: "Server Error",
                                code: httpResponse.statusCode,
                                userInfo: [NSLocalizedDescriptionKey: "Failed to parse error response"]
                            )
                            completion(.failure(genericError))
                        }
                    } else {
                        let noDataError = NSError(
                            domain: "Server Error",
                            code: httpResponse.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: "No error data received"]
                        )
                        completion(.failure(noDataError))
                    }
                    return
                }
                
                completion(.success(()))
            }
            task.resume()
        }
    
    func patchRequest<T: Decodable, U: Encodable>(
        urlString: String,
        requestBody: U,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
        } catch let encodingError {
            completion(.failure(encodingError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let responseError = NSError(domain: "Invalid HTTP response", code: 0, userInfo: nil)
                completion(.failure(responseError))
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode) {
                if let data = data {
                    do {
                        let apiError = try JSONDecoder().decode(ApiErrorResponse.self, from: data)
                        let errorInfo = NSError(
                            domain: "Server Error",
                            code: apiError.code,
                            userInfo: [NSLocalizedDescriptionKey: apiError.message]
                        )
                        completion(.failure(errorInfo))
                    } catch {
                        let genericError = NSError(
                            domain: "Server Error",
                            code: httpResponse.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: "Failed to parse error response"]
                        )
                        completion(.failure(genericError))
                    }
                } else {
                    let noDataError = NSError(
                        domain: "Server Error",
                        code: httpResponse.statusCode,
                        userInfo: [NSLocalizedDescriptionKey: "No error data received"]
                    )
                    completion(.failure(noDataError))
                }
                
                return
            }
            
            guard let data = data else {
                let dataError = NSError(domain: "No data received", code: 0, userInfo: nil)
                completion(.failure(dataError))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodedResponse))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }
        task.resume()
    }

}
