//
//  TodoListScreen.swift
//  TodoManager
//
//  Created by Martin Hrbáček on 30.12.2025.
//

import SwiftUI
import SwiftData

struct TodoListScreen: View {
    
    @Environment(\.modelContext) private var context
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            TodoQueryListView(searchString: searchText)
                .navigationTitle("My Tasks")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gear")
                        }
                        
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            AddTodoScreen()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .navigationDestination(for: Todo.self) { todo in
                    TodoDetailScreen(todo: todo)
                }
                .searchable(text: $searchText, prompt: "Search your tasks...")
                .animation(.default, value: searchText)
        }
    }
}


#Preview {
    TodoListScreen()
        .modelContainer(for: Todo.self, inMemory: false)
}
