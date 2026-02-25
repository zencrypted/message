import SwiftUI
import PDFKit

#if os(macOS)
struct PDFKitView: NSViewRepresentable {
    let url: URL
    var template: DocumentTemplate?
    var fieldValues: [UUID: String]
    var dateValues: [UUID: Date]

    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        pdfView.pageShadowsEnabled = true
        return pdfView
    }

    func updateNSView(_ pdfView: PDFView, context: Context) {
        if let document = PDFDocument(url: url) {
            pdfView.document = document
            
            // Clear existing annotations
            if let page = document.page(at: 0) {
                for annotation in page.annotations {
                    page.removeAnnotation(annotation)
                }
                
                // Add new annotations for each field
                if let template = template {
                    // Simple demo logic: Stack annotations vertically on the first page
                    var yOffset: CGFloat = page.bounds(for: .mediaBox).height - 100
                    
                    for field in template.requiredFields {
                        let textToDisplay: String
                        
                        // Extract dynamic value matching form Type
                        if field.type == .date || field.type == .datetime {
                            if let date = dateValues[field.id] {
                                let formatter = DateFormatter()
                                formatter.dateStyle = .medium
                                formatter.timeStyle = field.type == .datetime ? .short : .none
                                textToDisplay = formatter.string(from: date)
                            } else {
                                textToDisplay = "---"
                            }
                        } else if field.type == .toggle {
                            textToDisplay = "N/A"
                        } else {
                            textToDisplay = fieldValues[field.id] ?? "---"
                        }
                        
                        let combinedText = "\(field.title): \(textToDisplay)"
                        
                        // Create a floating text annotation
                        let annotation = PDFAnnotation(
                            bounds: CGRect(x: 50, y: yOffset, width: 300, height: 20),
                            forType: .freeText,
                            withProperties: nil
                        )
                        annotation.contents = combinedText
                        annotation.font = NSFont.systemFont(ofSize: 14)
                        annotation.fontColor = .red
                        annotation.color = .clear // Transparent background
                        
                        page.addAnnotation(annotation)
                        yOffset -= 30
                    }
                }
            }
        }
    }
}
#else
struct PDFKitView: UIViewRepresentable {
    let url: URL
    var template: DocumentTemplate?
    var fieldValues: [UUID: String]
    var dateValues: [UUID: Date]

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        pdfView.pageShadowsEnabled = true
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        if let document = PDFDocument(url: url) {
            pdfView.document = document
            
            // Simple overlay logic omitted for iOS UIView for brevity,
            // but structure works identically with UIFont and UIColor.
        }
    }
}
#endif
