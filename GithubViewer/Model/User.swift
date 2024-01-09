//
//  User.swift
//  GithubViewer
//
//  Created by Ivan Rzhanoi on 6.1.2024.
//

import SwiftUI
import Foundation


// Information for our wonderfu user. We fetch many users
struct User: Decodable, Identifiable {
    var login: String?
    var id: Int?
    var avatar_url: String?
    
    // For detailed user screen
    var name: String?
    var followers: Int?
    var following: Int?
}
