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
        userVM.fetch()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userVM)
        }
    }
}
