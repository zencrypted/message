import SwiftUI

struct DocumentDetailView: View {
    let document: Document
    
    var body: some View {
        // Here we simulate the split within the detail view to show PDF alongside Form
        // This is the "3rd column" logic which internally splits into 2 panes.
        GeometryReader { proxy in
            HStack(spacing: 0) {
                // Left pane: PDF Viewer using native PDFKit
                VStack(spacing: 0) {
                    Text("Native PDF Viewer - \(document.documentNumber)")
                        .font(.headline)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(CRMTheme.secondaryBackground)
                        .foregroundColor(CRMTheme.primaryText)
                    
                    NativePDFView(url: document.pdfURL, defaultData: Data(base64Encoded: dummyPDFBase64))
                        .background(Color.gray.opacity(0.2)) // Give some visual border for the document
                        .border(CRMTheme.border, width: 0.0)
                }
                .frame(width: proxy.size.width * 0.6)
                .background(CRMTheme.invertedBackground)
                
                Divider()
                    .background(CRMTheme.border)
                
                // Right pane: Form / Controls
                VStack(alignment: .leading, spacing: 20) {
                    Text("Document Form")
                        .font(.title2.bold())
                        .crmTextStyle()
                    
                    Group {
                        detailRow(title: "Type", value: document.type)
                        detailRow(title: "Initiator", value: document.initiator)
                        detailRow(title: "Addressed To", value: document.addressedTo)
                        detailRow(title: "Stage", value: document.stage)
                        detailRow(title: "Summary", value: document.shortSummary)
                    }
                    
                    Spacer()
                    
                    // Form Actions
                    HStack {
                        Button("Approve") {}
                            .buttonStyle(.borderedProminent)
                        Button("Reject") {}
                            .buttonStyle(.bordered)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .frame(width: proxy.size.width * 0.4, alignment: .topLeading)
                .crmBackground()
            }
        }
    }
    
    private func detailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(CRMTheme.secondaryText)
            Text(value)
                .font(.body)
                .crmTextStyle()
            Divider()
                .background(CRMTheme.border)
        }
    }
    
    // Base64 encoded PDF with text "Scanned Document Demo" for mock previews
    private let dummyPDFBase64 = """
    JVBERi0xLjcKCjEgMCBvYmogICUgZW50cnkgcG9pbnQKPDwKICAvVHlwZSAvQ2F0YWxvZwogIC9QYWdlcyAyIDAgUgo+PgplbmRvYmoKCjIgMCBvYmoKPDwKICAvVHlwZSAvUGFnZXMKICAvTWVkaWFCb3ggWyAwIDAgNjEyIDc5MiBdCiAgL0NvdW50IDEKICAvS2lkcyBbIDMgMCBSIF0KPj4KZW5kb2JqCgozIDAgb2JqCjw8CiAgL1R5cGUgL1BhZ2UKICAvUGFyZW50IDIgMCBSCiAgL1Jlc291cmNlcyA8PAogICAgL0ZvbnQgPDwKICAgICAgL0YxIDQgMCBSCgkJPj4KICA+PgogIC9Db250ZW50cyA1IDAgUgo+PgplbmRvYmoKCjQgMCBvYmoKPDwKICAvVHlwZSAvRm9udAogIC9TdWJ0eXBlIC9UeXBlMQogIC9CYXNlRm9udCAvSGVsdmV0aWNhLUJvbGQKICAvRW5jb2RpbmcgL01hY1JvbWFuRW5jb2RpbmcKPj4KZW5kb2JqCgo1IDAgb2JqCjw8IC9MZW5ndGggNjYgPj4Kc3RyZWFtCkJUCjIwMCA3MDAgVEQKL0YxIDI0IFRmCihTY2FubmVkIERvY3VtZW50IERlbW8pIFRqCkVUCmVuZHN0cmVhbQplbmRvYmoKeHJlZgowIDYKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwMDEwIDAwMDAwIG4gCjAwMDAwMDAwNzkgMDAwMDAgbiAKMDAwMDAwMDE3MyAwMDAwMCBuIAowMDAwMDAwMzAxIDAwMDAwIG4gCjAwMDAwMDA0MTUgMDAwMDAgbiAKdHJhaWxlcgo8PAogIC9TaXplIDYKICAvUm9vdCAxIDAgUgo+PgpzdGFydHhyZWYKNTMyCiUlRU9GCg==
    """
}
