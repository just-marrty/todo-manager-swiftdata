//
//  Todo.swift
//  TaskManager
//
//  Created by Martin Hrbáček on 30.12.2025.
//

import Foundation
import SwiftData
import SwiftUI

enum TodoPriority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .low:
            return .blue.opacity(0.7)
        case .medium:
            return .orange.opacity(0.7)
        case .high:
            return .red.opacity(0.7)
        }
    }
}

enum TodoCategory: String, CaseIterable, Codable {
    case general = "General"
    case work = "Work"
    case personal = "Personal"
    case shopping = "Shopping"
}

@Model
class Todo {
    var title: String
    var isDone: Bool?
    var category: TodoCategory
    var priority: TodoPriority
    var dueDate: Date?
    var createdAt: Date
    
    init(title: String, isDone: Bool? = nil, category: TodoCategory, priority: TodoPriority, dueDate: Date? = nil, createdAt: Date) {
        self.title = title
        self.isDone = isDone
        self.category = category
        self.priority = priority
        self.dueDate = dueDate
        self.createdAt = createdAt
    }
}
