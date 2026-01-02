//
//  TodoManagerApp.swift
//  TodoManager
//
//  Created by Martin Hrbáček on 30.12.2025.
//

import SwiftUI
import SwiftData

@main
struct TodoManagerApp: App {
    var body: some Scene {
        WindowGroup {
            TodoMainScreen()
        }
        .modelContainer(for: Todo.self)
    }
}
