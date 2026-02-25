// ChatApp.swift
// Copyright (c) 2026 Namdak Tonpa

import SwiftUI
import CoreData

@main
struct ChatApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var crmState = CRMState()

    var body: some Scene {
        WindowGroup {
            Group {
                if crmState.isLoggedIn {
                    MainTabView()
                } else {
                    LoginView()
                }
            }
            .environmentObject(crmState)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environment(\.locale, Locale(identifier: crmState.selectedLanguage.rawValue))
            .environment(\.layoutDirection, crmState.selectedLanguage.layoutDirection)
            .preferredColorScheme(crmState.selectedTheme.colorScheme)
        }
        
        WindowGroup(id: "inboxWindow", for: String.self) { $folderId in
            if let id = folderId, let folder = InboxFolder.mockFolders.first(where: { $0.id == id }) {
                StandaloneInboxWindow(folder: folder, theme: crmState.selectedTheme)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
        #if os(macOS)
        .commands {
            // macOS Window Management & Shortcuts
            CommandGroup(replacing: .newItem) {
                //Button("New Document") {
                    // Trigger new document logic
               // }
               // .keyboardShortcut("n", modifiers: .command)
                
                Button("Open File...") {
                    // Trigger file open
                }
                .keyboardShortcut("o", modifiers: .command)
            }
            
            CommandMenu("Directory") {
                Button("Switch User...") {
                    crmState.logout()
                }
                .keyboardShortcut("u", modifiers: [.command, .shift])
            }
            
            CommandGroup(replacing: .windowList) {
                Button("Show Inboxes") {
                    // Handle window bring to front
                }
                .keyboardShortcut("1", modifiers: .command)
                
                Button("Show Forms") {
                    // Handle window bring to front
                }
                .keyboardShortcut("2", modifiers: .command)
            }
        }
        #endif
    }
}

/// A wrapper to provide a localized CRMState for a standalone window (tab) so 
/// selecting items doesn't interfere with the main window's selection state.
struct StandaloneInboxWindow: View {
    let folder: InboxFolder
    let theme: UserThemePreference
    @StateObject private var localState = CRMState()
    
    var body: some View {
        MainTabView()
            .environmentObject(localState)
            .preferredColorScheme(theme.colorScheme)
            .onAppear {
                localState.loadMockData()
                localState.selectedInbox = folder
            }
    }
}
