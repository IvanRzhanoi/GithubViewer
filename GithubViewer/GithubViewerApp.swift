//
//  GithubViewerApp.swift
//  GithubViewer
//
//  Created by Ivan Rzhanoi on 6.1.2024.
//

import SwiftUI
import SwiftData

@main
struct GithubViewerApp: App {
    
    var userVM: UserViewModel
    
    init() {
        userVM = UserViewModel()
        // By the time app user reaches the main screen, the app will already be in the process of fetching information
        userVM.fetchUsers()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userVM)
        }
    }
}
