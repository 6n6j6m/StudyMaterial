//
//  AddMaterialView.swift
//  MyBookShelf
//

import SwiftUI
import SwiftData
internal import UniformTypeIdentifiers

struct AddMaterialView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext // Akses SwiftData Context
    
    @Bindable var studyViewModel: StudyMaterialViewModel
    @Bindable var fileViewModel: FileMaterialViewModel
    
    @State private var status: StudyStatus = .studying
    @State private var topic: String = ""
    @State private var deskripsi: String = ""
    @State private var sumber: [FileMaterial] = []
    @State private var url: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Learning Details")) {
                    TextField("Topic (e.g. SwiftUI)", text: $topic)
                    
                    TextField("Deskripsi", text: $deskripsi)
                    
                    TextField("URL (Opsional)", text: $url)
                        .onChange(of: url) {
                            if url.count >= 11 {
                                Task {
                                    await fileViewModel.getYouTubeTitle(url: url)
                                }
                            }
                        }
                }
                
                Section() {
                    List {
                        Picker("Status", selection: $status) {
                            Label(Constants.studyingString, systemImage: Constants.studyingIconString).tag(StudyStatus.studying)
                            Label(Constants.completedString, systemImage: Constants.completedIconString).tag(StudyStatus.completed)
                            Label(Constants.plannedString, systemImage: Constants.plannedIconString).tag(StudyStatus.planned)
                        }
                    }
                    
                    Button {
                        fileViewModel.presentImporter.toggle()
                    } label: {
                        Label("Attach PDF", systemImage: "paperclip")
                    }
                }
                
            }
            .navigationTitle("New Material")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if url.isEmpty == false {
//                            Task(priority: .high) {
//                                await fileViewModel.getYouTubeTitle(url: url)
//                            }
//                            Thread.sleep(forTimeInterval: 0.01)
                            let link = fileViewModel.savePdf(topic: topic, url: URL(string: url) ?? URL(fileURLWithPath: ""))
                            sumber.append(link!)
                        }
                        studyViewModel.addNewMaterial(modelContext: modelContext, status: status, topic: topic, deskripsi: deskripsi, sumber: sumber)
                        dismiss()
                    }
                    .disabled(topic.isEmpty || deskripsi.isEmpty)
                }
            }
            .fileImporter(isPresented: $fileViewModel.presentImporter, allowedContentTypes: [.pdf, .image], allowsMultipleSelection: false) { result in
                fileHandler(result: result)
            }
            
        }
    }
    
    private func fileHandler(result: Result<[URL], any Error>) {
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
                let FilePDF = fileViewModel.savePdf(topic: topic, url: selectedUrl)
                print(type(of: FilePDF)) // cek outputnya
                guard FilePDF != nil else { return print("Gagal")}
                print("Data: \(FilePDF)") // debug muncul apa engga
                sumber.append(FilePDF!)
                print(type(of: sumber))
            }
            
        case .failure(let error):
            print("Gagal mengimpor file: \(error.localizedDescription)")
        }
    }
}

//struct StatusPDFSection: View {
//    @Binding var status: StudyStatus
//    @Binding var presentImporter: Bool
//
//    var body: some View {
//        Section() {
//            List {
//                Picker("Status", selection: $status) {
//                    Label(Constants.studyingString, systemImage: Constants.studyingIconString).tag(StudyStatus.studying)
//                    Label(Constants.completedString, systemImage: Constants.completedIconString).tag(StudyStatus.completed)
//                    Label(Constants.plannedString, systemImage: Constants.plannedIconString).tag(StudyStatus.planned)
//                }
//            }
//
//            Button {
//                presentImporter.toggle()
//            } label: {
//                Label("Attach PDF", systemImage: "paperclip")
//            }
//
//        }
//    }
//}

//struct TopicDescSection: View {
//    @Binding var topic: String
//    @Binding var deskripsi: String
//
//    var body: some View {
//        Section(header: Text("Learning Details")) {
//            TextField("Topic (e.g. SwiftUI)", text: $topic)
//
//            TextField("deskripsi (e.g. YouTube)", text: $deskripsi)
//        }
//    }
//}
