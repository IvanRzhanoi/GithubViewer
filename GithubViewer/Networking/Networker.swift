//
//  Networker.swift
//  GithubViewer
//
//  Created by Ivan Rzhanoi on 7.1.2024.
//

import Foundation
import Combine


// This is a rudimentary class for making network calls
final class Networker {
    
    let decoder = JSONDecoder()
    
    // Make network request with given network request parameters
    func makeRequest(request: URLRequest) -> AnyPublisher<Data, APIError> {
        var request = request // we can modify local value with ease
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Constants.token)", forHTTPHeaderField: "Authorization")
        
        
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Error httpResponse: \(response)")
                    throw APIError.unknown
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    print("HTTP response is NOT between 200 and 300: \(httpResponse.statusCode)")
                    throw APIError.unknown
                }
                
                return data
            }
            // If we get error, we need to map it for clarity
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else {
                    return APIError.apiError(reason: error.localizedDescription)
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    // It's nearly identical in call, but it allows us to decode an item
    func makeRequest<T: Decodable>(request: URLRequest) -> AnyPublisher<T, APIError> {
        makeRequest(request: request)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                // Just a boilerplate for decoding, it will tell us exactly why decoding failed
                if let error = error as? DecodingError {
                    var errorToReport = error.localizedDescription
                    switch error {
                    case .dataCorrupted(let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) - (\(details))"
                    case .keyNotFound(let key, let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
                    case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
                    @unknown default:
                        break
                    }
                    return APIError.parserError(reason: errorToReport)
                }  else {
                    return APIError.apiError(reason: error.localizedDescription)
                }
        }
        .eraseToAnyPublisher()
    }
}
