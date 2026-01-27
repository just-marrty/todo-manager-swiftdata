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
    
    @State private var category: TodoCategory = .general
    @State private var priority: TodoPriority = .medium
    @State private var dueDate = Date()
    @State private var isDueDate: Bool = false
    @State private var isTodoDone: Bool = false
    @State private var queryVM = QueryListViewModel()
    
    let todo: Todo
    
    var body: some View {
        Form {
            // MARK: - Your task
            Section {
                TextEditor(text: $queryVM.title)
                    .frame(height: 130)
                    .autocorrectionDisabled()
            } header: {
                Text(Strings.yourTask)
            }
            .listRowBackground(Color.brown.opacity(0.2))
            
            // MARK: - Category
            Section {
                Picker(Strings.selectCategory, selection: $category) {
                    ForEach(TodoCategory.allCases, id: \.self) {   category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }
                .pickerStyle(.automatic)
            } header: {
                Text(Strings.category)
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
            
            // MARK: - Due date
            Section {
                Toggle(Strings.withDueDate, isOn: $isDueDate)
                    .tint(.blue.opacity(0.5))
                
                if isDueDate {
                    DatePicker(Strings.selectDueDate, selection: $dueDate, in: Date()...)
                }
            } header: {
                Text(Strings.dueDate)
            }
            .listRowBackground(Color.brown.opacity(0.2))
            
            // MARK: - Is done
            Section {
                Toggle(Strings.isDone, isOn: $isTodoDone)
                    .tint(.green.opacity(0.5))
            } header: {
                Text(Strings.isDone)
            } footer: {
                if isTodoDone {
                    Text(Strings.yourTaskIsDone)
                        .font(.system(size: 18))
                        .foregroundStyle(.green)
                }
            }
            .listRowBackground(Color.brown.opacity(0.2))
        }
        .navigationBarTitle(Strings.updateTask)
        .onAppear {
            queryVM.title = todo.title
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
                    let trimmedTitle = queryVM.title.trimmingCharacters(in: .whitespacesAndNewlines)
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
                    Text(Strings.updated)
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
        TodoUpdateView(todo: Todo(title: "", category: TodoCategory.general, priority: TodoPriority.medium, createdAt: .now))
            .modelContainer(for: Todo.self, inMemory: false)
    }
}
