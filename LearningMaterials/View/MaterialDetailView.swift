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
                        case .completed:
                            Color.white.opacity(0)
                        case .planned:
                            Color.white.opacity(0)
                        }
                    }
                    .foregroundStyle(material.status == .studying ? .black : colorScheme == .dark ? .black : .white)
                    .cornerRadius(100)
                
                Text("Planned")
                    .frame(width: 120, height: 30, alignment: .center)
                    .font(.headline)
                    .background{
                        switch material.status {
                        case .studying:
                            Color.white.opacity(0)
                        case .completed:
                            Color.white.opacity(0)
                        case .planned:
                            Color.white
                        }
                    }
                    .foregroundStyle(material.status == .planned ? .black : colorScheme == .dark ? .black : .white)
                    .cornerRadius(100)
                
                
                Text("Completed")
                    .frame(width: 120, height: 30, alignment: .center)
                    .font(.headline)
                    .background{
                        switch material.status {
                        case .studying:
                            Color.white.opacity(0)
                        case .completed:
                            Color.white
                        case .planned:
                            Color.white.opacity(0)
                        }
                    }
                    .foregroundStyle(material.status == .completed ? .black : colorScheme == .dark ? .black : .white)
                    .cornerRadius(100)
                
            }
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(Color.primaryBlue)
            .cornerRadius(100)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20.0))
            
            
            
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
            
            ScrollView {
                LazyVStack{
                    ForEach(material.sumber, id: \.self){ url in
                        NavigationLink {
                            PDFViewer(url: url)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(url.lastPathComponent)")
                                        .font(.system(.caption, weight: .bold))
                                    
                                    Spacer()
                                    
                                    Text("Sizeaaaaaaaaaaaaaa")
                                        .font(.system(.caption))
                                    
                                }
                                .padding(10)
                                
                                Spacer()
                                
                                Image(systemName: "ellipsis")
                                    .padding(10)
                            }
                        }
                        .padding(10)
                        .frame(width: 365, height: 80, alignment: .topLeading)
                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20.0))
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray.opacity(0.9))
                        )
                    }
                }
            }
                        
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
                    let urlFilePDF = viewModel.savePdf(fileName: namaFileAsli, pdfData: dataPdf, topic: material.topic)
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
