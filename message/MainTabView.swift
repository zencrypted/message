import SwiftUI

/// Main container for the CRM system, loaded after successful login.
struct MainTabView: View {
    @EnvironmentObject var state: CRMState
    
    var body: some View {
        TabView(selection: $state.selectedTab) {
            CRMMainView()
                .tabItem {
                    Label("Search", systemImage: "tray.full")
                }
                .tag(0)
            FormsView()
                .tabItem {
                    Label("Create", systemImage: "list.clipboard")
                }
                .tag(1)
        }
        .accentColor(CRMTheme.accent)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                if let user = state.currentUser {
                    HStack {
                        Image(systemName: "person.circle.fill")
                        Text("\(user.name) - \(user.role)")
                            .font(.headline)
                        Text(user.organization)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    .frame(width: 250, height: 25)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Picker("Filter", selection: $state.documentFilter) {
                    Text("All").tag("All")
                    Text("In-process").tag("Processed")
                    Text("Non-started").tag("Not Processed")
                }
                .pickerStyle(.segmented)
                .padding()
                .frame(width: 230, height: 25)
            }
            
            ToolbarItem(placement: .primaryAction) {
                HStack {
                    Picker("Theme", selection: $state.selectedTheme) {
                        ForEach(UserThemePreference.allCases, id: \.self) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 180, height: 25)
                
                    Picker("Language", selection: $state.selectedLanguage) {
                        ForEach(LanguagePreference.allCases) { lang in
                            Text(lang.displayName).tag(lang)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: 120, height: 20)
                }
                
                
            }
        }
    }
}
