//
//  ContentView.swift
//  GithubViewer
//
//  Created by Ivan Rzhanoi on 6.1.2024.
//

import SwiftUI
import SwiftData
import Combine


struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var userVM: UserViewModel

    var body: some View {
        NavigationSplitView {
            List {
                // List fetched users
                ForEach(userVM.userList) { user in
                    // Only if we got their name
                    if let username = user.login {
                        NavigationLink {
                            UserDetailView(username: username)
                        } label: {
                            HStack {
                                // Check if we got their icon location
                                if let avatarURL = user.avatar_url {
                                    AsyncImage(url: URL(string: avatarURL)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 50, height: 50)
                                    .clipShape(.circle)
                                } else {
                                    Image("not_found")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                }

                                Text(username)
                            }
                            .onAppear(){
                                // When reaching the end, we fetch more users
                                if (user.id == userVM.since) {
                                    userVM.fetchUsers()
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Github User Viewer")
        } detail: {
            Text("Select an item")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserViewModel())
}
