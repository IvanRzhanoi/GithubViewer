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
                ForEach(userVM.userList) { user in
                    if let username = user.login {
                        NavigationLink {
                            UserDetailView(username: username)
                        } label: {
                            HStack {
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
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Fetch again", action: fetch)
                }
            }
            .navigationTitle("Github User Viewer")
        } detail: {
            Text("Select an item")
        }
    }
    
    private func fetch() {
        userVM.fetch()
    }
}

#Preview {
    ContentView()
        .environmentObject(UserViewModel())
}
