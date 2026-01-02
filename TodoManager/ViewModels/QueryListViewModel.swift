//
//  QueryListViewModel.swift
//  TodoManager
//
//  Created by Martin Hrbáček on 02.01.2026.
//

import Foundation
import Observation

@Observable
@MainActor
class QueryListViewModel {
    let searchString: String
    let priority: TodoPriority?
    
    init(searchString: String = "", priority: TodoPriority? = nil) {
        self.priority = priority
        self.searchString = searchString
    }
    
    var priorityTitle: String {
        priority?.rawValue ?? "All"
    }
    
    func filteredTodos(from todos: [Todo], searchText: String) -> [Todo] {
        var filtered = todos
        if let priority = priority {
            filtered = todos.filter { $0.priority == priority }
        }
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.title.localizedStandardContains(searchText) }
        }
        return filtered
    }
}
