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
            Tab(Strings.tabAll, systemImage: Strings.rectangleGrid) {
                NavigationStack {
                    TodoQueryListView(priority: nil)
                }
            }
            
            Tab(Strings.tabLow, systemImage: Strings.square1) {
                NavigationStack {
                    TodoQueryListView(priority: .low)
                }
            }
            
            Tab(Strings.tabMedium, systemImage: Strings.square2) {
                NavigationStack {
                    TodoQueryListView(priority: .medium)
                }
            }
            
            Tab(Strings.tabHigh, systemImage: Strings.square3) {
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
