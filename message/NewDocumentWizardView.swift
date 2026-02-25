import SwiftUI
import PDFKit
internal import UniformTypeIdentifiers

struct NewDocumentWizardView: View {
    @EnvironmentObject var state: CRMState
    
    @State private var selectedTemplate: DocumentTemplate? = nil
    
    // Tracking form values dynamically based on their underlying type 
    @State private var fieldValues: [UUID: String] = [:]
    @State private var dateValues: [UUID: Date] = [:]
    @State private var toggleValues: [UUID: Bool] = [:]
    
    @State private var selectedPDF: URL? = nil
    @State private var generatedPDFData: Data? = nil
    
    var body: some View {
        NavigationStack {
            Group {
                #if os(macOS)
                HSplitView {
                    leftPane
                        .frame(minWidth: 250, idealWidth: 300, maxWidth: 400)
                    middlePane
                        .frame(minWidth: 300, idealWidth: 350, maxWidth: 500)
                    rightPane
                        .frame(minWidth: 400, maxWidth: .infinity, maxHeight: .infinity)
                }
                #else
                HStack(spacing: 0) {
                    leftPane
                        .frame(width: 300)
                    Divider()
                    middlePane
                        .frame(width: 350)
                    Divider()
                    rightPane
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                #endif
            }
            .navigationTitle(selectedTemplate?.templateName ?? "Select Document Category")
            /*
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset Form") {
                        withAnimation {
                            selectedTemplate = nil
                            fieldValues.removeAll()
                            dateValues.removeAll()
                            toggleValues.removeAll()
                            selectedPDF = nil
                            generatedPDFData = nil
                        }
                    }
                }
            }
             */
        }
        // Size the layout properly on macOS
        .frame(minWidth: 1000, minHeight: 600)
        .onChange(of: selectedTemplate?.id) { _ in
            if selectedTemplate != nil {
                generateBlankPDF()
            } else {
                selectedPDF = nil
                generatedPDFData = nil
            }
        }
    }
    
    @ViewBuilder
    private var leftPane: some View {
        TemplatePickerSidebar(selectedTemplate: $selectedTemplate, categories: TemplateCategory.mockCategories)
            .background(CRMTheme.primaryBackground)
    }
    
    @ViewBuilder
    private var middlePane: some View {
        VStack(spacing: 0) {
            unifiedFormStep
        }
        .crmBackground()
    }
    
    @ViewBuilder
    private var rightPane: some View {
        VStack {
            if let url = selectedPDF {
                PDFKitView(url: url,
                           template: selectedTemplate,
                           fieldValues: fieldValues,
                           dateValues: dateValues)
                    .background(CRMTheme.secondaryBackground)
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(CRMTheme.secondaryText)
                    Text("No PDF Document Selected")
                        .font(.headline)
                        .foregroundColor(CRMTheme.secondaryText)
                    
                    Text("Select a document from step 2 to preview.")
                        .foregroundColor(CRMTheme.secondaryText)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(CRMTheme.secondaryBackground)
            }
        }
    }
    
    // UI: Unified Form Step
    @ViewBuilder
    private var unifiedFormStep: some View {
        if let template = selectedTemplate {
            VStack(alignment: .leading, spacing: 16) {
                Form {
                    Section("Metadata Fields") {
                        ForEach(template.requiredFields) { field in
                            HStack {
                                Text(field.title)
                                    .frame(alignment: .leading)
                                Spacer()
                                dynamicField(for: field)
                            }
                        }
                    }
                }
                .formStyle(.grouped)
                
                HStack {
                    Spacer()
                    Button("Create Document") {
                        // Normally this would persist the metadata and attach it to the CRM list.
                        withAnimation {
                            selectedTemplate = nil
                            fieldValues.removeAll()
                            dateValues.removeAll()
                            toggleValues.removeAll()
                            generatedPDFData = nil
                            selectedPDF = nil
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(generatedPDFData == nil)
                }
                .padding()
            }
        } else {
            VStack(spacing: 20) {
                Image(systemName: "hand.point.left")
                    .font(.system(size: 60))
                    .foregroundColor(CRMTheme.secondaryText)
                Text("Select a Template")
                    .font(.headline)
                    .foregroundColor(CRMTheme.primaryText)
                Text("Choose a category and template from the left pane to begin.")
                    .font(.subheadline)
                    .foregroundColor(CRMTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func generateBlankPDF() {
        let pdf = PDFDocument()
        let page = PDFPage()
        
        let height: CGFloat = page.bounds(for: .mediaBox).height
        
        #if os(macOS)
        let fontTitle = NSFont.boldSystemFont(ofSize: 24)
        let fontSub = NSFont.systemFont(ofSize: 14)
        let color = NSColor.gray
        let clear = NSColor.clear
        #else
        let fontTitle = UIFont.boldSystemFont(ofSize: 24)
        let fontSub = UIFont.systemFont(ofSize: 14)
        let color = UIColor.gray
        let clear = UIColor.clear
        #endif
        
        let titleAnnotation = PDFAnnotation(
            bounds: CGRect(x: 50, y: height - 80, width: 500, height: 40),
            forType: .freeText,
            withProperties: nil
        )
        titleAnnotation.contents = "ZEN CRYPTED"
        titleAnnotation.font = fontTitle
        titleAnnotation.fontColor = color
        titleAnnotation.color = clear
        page.addAnnotation(titleAnnotation)
        
        let subAnnotation = PDFAnnotation(
            bounds: CGRect(x: 50, y: height - 110, width: 500, height: 30),
            forType: .freeText,
            withProperties: nil
        )
        subAnnotation.contents = "CEO: Maxim Sokhatsky"
        subAnnotation.font = fontSub
        subAnnotation.fontColor = color
        subAnnotation.color = clear
        page.addAnnotation(subAnnotation)
        
        pdf.insert(page, at: 0)
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".pdf")
        if pdf.write(to: tempURL) {
            self.selectedPDF = tempURL
            self.generatedPDFData = pdf.dataRepresentation()
        } else {
            print("Failed to save temp PDF.")
        }
    }
    
    @ViewBuilder
    private func dynamicField(for field: FormField) -> some View {
        switch field.type {
        case .text:
            TextField("", text: Binding(
                get: { fieldValues[field.id] ?? "" },
                set: { fieldValues[field.id] = $0 }
            ))
            .textFieldStyle(.roundedBorder)
        
        case .number, .currency:
            TextField("", text: Binding(
                get: { fieldValues[field.id] ?? "" },
                set: { fieldValues[field.id] = $0 }
            ))
            .textFieldStyle(.roundedBorder)
            
        case .date:
            DatePicker("", selection: Binding(
                get: { dateValues[field.id] ?? Date() },
                set: { dateValues[field.id] = $0 }
            ), displayedComponents: .date)
            .labelsHidden()
            
        case .datetime:
            DatePicker("", selection: Binding(
                get: { dateValues[field.id] ?? Date() },
                set: { dateValues[field.id] = $0 }
            ))
            .labelsHidden()
            
        case .toggle:
            Toggle("", isOn: Binding(
                get: { toggleValues[field.id] ?? false },
                set: { toggleValues[field.id] = $0 }
            ))
            .labelsHidden()
            
        case .dropdown(let options), .searchDropdown(let options):
            Picker("", selection: Binding(
                get: { fieldValues[field.id] ?? options.first ?? "" },
                set: { fieldValues[field.id] = $0 }
            )) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()
        }
    }
}

#Preview {
    NewDocumentWizardView()
        .environmentObject(CRMState())
}
