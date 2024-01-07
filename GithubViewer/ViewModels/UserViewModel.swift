//
//  UserViewModel.swift
//  GithubViewer
//
//  Created by Ivan Rzhanoi on 7.1.2024.
//

import Foundation
import Combine


// ViewMode class associated with User list and user deatil views
class UserViewModel: ObservableObject {
    
    internal var subscriptions = Set<AnyCancellable>()
    let networker = Networker()
    
    internal func fetch() {
        guard let url = URL(string: "\(Constants.baseURL)/users") else {
            return
        }
        
        print("Fetching user list: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        networker.makeRequest(request: request)
//            .tryCatch({ (error) -> AnyPublisher<Data, APIError> in
//                switch error {
//                default:
//                    print(error.localizedDescription)
//                    throw error
//                }
//            })
            .receive(on: DispatchQueue.main) // we'll load results on main thread to prevent UI Freezeup
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished fetching list of users")
                    break
                case .failure(let error):
                    print("Oh noes! Error: \(error.localizedDescription)")
                }
            }, receiveValue: { (users: [User]) in//users in
                print(users)
            })
            .store(in: &subscriptions)
    }
}
