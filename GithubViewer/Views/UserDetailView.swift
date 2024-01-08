//
//  UserDetailView.swift
//  GithubViewer
//
//  Created by Ivan Rzhanoi on 8.1.2024.
//

import SwiftUI

struct UserDetailView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    var username: String
    @State private var isPresentWebView = false
    
    var body: some View {
        VStack {
            HStack {
                if let avatarURL = userVM.avatar_url {
                    AsyncImage(url: URL(string: avatarURL)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(.circle)
                }
                VStack(alignment: .leading) {
                    Text(username)
                    Text(userVM.name ?? "not found")
                    Text("Followers: \(userVM.followers ?? 0)")
                    Text("Following: \(userVM.following ?? 0)")
                }
            }
            
            List {
                ForEach(userVM.repoList) { repo in
                    if let name = repo.name {
                        Button(action: {
                            if let url = repo.html_url, let webpage = URL(string: url) {
                                userVM.repoLink = webpage
                                isPresentWebView = true
                            }
                        }) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(name)
                                        .font(.title2)
                                        .foregroundStyle(.blue)
                                    Label("\(repo.stargazers_count ?? 0)", systemImage: "star")
                                            .font(.title)
                                            .labelStyle(.titleAndIcon)
                                }
                                
                                Text("Language: \(repo.language ?? "not found")")
                                Text("\(repo.description ?? "not found")")
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentWebView) {
            NavigationStack {
                // 3
                WebView(url: userVM.repoLink) // Won't be called unless we have proper URL
                    .ignoresSafeArea()
                    .navigationTitle("Github")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear(perform: {
            userVM.getUserDetails(username: username)
            userVM.getUserRepos(username: username)
        })
        .onDisappear(perform: {
            userVM.name = nil
            userVM.followers = nil
            userVM.following = nil
            userVM.avatar_url = nil
    })
    }
    
}

#Preview {
    UserDetailView(username: "mojombo")
        .environmentObject(UserViewModel())
}
