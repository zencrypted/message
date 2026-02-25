import Foundation
import Combine
import SwiftUI

enum UserThemePreference: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

enum LanguagePreference: String, CaseIterable, Identifiable {
    case english = "en"
    case ukrainian = "uk"
    case arabic = "ar"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .ukrainian: return "Українська"
        case .arabic: return "العربية"
        }
    }
    
    var layoutDirection: LayoutDirection {
        self == .arabic ? .rightToLeft : .leftToRight
    }
}

enum DocumentColumn: String, CaseIterable, Identifiable {
    case type = "Type"
    case initiator = "Initiator"
    case addressedTo = "Addressed To"
    case stage = "Stage"
    case number = "Number"
    case date = "Date"
    case correspondent = "Correspondent"
    case summary = "Summary"
    case outNumber = "Out Number"
    
    var id: String { rawValue }
}

/// Global state to manage the CRM App
class CRMState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: UserProfile? = nil
    
    // Theme
    // Theme & Language
    @Published var selectedTheme: UserThemePreference = .system
    @Published var selectedLanguage: LanguagePreference = .english
    
    // Wizard Form Navigation State
    @Published var selectedTab: Int = 0
    
    // View Filters
    @Published var documentFilter: String = "All"
    
    // Navigation State
    @Published var selectedInbox: InboxFolder? = nil
    
    // Multi-Selection State
    @Published var selectedDocuments: Set<Document.ID> = []
    
    // Column Visibility State
    @Published var visibleColumns: Set<DocumentColumn> = Set(DocumentColumn.allCases)
    
    // Column Filters
    @Published var typeFilter: String = ""
    @Published var initiatorFilter: String = ""
    @Published var addressedToFilter: String = ""
    @Published var stageFilter: String = ""
    @Published var numberFilter: String = ""
    @Published var correspondentFilter: String = ""
    @Published var summaryFilter: String = ""
    @Published var outNumberFilter: String = ""
    
    // Tabs
    @Published var openDocuments: [Document] = []
    
    // Mock Data loading
    func loadMockData() {
        self.currentUser = UserProfile.mock
        self.isLoggedIn = true
    }
    
    func logout() {
        self.currentUser = nil
        self.isLoggedIn = false
        self.selectedInbox = nil
        self.selectedDocuments.removeAll()
        self.openDocuments.removeAll()
    }
}
