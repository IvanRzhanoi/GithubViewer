//
//  APIError.swift
//  GithubViewer
//
//  Created by Ivan Rzhanoi on 7.1.2024.
//

import Foundation


// Basic collection of errors
enum APIError: Error {
    case apiError(reason: String), parserError(reason: String), unauthorised, unknown
}
