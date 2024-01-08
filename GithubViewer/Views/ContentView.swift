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
    @Query private var items: [Item]
    

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
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
                ToolbarItem {
                    Button("Fetch", action: fetch)
                }
            }
        } detail: {
            Text("Select an item")
        }
    }
    
    private func fetch() {
        userVM.fetch()
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
        .environmentObject(UserViewModel())
}
