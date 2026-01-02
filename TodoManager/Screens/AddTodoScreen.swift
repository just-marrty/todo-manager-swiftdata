//
//  AddTodoScreen.swift
//  TaskManager
//
//  Created by Martin Hrbáček on 30.12.2025.
//

import SwiftUI
import SwiftData

struct AddTodoScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) private var context
    
    @State private var title: String = ""
    @State private var category: TodoCategory = .general
    @State private var priority: TodoPriority = .medium
    @State private var dueDate = Date()
    @State private var isDueDate: Bool = false
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        Form {
            // MARK: - New task
            Section {
                TextEditor(text: $title)
                    .frame(height: 130)
                    .autocorrectionDisabled()
            } header: {
                Text("New task")
            }
            .listRowBackground(Color.brown.opacity(0.2))
            
            // MARK: - Priority
            Section {
                Picker("Select priority", selection: $priority) {
                    ForEach(TodoPriority.allCases, id: \.rawValue) { priority in
                        Text(priority.rawValue)
                            .tag(priority)
                    }
                }
                .pickerStyle(.automatic)
            } header: {
                Text("Priority")
            }
            .listRowBackground(Color.brown.opacity(0.2))
            
            // MARK: - Category
            Section {
                Picker("Select category", selection: $category) {
                    ForEach(TodoCategory.allCases, id: \.self) { category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }
                .pickerStyle(.automatic)
            } header: {
                Text("Category")
            }
            .listRowBackground(Color.brown.opacity(0.2))
            
            // MARK: - Due date
            Section {
                Toggle("With due date (optional)", isOn: $isDueDate)
                    .tint(.blue.opacity(0.5))
                
                if isDueDate {
                    DatePicker("Due date", selection: $dueDate, in: Date()...)
                }
            } header: {
                Text("Due date")
            }
            .listRowBackground(Color.brown.opacity(0.2))
        }
        .navigationBarTitle("Add Task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                    let newTodo = Todo(title: trimmedTitle, isDone: false, category: category, priority: priority, dueDate: isDueDate ? dueDate : nil, createdAt: .now)
                    context.insert(newTodo)
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    dismiss()
                } label: {
                    Text("Save")
                }
                .disabled(!isFormValid)
            }
        }
        .scrollContentBackground(.hidden)
        .background {
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
        }
        .scrollDismissesKeyboard(.immediately)
    }
}

#Preview {
    NavigationStack {
        AddTodoScreen()
            .modelContainer(for: Todo.self, inMemory: false)
    }
}
