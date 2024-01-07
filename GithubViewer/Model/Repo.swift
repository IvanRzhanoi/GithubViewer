//
//  Repo.swift
//  GithubViewer
//
//  Created by Ivan Rzhanoi on 6.1.2024.
//

import Foundation


struct Repo: Decodable {
    var name: String?
    var developmentLanguage: String?
    var stars: Int?
    var description: String?
}

