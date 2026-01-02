//
//  TodoUpdateView.swift
//  TodoManager
//
//  Created by Martin Hrbáček on 30.12.2025.
//

import SwiftUI
import SwiftData

struct TodoUpdateView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @State private var title: String = ""
    @State private var category: TodoCategory = .general
    @State private var priority: TodoPriority = .medium
    @State private var dueDate = Date()
    @State private var isDueDate: Bool = false
    @State private var isTodoDone: Bool = false
    
    let todo: Todo
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        Form {
            // MARK: - Your task
            Section {
                TextEditor(text: $title)
                    .frame(height: 130)
                    .autocorrectionDisabled()
            } header: {
                Text("Your task")
            }
            .listRowBackground(Color.brown.opacity(0.2))
            
            // MARK: - Category
            Section {
                Picker("Select category", selection: $category) {
                    ForEach(TodoCategory.allCases, id: \.self) {   category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }
                .pickerStyle(.automatic)
            } header: {
                Text("Category")
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
            
            // MARK: - Due date
            Section {
                Toggle("With due date (optional)", isOn: $isDueDate)
                    .tint(.blue.opacity(0.5))
                
                if isDueDate {
                    DatePicker("Select due date", selection: $dueDate, in: Date()...)
                }
            } header: {
                Text("Due date")
            }
            .listRowBackground(Color.brown.opacity(0.2))
            
            // MARK: - Is done
            Section {
                Toggle("Is done (optional)", isOn: $isTodoDone)
                    .tint(.green.opacity(0.5))
            } header: {
                Text("Is done")
            } footer: {
                if isTodoDone {
                    Text("Your task is done!")
                        .font(.system(size: 18))
                        .foregroundStyle(.green)
                }
            }
            .listRowBackground(Color.brown.opacity(0.2))
        }
        .navigationBarTitle("Update Task")
        .onAppear {
            title = todo.title
            category = todo.category
            priority = todo.priority
            if let savedDueDate = todo.dueDate {
                isDueDate = true
                dueDate = savedDueDate
            } else {
                isDueDate = false
                dueDate = .now
            }
            if let todoDone = todo.isDone {
                isTodoDone = true
                isTodoDone = todoDone
            } else {
                isTodoDone = false
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                    todo.title = trimmedTitle
                    todo.category = category
                    todo.priority = priority
                    todo.dueDate = isDueDate ? dueDate : nil
                    todo.isDone = isTodoDone ? isTodoDone : nil
                    
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    dismiss()
                } label: {
                    Text("Update")
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
        TodoUpdateView(todo: Todo(title: "", category: TodoCategory.general, priority: TodoPriority.medium, createdAt: .now))
            .modelContainer(for: Todo.self, inMemory: false)
    }
}
