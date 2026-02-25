import Foundation
import SwiftUI

// MARK: - User Profile

struct UserProfile: Identifiable, Hashable {
    let id: UUID
    let name: String
    let role: String
    let organization: String
    
    static let mock = UserProfile(id: UUID(), name: "Max Socha", role: "CEO", organization: "Zen Crypted")
}

// MARK: - Inbox Folder

struct InboxFolder: Identifiable, Hashable {
    let id: String
    let name: String
    let iconName: String
    var incomingCounter: Int
    var badgeColor: Color
    
    static let mockFolders: [InboxFolder] = [
        InboxFolder(id: "for_me", name: "Inbox", iconName: "tray.and.arrow.down", incomingCounter: 12, badgeColor: .blue),
        InboxFolder(id: "for_execution", name: "Execution", iconName: "doc.badge.gearshape", incomingCounter: 5, badgeColor: .orange),
        InboxFolder(id: "for_approval", name: "Approval", iconName: "checkmark.seal", incomingCounter: 3, badgeColor: .green),
        InboxFolder(id: "for_agreement", name: "Agreement", iconName: "hand.raised", incomingCounter: 1, badgeColor: .teal),
        InboxFolder(id: "for_signing", name: "Signing", iconName: "signature", incomingCounter: 8, badgeColor: .purple),
        InboxFolder(id: "for_acknowledge", name: "Acknowledge", iconName: "eye", incomingCounter: 0, badgeColor: .gray),
        InboxFolder(id: "my_resolution", name: "Resolution", iconName: "text.badge.checkmark", incomingCounter: 2, badgeColor: .cyan),
        InboxFolder(id: "first_view", name: "Initial", iconName: "01.circle", incomingCounter: 4, badgeColor: .indigo),
        InboxFolder(id: "on_control", name: "Control", iconName: "lock.shield", incomingCounter: 0, badgeColor: .gray),
        InboxFolder(id: "urgent", name: "Urgent", iconName: "exclamationmark.triangle", incomingCounter: 7, badgeColor: .red),
        InboxFolder(id: "created_by_me", name: "Originated", iconName: "doc.badge.plus", incomingCounter: 0, badgeColor: .gray),
        InboxFolder(id: "rejected", name: "Rejected", iconName: "arrow.uturn.backward", incomingCounter: 1, badgeColor: .yellow),
        InboxFolder(id: "returned", name: "Returned", iconName: "arrow.uturn.forward", incomingCounter: 0, badgeColor: .gray),
        InboxFolder(id: "from_me", name: "Outbox", iconName: "paperplane", incomingCounter: 0, badgeColor: .gray),
        InboxFolder(id: "finished", name: "Finished", iconName: "archivebox", incomingCounter: 0, badgeColor: .gray),
        InboxFolder(id: "favorite", name: "Favorite", iconName: "star", incomingCounter: 2, badgeColor: .yellow)
    ]
}

// MARK: - Document

struct Document: Identifiable, Hashable {
    let id: UUID
    let type: String
    let initiator: String
    let addressedTo: String
    let stage: String
    let documentNumber: String
    let date: Date
    let correspondent: String
    let shortSummary: String
    let outgoingNumber: String
    
    var pdfURL: URL? // URL to the scanned pdf
    
    static let mockDocuments: [Document] = [
        Document(
            id: UUID(),
            type: "Contract",
            initiator: "Alice Smith",
            addressedTo: "John Doe",
            stage: "Pending Signature",
            documentNumber: "CTR-2026-001",
            date: Date().addingTimeInterval(-86400),
            correspondent: "Global Tech Inc",
            shortSummary: "Annual service agreement renewal.",
            outgoingNumber: "OUT-001-A"
        ),
        Document(
            id: UUID(),
            type: "Invoice",
            initiator: "Finance Dept",
            addressedTo: "John Doe",
            stage: "For Approval",
            documentNumber: "INV-5542",
            date: Date().addingTimeInterval(-172800),
            correspondent: "Office Supplies Co",
            shortSummary: "Q1 Office Supplies procurement.",
            outgoingNumber: "OUT-002-B"
        ),
        Document(
            id: UUID(),
            type: "Memo",
            initiator: "HR Dept",
            addressedTo: "All Employees",
            stage: "For Acknowledge",
            documentNumber: "MEM-2026-012",
            date: Date().addingTimeInterval(-3600),
            correspondent: "Internal",
            shortSummary: "Updated company policies regarding remote work.",
            outgoingNumber: "N/A"
        ),
        Document(
            id: UUID(),
            type: "Report",
            initiator: "Bob Jones",
            addressedTo: "John Doe",
            stage: "For Review",
            documentNumber: "REP-Q4-2025",
            date: Date().addingTimeInterval(-432000),
            correspondent: "Analytics Team",
            shortSummary: "Q4 2025 Performance Analytics Report.",
            outgoingNumber: "OUT-005-X"
        ),
        Document(
            id: UUID(),
            type: "Letter",
            initiator: "Legal Dept",
            addressedTo: "Jane F.",
            stage: "Urgent",
            documentNumber: "LGL-992",
            date: Date(),
            correspondent: "External Counsel",
            shortSummary: "Response to compliance inquiry.",
            outgoingNumber: "OUT-088-L"
        )
    ]
}

// MARK: - Dynamic Templates

enum FormFieldType: Hashable, Sendable {
    case text
    case date
    case datetime
    case number
    case currency
    case toggle
    case dropdown(options: [String])
    case searchDropdown(options: [String])
}

struct FormField: Identifiable, Hashable {
    let id: UUID
    let title: String
    let type: FormFieldType
    let isRequired: Bool
    
    init(id: UUID = UUID(), title: String, type: FormFieldType, isRequired: Bool = false) {
        self.id = id
        self.title = title
        self.type = type
        self.isRequired = isRequired
    }
}

struct DocumentTemplate: Identifiable, Hashable {
    let id: UUID = UUID()
    let templateName: String
    let iconName: String
    let requiredFields: [FormField]
    let description: String
}

struct TemplateCategory: Identifiable, Hashable {
    let id: UUID = UUID()
    let categoryName: String
    let iconName: String
    let templates: [DocumentTemplate]
    
    static let mockCategories: [TemplateCategory] = [
        TemplateCategory(
            categoryName: "Наказ №370",
            iconName: "doc.text.fill",
            templates: [
                DocumentTemplate(
                    templateName: "Директива",
                    iconName: "lock.doc.fill",
                    requiredFields: [
                        FormField(title: "Company Name", type: .text, isRequired: true),
                        FormField(title: "Counterparty Name", type: .text, isRequired: true),
                        FormField(title: "Effective Date", type: .date, isRequired: true),
                        FormField(title: "Jurisdiction", type: .dropdown(options: ["Delaware", "New York", "London", "Cyprus"]), isRequired: true)
                    ],
                    description: "Standard Non-Disclosure Agreement for ZEN CRYPTED."
                ),
                DocumentTemplate(
                    templateName: "Бойове розпорядження",
                    iconName: "person.text.rectangle.fill",
                    requiredFields: [
                        FormField(title: "Employee Name", type: .text, isRequired: true),
                        FormField(title: "Role", type: .searchDropdown(options: ["Software Engineer", "Product Manager", "Designer", "Security Analyst"]), isRequired: true),
                        FormField(title: "Start Date", type: .date, isRequired: true),
                        FormField(title: "Salary (USD)", type: .currency, isRequired: true),
                        FormField(title: "Equity Grant", type: .toggle, isRequired: false)
                    ],
                    description: "Standard employment agreement signed by Maxim Sokhatsky."
                ),
                DocumentTemplate(
                    templateName: "Доповідна записка",
                    iconName: "briefcase.fill",
                    requiredFields: [
                        FormField(title: "Vendor Name", type: .text, isRequired: true),
                        FormField(title: "Service Type", type: .dropdown(options: ["Cloud Hosting", "IT Support", "Consulting", "Marketing"]), isRequired: true),
                        FormField(title: "Monthly Value", type: .currency, isRequired: true),
                        FormField(title: "Review Date", type: .datetime, isRequired: false)
                    ],
                    description: "Service Level Agreement for external contractors."
                )
            ]
        ),
        TemplateCategory(
            categoryName: "Постанова №55",
            iconName: "note.text",
            templates: [
                DocumentTemplate(
                    templateName: "Звернення громадян",
                    iconName: "megaphone.fill",
                    requiredFields: [
                        FormField(title: "Subject", type: .text, isRequired: true),
                        FormField(title: "Date", type: .date, isRequired: true),
                        FormField(title: "Target Department", type: .dropdown(options: ["All Company", "Engineering", "Sales", "Executive"]), isRequired: true)
                    ],
                    description: "Official internal announcement from Maxim Sokhatsky."
                ),
                DocumentTemplate(
                    templateName: "Внутрішній документ",
                    iconName: "exclamationmark.shield.fill",
                    requiredFields: [
                        FormField(title: "Incident Type", type: .searchDropdown(options: ["Data Breach", "DDoS Attack", "Malware", "Phishing"]), isRequired: true),
                        FormField(title: "Time Detected", type: .datetime, isRequired: true),
                        FormField(title: "Severity", type: .dropdown(options: ["Low", "Medium", "High", "Critical"]), isRequired: true),
                        FormField(title: "Resolved", type: .toggle, isRequired: false)
                    ],
                    description: "Internal report for tracking security breaches."
                )
            ]
        )
    ]
}
