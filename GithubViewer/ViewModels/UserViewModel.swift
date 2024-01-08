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
    
    @Published var userList: [User] = []
    @Published var selectedUser: User = User()
    @Published var name: String?
    @Published var avatar_url: String?
    @Published var followers: Int?
    @Published var following: Int?
    @Published var repoList: [Repo] = []
    var repoLink = URL(string: "https://ivanrz.com")!
    
    
    // Get a basic list of users
    internal func fetch() {
        guard let url = URL(string: "\(Constants.baseURL)/users") else {
            return
        }
        
        print("Fetching user list: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        networker.makeRequest(request: request)
            .receive(on: DispatchQueue.main) // we'll load results on main thread to prevent UI Freezeup
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished fetching list of users")
                    break
                case .failure(let error):
                    print("Oh noes! Error: \(error.localizedDescription)")
                }
            }, receiveValue: { [self] (users: [User]) in
                print(users)
                userList = users
            })
            .store(in: &subscriptions)
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
                print("swag")
                print(repos)
                print("hmm")
                repoList = repos
            })
            .store(in: &subscriptions)
    }
}
