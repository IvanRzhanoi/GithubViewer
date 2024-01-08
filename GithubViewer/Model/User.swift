//
//  User.swift
//  GithubViewer
//
//  Created by Ivan Rzhanoi on 6.1.2024.
//

import Foundation


struct User: Decodable, Identifiable {
    var login: String?
    var id: Int?
    var avatar_url: String?
    
    // For detailed user screen
    var name: String?
    var followers: Int?
    var following: Int?
}
