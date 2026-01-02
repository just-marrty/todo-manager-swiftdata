//
//  TodoQueryListView.swift
//  TodoManager
//
//  Created by Martin Hrbáček on 31.12.2025.
//

import SwiftUI
import SwiftData

struct TodoQueryListView: View {
    
    @AppStorage("isListRowSpacing") private var isListRowSpacing: Bool = false
    
    @Environment(\.modelContext) private var context
    @Query private var todos: [Todo]
    
    var body: some View {
        List(todos) { todo in
            NavigationLink(value: todo) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(todo.title)
                        .lineLimit(1)
                    HStack {
                        Text("Priority:")
                        Text(todo.priority.rawValue)
                            .foregroundStyle(todo.priority.color)
                    }
                    HStack {
                        Text("Due date:")
                        Text(todo.dueDate?.formatted() ?? "No due date")
                        
                        Spacer()
                        
                        if todo.isDone == true {
                            HStack {
                                Text("Done")
                                Image(systemName: "checkmark.circle")
                            }
                            .foregroundStyle(.green)
                        } else if let dueDate = todo.dueDate, dueDate < Date() {
                            HStack {
                                Text("Expired")
                                Image(systemName: "exclamationmark.circle")
                            }
                            .foregroundStyle(.red)
                        } else {
                            HStack {
                                Image(systemName: "figure.run.circle")
                            }
                        }
                    }
                }
            }
            .disabled(todo.dueDate != nil && todo.dueDate! < Date())
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button {
                    context.delete(todo)
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                } label: {
                    Image(systemName: "trash.fill")
                }
                .tint(.red.opacity(0.5))
            }
            .listRowBackground(Rectangle()
                .fill(Color.brown.opacity(0.2)))
            .listRowInsets(EdgeInsets(top: 8, leading: 15, bottom: 8, trailing: 15))
        }
        .listRowSpacing(isListRowSpacing ? 0 : 6)
        .scrollContentBackground(.hidden)
        .background {
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
        }
    }
    
    init(searchString: String = "") {
        _todos = Query(filter: #Predicate { todo in
            if searchString.isEmpty {
                true
            } else {
                todo.title.localizedStandardContains(searchString)
            }
        },
        sort: \Todo.dueDate,
        order: .forward
        )
    }
}

#Preview {
    NavigationStack {
        TodoQueryListView()
            .modelContainer(for: Todo.self, inMemory: false)
    }
}
