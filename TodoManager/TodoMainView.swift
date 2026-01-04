//
//  TodoMainView.swift
//  TodoManager
//
//  Created by Martin Hrbáček on 30.12.2025.
//

import SwiftUI
import SwiftData

struct TodoMainView: View {
    
    @AppStorage("isDarkOn") private var isDarkOn: Bool = false
    
    var body: some View {
        TabView {
            Tab("All", systemImage: "rectangle.grid.1x3") {
                NavigationStack {
                    TodoQueryListView(priority: nil)
                }
            }
            
            Tab("Low", systemImage: "1.square") {
                NavigationStack {
                    TodoQueryListView(priority: .low)
                }
            }
            
            Tab("Medium", systemImage: "2.square") {
                NavigationStack {
                    TodoQueryListView(priority: .medium)
                }
            }
            
            Tab("High", systemImage: "3.square") {
                NavigationStack {
                    TodoQueryListView(priority: .high)
                }
            }
        }
        .preferredColorScheme(isDarkOn ? .dark : .light)
    }
}

#Preview {
    TodoMainView()
        .modelContainer(for: Todo.self, inMemory: false)
}
