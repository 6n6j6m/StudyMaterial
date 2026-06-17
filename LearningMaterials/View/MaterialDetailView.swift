import SwiftUI
internal import UniformTypeIdentifiers
import QuickLook


struct MaterialDetailView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.openURL) private var openURL
    @State var material: StudyMaterial
    @State private var showDeleteAlert: Bool = false
//    @State var imageView = UIImageView()
    
    @Bindable var studyViewModel: StudyMaterialViewModel
    @Bindable var fileViewModel: FileMaterialViewModel
    
    @State private var urlToView = URL(string: "")
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Study Status")
                .font(.headline)
                .foregroundStyle(.primary)
            
            StatusSelectorView(status: $material.status, colorScheme: colorScheme)
            
            Text("Overview & Description")
                .fixedSize(horizontal: false, vertical: true)
                .font(.headline)
            
            Text(material.deskripsi)
                .font(.body)
            
            Divider()
            
            MaterialHeader(fileViewModel: fileViewModel)
            
            // Daftar materiny
            MaterialListView(
                sumber: $material.sumber,
                openURL: openURL,
                colorScheme: colorScheme,
                onDeleteTap: { file in // masukkin proses dari fungsinya
                    fileViewModel.fileToDelete = file
                    showDeleteAlert = true
                },
                fileViewModel: fileViewModel, urlToView: $urlToView
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
        .fileImporter(isPresented: $fileViewModel.presentImporter, allowedContentTypes: [.pdf, .image], allowsMultipleSelection: false) { result in
            addMoreFile(result: result)
        }
    }
    
    private func addMoreFile(result: Result<[URL], any Error>) {
        switch result {
        case .success(let urls):
            guard let selectedUrl = urls.first else { return }
            
            // Bikin akses buat filenya
            // Tapi kalo dibuild ulang, akses ke filenya ilang, still figurin on how to handlenya
            let gotAccess = selectedUrl.startAccessingSecurityScopedResource()
            // save it into info plist
            
            defer {
                if gotAccess {
                    selectedUrl.stopAccessingSecurityScopedResource()
                }
            }
            
            do {
                print("Start import")
                let FilePDF = fileViewModel.savePdf(topic: material.topic, url: selectedUrl)
                print(type(of: FilePDF)) // cek outputnya
                guard FilePDF != nil else { return print("Gagal")}
                print("Data: \(FilePDF)") // debug muncul apa engga
                material.sumber.append(FilePDF!)
                print(type(of: material.sumber))
            }
            
        case .failure(let error):
            print("Gagal mengimpor file: \(error.localizedDescription)")
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
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: 120, height: 30)
            .font(.headline)
            .background(isActive ? Color.white : Color.clear)
            .foregroundStyle(isActive ? .black : (colorScheme == .dark ? .black : .white))
            .cornerRadius(100)
        }
}

struct MaterialListView: View {
    
    @Binding var sumber: [FileMaterial]
    let openURL: OpenURLAction
    let colorScheme: ColorScheme
    let onDeleteTap: (FileMaterial) -> Void
    let fileViewModel: FileMaterialViewModel
//    let imageView: UIImageView
    @Binding var urlToView: URL?
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(sumber, id: \.self) { file in
                    //Check the extension if its image
                    if file.fileExtension == "URL" {
                        Button {
                            openURL(file.fileURL)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(file.fileName)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.caption.bold())
                                        .padding(10)
                                    
                                    Text("\(Double(file.fileSize) / 1_048_576, specifier: "%.2f") MB")
                                        .fixedSize(horizontal: false, vertical: true)
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
//                        .quickLookPreview($urlToView)
                        
                    } else {
                        //bisa juga pake pdf viewer usin navigation link
                        Button {
//                            PDFViewer(url: url)
                            urlToView = file.fileURL
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(file.fileName)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.caption.bold())
                                        .padding(10)
                                    
                                    Text("\(Double(file.fileSize) / 1_048_576, specifier: "%.2f") MB")
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                }
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
                        .quickLookPreview($urlToView)
                    }
                }
            }
        }
    }
}

struct MaterialHeader: View {
    
    @Bindable var fileViewModel: FileMaterialViewModel
    
    var body: some View {
        HStack {
            Text("Materials in this topic")
                .fixedSize(horizontal: false, vertical: true)
                .font(.headline)
            
            Spacer()
            
            Button{
                fileViewModel.presentImporter.toggle()
            } label: {
                Label("Add material", systemImage: "plus")
                    .fixedSize(horizontal: false, vertical: true)
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
