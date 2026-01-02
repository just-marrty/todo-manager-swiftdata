//
//  TodoMainScreen.swift
//  TodoManager
//
//  Created by Martin Hrbáček on 30.12.2025.
//

import SwiftUI
import SwiftData

struct TodoMainScreen: View {
    
    @AppStorage("isDarkOn") private var isDarkOn: Bool = false
    
    @State private var searchText: String = ""
    
    var body: some View {
        TabView {
            Tab("All", systemImage: "rectangle.grid.1x3") {
                NavigationStack {
                    TodoQueryListView(searchString: searchText, priority: nil)
                }
            }
            
            Tab("Low", systemImage: "1.square") {
                NavigationStack {
                    TodoQueryListView(searchString: searchText, priority: .low)
                }
            }
            
            Tab("Medium", systemImage: "2.square") {
                NavigationStack {
                    TodoQueryListView(searchString: searchText, priority: .medium)
                }
            }
            
            Tab("High", systemImage: "3.square") {
                NavigationStack {
                    TodoQueryListView(searchString: searchText, priority: .high)
                }
            }
        }
        .preferredColorScheme(isDarkOn ? .dark : .light)
    }
}

#Preview {
    TodoMainScreen()
        .modelContainer(for: Todo.self, inMemory: false)
}
