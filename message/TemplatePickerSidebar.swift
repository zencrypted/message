import SwiftUI

struct TemplatePickerSidebar: View {
    @Binding var selectedTemplate: DocumentTemplate?
    let categories: [TemplateCategory]
    
    @State private var searchText: String = ""
    
    // Derived property to filter categories and templates dynamically
    var filteredCategories: [TemplateCategory] {
        if searchText.isEmpty {
            return categories
        }
        
        let lowercasedSearch = searchText.lowercased()
        
        return categories.compactMap { category in
            // Match against category name first
            if category.categoryName.lowercased().contains(lowercasedSearch) {
                return category
            }
            
            // Otherwise, filter the templates within the category
            let matchingTemplates = category.templates.filter { template in
                template.templateName.lowercased().contains(lowercasedSearch) ||
                template.description.lowercased().contains(lowercasedSearch)
            }
            
            if !matchingTemplates.isEmpty {
                // Return a new Category struct containing ONLY the filtered templates
                return TemplateCategory(categoryName: category.categoryName, iconName: category.iconName, templates: matchingTemplates)
            }
            
            return nil
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Inline Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(CRMTheme.secondaryText)
                TextField("Search Templates...", text: $searchText)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(CRMTheme.secondaryText)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
            .background(CRMTheme.secondaryBackground)
            .cornerRadius(8)
            .padding(12)
            
            List {
                ForEach(filteredCategories) { category in
                    Section {
                        ForEach(category.templates) { template in
                            Button {
                                selectedTemplate = template
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: template.iconName)
                                        .foregroundColor(CRMTheme.accent)
                                        .frame(width: 24, alignment: .center)
                                        .font(.title2)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(template.templateName)
                                            .font(.body.bold())
                                            .foregroundColor(CRMTheme.primaryText)
                                        Text(template.description)
                                            .font(.caption)
                                            .foregroundColor(CRMTheme.secondaryText)
                                            .lineLimit(2)
                                    }
                                    Spacer()
                                    if selectedTemplate?.id == template.id {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(CRMTheme.accent)
                                    }
                                }
                                .padding(.vertical, 4)
                                .contentShape(Rectangle()) // makes entire row clickable
                            }
                            .buttonStyle(.plain) // remove default button styling inside List
                        }
                    } header: {
                        HStack {
                            Image(systemName: category.iconName)
                            Text(category.categoryName)
                        }
                        .font(.headline)
                        .foregroundColor(CRMTheme.primaryText)
                    }
                }
            }
            .listStyle(.sidebar)
        }
    }
}
