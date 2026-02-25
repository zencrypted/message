import SwiftUI

struct CRMMainView: View {
    @EnvironmentObject var state: CRMState
    @Environment(\.openWindow) private var openWindow
    
    // Sort orders for table
    @State private var sortOrder = [KeyPathComparator(\Document.date, order: .reverse)]
    
    var body: some View {
        NavigationSplitView {
            sidebar
        } content: {
            tableColumn
        } detail: {
            detailColumn
        }
        .navigationSplitViewStyle(.balanced)
        .crmBackground()
    }
    
    @ViewBuilder
    private var sidebar: some View {
        List(selection: $state.selectedInbox) {
            Section(header: Text("Inboxes").foregroundColor(CRMTheme.secondaryText)) {
                ForEach(InboxFolder.mockFolders) { folder in
                    NavigationLink(value: folder) {
                        HStack {
                            Image(systemName: folder.iconName)
                                .frame(width: 24)
                            Text(folder.name)
                            Spacer()
                            if folder.incomingCounter > 0 {
                                Text("\(folder.incomingCounter)")
                                    .font(.caption.bold())
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(folder.badgeColor)
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                        .foregroundColor(CRMTheme.primaryText)
                    }
                    .contextMenu {
                        Button {
                            // Trigger new document creation for this inbox
                            state.selectedInbox = folder
                            state.selectedTab = 1
                        } label: {
                            Label("New Document", systemImage: "doc.badge.plus")
                        }
                        
                        Button {
                            // macOS native way to handle "New Tab" requests
                            openWindow(id: "inboxWindow", value: folder.id)
                        } label: {
                            Label("Open in New Tab", systemImage: "plus.rectangle.on.rectangle")
                        }
                    }
                    .listRowBackground(state.selectedInbox?.id == folder.id ? CRMTheme.secondaryBackground : CRMTheme.primaryBackground)
                }
            }
        }
        .navigationSplitViewColumnWidth(min: 100, ideal: 250, max: 300)
        .background(CRMTheme.primaryBackground)
        .scrollContentBackground(.hidden)
    }
    
    @ViewBuilder
    private var tableColumn: some View {
        VStack(spacing: 0) {
            // Filter Logic
            let filteredDocs = Document.mockDocuments.filter { doc in
                (state.typeFilter.isEmpty || doc.type.localizedCaseInsensitiveContains(state.typeFilter)) &&
                (state.initiatorFilter.isEmpty || doc.initiator.localizedCaseInsensitiveContains(state.initiatorFilter)) &&
                (state.addressedToFilter.isEmpty || doc.addressedTo.localizedCaseInsensitiveContains(state.addressedToFilter)) &&
                (state.stageFilter.isEmpty || doc.stage.localizedCaseInsensitiveContains(state.stageFilter)) &&
                (state.numberFilter.isEmpty || doc.documentNumber.localizedCaseInsensitiveContains(state.numberFilter)) &&
                (state.correspondentFilter.isEmpty || doc.correspondent.localizedCaseInsensitiveContains(state.correspondentFilter)) &&
                (state.summaryFilter.isEmpty || doc.shortSummary.localizedCaseInsensitiveContains(state.summaryFilter)) &&
                (state.outNumberFilter.isEmpty || doc.outgoingNumber.localizedCaseInsensitiveContains(state.outNumberFilter))
            }
            .sorted(using: sortOrder)
            
            // Toolbar equivalent for table actions
            HStack {
                Text(state.selectedInbox?.name ?? "Select an Inbox")
                    .font(.title2.bold())
                    .foregroundColor(CRMTheme.primaryText)
                
                Spacer()
                
                Button(action: {
                    let allIds = Set(filteredDocs.map(\.id))
                    if state.selectedDocuments == allIds {
                        state.selectedDocuments.removeAll()
                    } else {
                        state.selectedDocuments = allIds
                    }
                }) {
                    Label(state.selectedDocuments.count == filteredDocs.count && !filteredDocs.isEmpty ? "Deselect All" : "Select All", systemImage: "checklist")
                }
                
                Button(action: {}) {
                    Label("Sign", systemImage: "signature")
                }
                Menu {
                    ForEach(DocumentColumn.allCases) { column in
                        Button {
                            if state.visibleColumns.contains(column) {
                                state.visibleColumns.remove(column)
                            } else {
                                state.visibleColumns.insert(column)
                            }
                        } label: {
                            HStack {
                                Text(column.rawValue)
                                if state.visibleColumns.contains(column) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Label("Columns", systemImage: "tablecells")
                }
                
               // Button(action: {
                    // Open Wizard in the Forms Tab
                 //   state.selectedTab = 1
               // }) {
                  //  Label("New Document", systemImage: "doc.badge.plus")
              //  }
            }
            .padding()
            .background(CRMTheme.secondaryBackground.opacity(0.3))
            .border(CRMTheme.border, width: 0.0)
            
            // Per-Column Filter Bar
            HStack(spacing: 8) {
                Spacer().frame(width: 30) // Offset for checkbox column
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundColor(CRMTheme.secondaryText)
                if state.visibleColumns.contains(.type) { TextField("Type", text: $state.typeFilter).textFieldStyle(.roundedBorder) }
                if state.visibleColumns.contains(.initiator) { TextField("Initiator", text: $state.initiatorFilter).textFieldStyle(.roundedBorder) }
                if state.visibleColumns.contains(.addressedTo) { TextField("To...", text: $state.addressedToFilter).textFieldStyle(.roundedBorder) }
                if state.visibleColumns.contains(.stage) { TextField("Stage", text: $state.stageFilter).textFieldStyle(.roundedBorder) }
                if state.visibleColumns.contains(.number) { TextField("Number", text: $state.numberFilter).textFieldStyle(.roundedBorder) }
                if state.visibleColumns.contains(.date) { Spacer().frame(width: 80) /* Placeholder for Date since it's not filtered directly by text here usually, or add a text filter if desired */ }
                if state.visibleColumns.contains(.correspondent) { TextField("Correspondent", text: $state.correspondentFilter).textFieldStyle(.roundedBorder) }
                if state.visibleColumns.contains(.summary) { TextField("Summary", text: $state.summaryFilter).textFieldStyle(.roundedBorder) }
                if state.visibleColumns.contains(.outNumber) { TextField("Out Num", text: $state.outNumberFilter).textFieldStyle(.roundedBorder) }
            }
            .padding()
            .background(CRMTheme.secondaryBackground.opacity(0.3))
            .border(CRMTheme.border, width: 0.0)

            // Advanced Table with specific requested columns supporting multi-selection
            Table(filteredDocs, selection: $state.selectedDocuments, sortOrder: $sortOrder) {
                TableColumn("") { doc in
                    Toggle("", isOn: Binding(
                        get: { state.selectedDocuments.contains(doc.id) },
                        set: { isSelected in
                            if isSelected {
                                state.selectedDocuments.insert(doc.id)
                            } else {
                                state.selectedDocuments.remove(doc.id)
                            }
                        }
                    ))
                    .labelsHidden()
                }
                .width(20)
                
                if state.visibleColumns.contains(.type) {
                    TableColumn("Type", value: \.type)
                }
                if state.visibleColumns.contains(.initiator) {
                    TableColumn("Initiator", value: \.initiator)
                }
                if state.visibleColumns.contains(.addressedTo) {
                    TableColumn("Addressed to", value: \.addressedTo)
                }
                if state.visibleColumns.contains(.stage) {
                    TableColumn("Stage", value: \.stage)
                }
                if state.visibleColumns.contains(.number) {
                    TableColumn("Number", value: \.documentNumber)
                }
                if state.visibleColumns.contains(.date) {
                    TableColumn("Date", value: \.date) { doc in
                        Text(doc.date, style: .date)
                    }
                }
                if state.visibleColumns.contains(.correspondent) {
                    TableColumn("Correspondent", value: \.correspondent)
                }
                if state.visibleColumns.contains(.summary) {
                    TableColumn("Summary", value: \.shortSummary)
                }
                if state.visibleColumns.contains(.outNumber) {
                    TableColumn("Out Number", value: \.outgoingNumber)
                }
            }
            #if os(macOS)
            .tableStyle(.bordered)
            #endif
        }
        .navigationSplitViewColumnWidth(min: 100, ideal: 800)
    }
    
    @ViewBuilder
    private var detailColumn: some View {
        if state.selectedDocuments.count == 1, let firstId = state.selectedDocuments.first, let document = Document.mockDocuments.first(where: { $0.id == firstId }) {
            DocumentDetailView(document: document)
        } else if state.selectedDocuments.count > 1 {
            VStack(spacing: 20) {
                Image(systemName: "square.stack.3d.up.fill")
                    .font(.system(size: 60))
                    .foregroundColor(CRMTheme.accent)
                Text("\(state.selectedDocuments.count) Documents Selected")
                    .font(.title)
                    .foregroundColor(CRMTheme.primaryText)
                
                Button("Batch Sign") {
                    // Logic to batched sign
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .crmBackground()
        } else {
            VStack {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 60))
                    .foregroundColor(CRMTheme.secondaryText)
                Text("Select a document to view details")
                    .foregroundColor(CRMTheme.secondaryText)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .crmBackground()
        }
    }
}
