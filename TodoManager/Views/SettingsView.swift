//
//  SettingsView.swift
//  TodoManager
//
//  Created by Martin Hrbáček on 01.01.2026.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isListRowSpacing") private var isListRowSpacing: Bool = false
    @AppStorage("isDarkOn") private var isDarkOn: Bool = false
    
    var body: some View {
        Form {
            Section {
                Toggle("List row spacing", isOn: $isListRowSpacing)
                    .tint(.blue.opacity(0.5))
            } header: {
                Text("Design - Rows")
            }
            .listRowBackground(Color.brown.opacity(0.2))
            
            Section {
                Toggle(isDarkOn ? "Light mode" : "Dark mode", isOn: $isDarkOn)
                    .tint(.blue.opacity(0.5))
            } header: {
                Text("Design - Appearance")
            }
            .listRowBackground(Color.brown.opacity(0.2))
        }
        .navigationTitle("Settings")
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
        SettingsView()
    }
}
