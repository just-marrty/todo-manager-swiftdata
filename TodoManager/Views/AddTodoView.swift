//
//  AddTodoView.swift
//  TodoManager
//
//  Created by Martin Hrbáček on 30.12.2025.
//

import SwiftUI
import SwiftData

struct AddTodoView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var category: TodoCategory = .general
    @State private var priority: TodoPriority = .medium
    @State private var dueDate = Date()
    @State private var isDueDate: Bool = false
    @State private var queryVM = QueryListViewModel()
    
    var body: some View {
        Form {
            // MARK: - New task
            Section {
                TextEditor(text: $queryVM.title)
                    .frame(height: 130)
                    .autocorrectionDisabled()
            } header: {
                Text(Strings.newTask)
            }
            .listRowBackground(Color.brown.opacity(0.2))
            
            // MARK: - Priority
            Section {
                Picker(Strings.selectPriority, selection: $priority) {
                    ForEach(TodoPriority.allCases, id: \.rawValue) { priority in
                        Text(priority.rawValue)
                            .tag(priority)
                    }
                }
                .pickerStyle(.automatic)
            } header: {
                Text(Strings.priority)
            }
            .listRowBackground(Color.brown.opacity(0.2))
            
            // MARK: - Category
            Section {
                Picker(Strings.selectCategory, selection: $category) {
                    ForEach(TodoCategory.allCases, id: \.self) { category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }
                .pickerStyle(.automatic)
            } header: {
                Text(Strings.category)
            }
            .listRowBackground(Color.brown.opacity(0.2))
            
            // MARK: - Due date
            Section {
                Toggle(Strings.withDueDate, isOn: $isDueDate)
                    .tint(.blue.opacity(0.5))
                
                if isDueDate {
                    DatePicker(Strings.dueDate, selection: $dueDate, in: Date()...)
                }
            } header: {
                Text(Strings.dueDate)
            }
            .listRowBackground(Color.brown.opacity(0.2))
        }
        .navigationBarTitle(Strings.addTask)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    let trimmedTitle = queryVM.trimmedTitle()
                    let newTodo = Todo(title: trimmedTitle, isDone: false, category: category, priority: priority, dueDate: isDueDate ? dueDate : nil, createdAt: .now)
                    context.insert(newTodo)
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    dismiss()
                } label: {
                    Text(Strings.save)
                }
                .disabled(!queryVM.isFormValid())
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
        AddTodoView()
            .modelContainer(for: Todo.self, inMemory: false)
    }
}
