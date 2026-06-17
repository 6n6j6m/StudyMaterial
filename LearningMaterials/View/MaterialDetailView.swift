import SwiftUI
internal import UniformTypeIdentifiers
import QuickLook


struct MaterialDetailView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var material: StudyMaterial
    @State private var presentImporter: Bool = false
    @State private var showDeleteAlert: Bool = false
//    @State var imageView = UIImageView()
    
    @Bindable var studyViewModel: StudyMaterialViewModel
    @Bindable var fileViewModel: FileMaterialViewModel
    
    @State private var selectedURL = URL(string: "")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Study Status")
                .font(.headline)
            
            StatusSelectorView(status: $material.status, colorScheme: colorScheme)
            
            
            Text("Overview & Description")
                .font(.headline)
            
            Text(material.deskripsi)
                .font(.body)
            
            Divider()
            
            MaterialHeader(presentImporter: $presentImporter)
            
            // Daftar materiny
            MaterialListView(
                sumber: $material.sumber,
                colorScheme: colorScheme,
                onDeleteTap: { file in // masukkin proses dari fungsinya
                    fileViewModel.fileToDelete = file
                    showDeleteAlert = true
                },
                fileViewModel: fileViewModel, selectedURL: $selectedURL
            )
        }
        .alert("Delete Chat", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                fileViewModel.deletePdf(material: material)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this chat? This action cannot be undone.")
        }
        .sheet(isPresented: $fileViewModel.showSummary, content: {
            SummaryView(fileViewModel: fileViewModel)
        })
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(Color.primaryBG)
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
                    let FilePDF = fileViewModel.savePdf(topic: material.topic, url: selectedUrl)
                    print(type(of: FilePDF)) // cek outputnya
                    guard FilePDF != nil else { return }
                    print("Data: \(String(describing: FilePDF))") // debug muncul apa engga
                    material.sumber.append(FilePDF!)
                }
                
            case .failure(let error):
                print("Gagal mengimpor file: \(error.localizedDescription)")
            }
        }
    }
}

struct StatusSelectorView: View {
    
    @Binding var status: StudyStatus
    let colorScheme: ColorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            statusButton("Studying", isActive: status == .studying)
            statusButton("Planned", isActive: status == .planned)
            statusButton("Completed", isActive: status == .completed)
        }
        .frame(maxWidth: .infinity, maxHeight: 40)
        .background(Color.primaryBlue)
        .cornerRadius(100)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
    }
    
    private func statusButton(_ title: String, isActive: Bool) -> some View {
        Text(title)
            .frame(width: 120, height: 30)
            .font(.headline)
            .background(isActive ? Color.white : Color.clear)
            .foregroundStyle(isActive ? .black : (colorScheme == .dark ? .black : .white))
            .cornerRadius(100)
    }
}

struct MaterialListView: View {
    
    @Binding var sumber: [FileMaterial]
    let colorScheme: ColorScheme
    let onDeleteTap: (FileMaterial) -> Void
    let fileViewModel: FileMaterialViewModel
//    let imageView: UIImageView
    @Binding var selectedURL: URL?
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(sumber, id: \.self) { file in
                    //Check the extension if its image
                    if file.fileExtension == "jpg" || file.fileExtension == "png" || file.fileExtension == "jpeg" {
                        Button {
                            selectedURL = file.fileURL
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(file.fileName)
                                        .font(.caption.bold())
                                        .padding(10)
                                    
                                    Text("\(Double(file.fileSize) / 1_048_576, specifier: "%.2f") MB")
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                }
                                .padding(10)
                                
                                Spacer()
                                
                                Menu {
                                    Button("Delete") {
                                        onDeleteTap(file)
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .padding(10)
                                }
                            }
                            .frame(width: 365, height: 80, alignment: .topLeading)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.primaryBlue)
                            )
                            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
                            .foregroundStyle(colorScheme == .dark ? .black : .white)

                        }
                        .quickLookPreview($selectedURL)
                        
                    } else {
                        //bisa juga pake pdf viewer usin navigation link
                        Button {
//                            PDFViewer(url: url)
                            selectedURL = file.fileURL
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(file.fileName)
                                        .font(.caption.bold())
                                        .padding(10)
                                    
                                    Text("\(Double(file.fileSize) / 1_048_576, specifier: "%.2f") MB")
                                        .font(.caption)
                                        .padding(.horizontal, 10)                                }
                                .padding(10)
                                
                                Spacer()
                                
                                Menu {
                                    Button("Delete") {
                                        onDeleteTap(file)
                                    }
                                    
                                    if file.fileExtension == "pdf" {
                                        Button("Summarize this") {
                                            Task{
                                                await fileViewModel.summarizePdf(file: file)
                                            }
                                        }
                                    }
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .padding(10)
                                }
                            }
                            .frame(width: 365, height: 80, alignment: .topLeading)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.primaryBlue)
                            )
                            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
                            .foregroundStyle(colorScheme == .dark ? .black : .white)
                        }
                        .quickLookPreview($selectedURL)
                    }
                }
            }
        }
    }
}

struct MaterialHeader: View {
    
    @Binding var presentImporter: Bool
    
    var body: some View {
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
    }
}

#Preview {
    @Previewable @State var material = StudyMaterial(topic: "SwiftUI", deskripsi: "YouTube", status: .studying, sumber: [])
    @Previewable @State var studyViewModel = StudyMaterialViewModel()
    @Previewable @State var fileViewModel = FileMaterialViewModel()
//    @Previewable @State var imageView = UIImageView()
    NavigationStack {
        MaterialDetailView(material: material, studyViewModel: studyViewModel, fileViewModel: fileViewModel)
    }
}
