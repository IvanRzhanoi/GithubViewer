//
//  Repo.swift
//  GithubViewer
//
//  Created by Ivan Rzhanoi on 6.1.2024.
//

import Foundation


struct Repo: Decodable, Identifiable {
    var name: String?
    var id: Int?
    var fork: Bool?
    var developmentLanguage: String?
    var stargazers_count: Int?
    var description: String?
    var html_url: String?
    var language: String?
}

