//
//  PDFView.swift
//  LearningMaterials
//
//  Created by Muhammad Najmi Rahmani  on 12/06/26.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let url: URL
    
    func updateUIView(_ uiView: PDFView, context: Context) {
            if let document = PDFDocument(url: url) {
                print("Bisa memuat dokumen dari URL: \(url)")
                uiView.document = document
            } else {
                print("Gagal memuat dokumen dari URL: \(url)")
            }
        }
    
    func makeUIView(context: Context) -> PDFView {
        _ = url.startAccessingSecurityScopedResource()

        let pdfView = PDFView()
        
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        pdfView.document = PDFDocument(url: url)
        
        return pdfView
    }
}


struct PDFViewer: View {
    var url: URL
    
    var body: some View {
        PDFKitView(url: url)
    }
}

#Preview {
    @Previewable @State var url: URL = URL(string: "https://www.google.com")!
    PDFViewer(url: url)
}
