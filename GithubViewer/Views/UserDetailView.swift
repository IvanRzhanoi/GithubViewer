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
            Text(username)
            Text(userVM.name ?? "not found")
            Text("\(userVM.followers ?? 0)")
            Text("\(userVM.following ?? 0)")
            Text("Repositories")
                .font(.title)
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
    })
    }
    
}

#Preview {
    UserDetailView(username: "mojombo")
        .environmentObject(UserViewModel())
}
