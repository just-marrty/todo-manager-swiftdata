//
//  TodoManagerApp.swift
//  TaskManager
//
//  Created by Martin Hrbáček on 30.12.2025.
//

import SwiftUI
import SwiftData

@main
struct TodoManagerApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListScreen()
        }
        .modelContainer(for: Todo.self)
    }
}
