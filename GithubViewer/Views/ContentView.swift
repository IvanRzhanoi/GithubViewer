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
//    @ObservedObject var userVM: UserViewModel
    @Query private var items: [Item]
    

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
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

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}