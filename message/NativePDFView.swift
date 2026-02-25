import SwiftUI
import PDFKit

#if os(macOS)
struct NativePDFView: NSViewRepresentable {
    let url: URL?
    let defaultData: Data?

    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        loadDocument(into: pdfView)
        return pdfView
    }

    func updateNSView(_ pdfView: PDFView, context: Context) {
        loadDocument(into: pdfView)
    }
    
    private func loadDocument(into pdfView: PDFView) {
        if let url = url, let document = PDFDocument(url: url) {
            pdfView.document = document
        } else if let defaultData = defaultData, let document = PDFDocument(data: defaultData) {
            pdfView.document = document
        } else {
            pdfView.document = nil
        }
    }
}
#else
struct NativePDFView: UIViewRepresentable {
    let url: URL?
    let defaultData: Data?

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        loadDocument(into: pdfView)
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
         loadDocument(into: pdfView)
    }
    
    private func loadDocument(into pdfView: PDFView) {
        if let url = url, let document = PDFDocument(url: url) {
            pdfView.document = document
        } else if let defaultData = defaultData, let document = PDFDocument(data: defaultData) {
            pdfView.document = document
        } else {
            pdfView.document = nil
        }
    }
}
#endif
