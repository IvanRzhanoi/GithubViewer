//
//  User.swift
//  GithubViewer
//
//  Created by Ivan Rzhanoi on 6.1.2024.
//

import Foundation


struct User: Decodable {
    var login: String?
    var avatar_url: String?
    
    // For detailed user screen
    var fullName: String?
    var followers: String?
    var followees: String?
}
