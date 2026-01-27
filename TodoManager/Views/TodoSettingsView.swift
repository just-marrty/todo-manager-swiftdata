//
//  TodoSettingsView.swift
//  TodoManager
//
//  Created by Martin Hrbáček on 01.01.2026.
//

import SwiftUI

struct TodoSettingsView: View {
    
    @AppStorage("isListRowSpacing") private var isListRowSpacing: Bool = false
    @AppStorage("isDarkOn") private var isDarkOn: Bool = false
    
    var body: some View {
        Form {
            Section {
                Toggle(Strings.listRowSpacing, isOn: $isListRowSpacing)
                    .tint(.blue.opacity(0.5))
            } header: {
                Text(Strings.designRows)
            }
            .listRowBackground(Color.brown.opacity(0.2))
            
            Section {
                Toggle(isDarkOn ? Strings.lightMode : Strings.darkMode, isOn: $isDarkOn)
                    .tint(.blue.opacity(0.5))
            } header: {
                Text(Strings.designAppearance)
            }
            .listRowBackground(Color.brown.opacity(0.2))
        }
        .navigationTitle(Strings.settings)
        .scrollContentBackground(.hidden)
        .background {
            Color.blue.opacity(0.1)
                .ignoresSafeArea()
        }
        .preferredColorScheme(isDarkOn ? .dark : .light)
    }
}

#Preview {
    NavigationStack {
        TodoSettingsView()
    }
}
