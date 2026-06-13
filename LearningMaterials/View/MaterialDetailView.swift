//
//  LearningmaterialDetailView.swift
//  MyBookShelf
//

import SwiftUI
internal import UniformTypeIdentifiers

struct MaterialDetailView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var material: StudyMaterial
    @State var presentImporter: Bool = false
    @Bindable var viewModel: StudyMaterialViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Study Status")
                .font(.headline)
            
            HStack(alignment: .center, spacing: 0) {
                Text("Studying")
                    .frame(width: 120, height: 30, alignment: .center)
                    .font(.headline)
                    .background{
                        switch material.status {
                        case .studying:
                            Color.white
                                .foregroundStyle(Color.red)
                        case .completed:
                            Color.primaryBlue
                        case .planned:
                            Color.primaryBlue
                        }
                    }
                    .foregroundStyle(material.status == .studying ? .black : colorScheme == .dark ? .black : .white)
                    .cornerRadius(10)
                
                Text("Planned")
                    .frame(width: 120, height: 30, alignment: .center)
                    .font(.headline)
                    .background{
                        switch material.status {
                        case .studying:
                            Color.primaryBlue
                        case .completed:
                            Color.primaryBlue
                        case .planned:
                            Color.white
                        }
                    }
                    .foregroundStyle(material.status == .planned ? .black : colorScheme == .dark ? .black : .white)
                    .cornerRadius(10)
                
                
                Text("Completed")
                    .frame(width: 120, height: 30, alignment: .center)
                    .font(.headline)
                    .background{
                        switch material.status {
                        case .studying:
                            Color.primaryBlue
                        case .completed:
                            Color.white
                        case .planned:
                            Color.primaryBlue
                        }
                    }
                    .foregroundStyle(material.status == .completed ? .black : colorScheme == .dark ? .black : .white)
                    .cornerRadius(10)
                
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(Color.primaryBlue)
            .cornerRadius(10)
            
            Text("Overview & Description")
                .font(.headline)
            
            Text(material.deskripsi)
                .font(.body)
            
            Divider()
            
            HStack {
                Text("Materials in this topic")
                    .font(.headline)
                
                Spacer()
                
                Button{
                    presentImporter.toggle()
                } label: {
                    Label("Add material", systemImage: "plus")
                }
            }
            .frame(maxWidth: .infinity)
            
            List(material.sumber, id: \.self){ url in
                NavigationLink {
                    PDFViewer(url: url)
                } label: {
                    Text("\(url.lastPathComponent)")
                }
            }
            .listStyle(.plain)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .navigationTitle(material.topic)
        .fileImporter(isPresented: $presentImporter, allowedContentTypes: [.pdf, .image], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                guard let selectedUrl = urls.last else { return }
                
                // Bikin akses buat filenya
                let gotAccess = selectedUrl.startAccessingSecurityScopedResource()
                defer {
                    if gotAccess {
                        selectedUrl.stopAccessingSecurityScopedResource()
                    }
                }
                
                do {
                    let dataPdf = try Data(contentsOf: selectedUrl)
                    
                    let namaFileAsli = selectedUrl.lastPathComponent
                    let urlFilePDF = viewModel.savePdf(fileName: namaFileAsli, pdfData: dataPdf)
                    material.sumber.append(urlFilePDF ?? URL(string: "")!)
                    
                } catch {
                    print("Gagal membaca data file luar: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print("Gagal mengimpor file: \(error.localizedDescription)")
            }
        }

    }
}

#Preview {
    @Previewable @State var material = StudyMaterial(topic: "SwiftUI", deskripsi: "YouTube", status: .studying, sumber: [])
    @Previewable @State var viewModel = StudyMaterialViewModel()
    NavigationStack {
        MaterialDetailView(material: material, viewModel: viewModel)
    }
}
