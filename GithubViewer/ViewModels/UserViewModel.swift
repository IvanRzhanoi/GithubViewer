//
//  UserViewModel.swift
//  GithubViewer
//
//  Created by Ivan Rzhanoi on 7.1.2024.
//

import Foundation
import Combine
import UIKit


// ViewMode class associated with User list and user deatil views
class UserViewModel: ObservableObject {
    
    internal var subscriptions = Set<AnyCancellable>()
    let networker = Networker()
    
    @Published var userList: [User] = [] // List of users we fetched
    @Published var since: Int = 0 // Indicates id of last user in table
    @Published var name: String?
    @Published var avatar_url: String?
    @Published var followers: Int?
    @Published var following: Int?
    @Published var repoList: [Repo] = []
    var repoLink = URL(string: "https://ivanrz.com")! //  Default link for my own website. In practise it doesn't matter, because if repo does not have a link, webview won't be opened
    
    
    // Get a basic list of users
    internal func fetchUsers() {
        
        // Constructing URL
        guard let url = URL(string: "\(Constants.baseURL)/users?since=\(since)") else {
            return
        }
        
        print("Fetching user list: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Calling Networker to get URLSession Publisher
        networker.makeRequest(request: request)
            .receive(on: DispatchQueue.main) // we'll load results on main thread to prevent UI Freezeup
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished fetching list of users")
                    break
                case .failure(let error):
                    print("Oh noes! Error: \(error.localizedDescription)")
                    print(error)
                }
            }, receiveValue: { [self] (users: [User]) in
                print(users)
                // Add users we fetched to list
                userList += users
                
                // Getting the latest user ID
                if let latestUser = userList.last, let lastID = latestUser.id {
                    since = lastID
                }
            })
            .store(in: &subscriptions) // Storing Publisher in subscriptions
    }
    
    
    // Get details of selected user
    internal func getUserDetails(username: String) {
        
        guard let url = URL(string: "\(Constants.baseURL)/users/\(username)") else {
            return
        }
        
        print("Fetching user details: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        networker.makeRequest(request: request)
            .receive(on: DispatchQueue.main) // we'll load results on main thread to prevent UI Freezeup
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished fetching details of given users")
                    break
                case .failure(let error):
                    print("Oh noes! Error: \(error.localizedDescription)")
                    print(error)
                }
            }, receiveValue: { [self] (user: User) in
                name = user.name
                avatar_url = user.avatar_url
                followers = user.followers
                following = user.following
            })
            .store(in: &subscriptions)
    }
    
    
    // Get list of user repositories
    internal func getUserRepos(username: String) {
        
        guard let url = URL(string: "\(Constants.baseURL)/users/\(username)/repos") else {
            return
        }
        
        print("Fetching user repos: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        networker.makeRequest(request: request)
            .receive(on: DispatchQueue.main) // we'll load results on main thread to prevent UI Freezeup
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished fetching repos")
                    break
                case .failure(let error):
                    print("Oh noes! Error: \(error.localizedDescription)")
                    print(error)
                }
            }, receiveValue: { [self] (repos: [Repo]) in
                print(repos)
                repoList = repos
            })
            .store(in: &subscriptions)
    }
}
