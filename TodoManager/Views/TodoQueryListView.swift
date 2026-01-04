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
    
    @State private var searchText: String = ""
    @State private var queryVM: QueryListViewModel
    
    var filteredTodos: [Todo] {
        queryVM.filteredTodos(from: todos, searchText: searchText)
    }
    
    var body: some View {
        List(filteredTodos) { todo in
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
                                Image(systemName: "checkmark.circle")
                            }
                            .foregroundStyle(.green)
                        } else if let dueDate = todo.dueDate, dueDate < Date() {
                            HStack {
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
        .navigationTitle("My Tasks - \(queryVM.priorityTitle)")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink {
                    TodoSettingsView()
                } label: {
                    Image(systemName: "gear")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AddTodoView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .navigationDestination(for: Todo.self) { todo in
            TodoUpdateView(todo: todo)
        }
        .listRowSpacing(isListRowSpacing ? 0 : 6)
        .scrollContentBackground(.hidden)
        .background {
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
        }
        .searchable(text: $searchText, prompt: "Search your tasks...")
        .animation(.default, value: searchText)
    }
    
    init(priority: TodoPriority? = nil) {
        _queryVM = State(initialValue: QueryListViewModel(priority: priority))
        
        _todos = Query(sort: \Todo.dueDate)
    }
}

#Preview {
    NavigationStack {
        TodoQueryListView(priority: .low)
            .modelContainer(for: Todo.self, inMemory: false)
    }
}
