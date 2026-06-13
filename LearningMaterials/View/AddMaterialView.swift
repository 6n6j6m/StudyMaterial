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
    
    @Bindable var viewModel: StudyMaterialViewModel

    @State private var status: StudyStatus = .studying
    @State private var presentImporter: Bool = false
    @State private var topic: String = ""
    @State private var deskripsi: String = ""
    @State private var sumber: [URL] = []

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Learning Details")) {
                    TextField("Topic (e.g. SwiftUI)", text: $topic)
                        
                    TextField("deskripsi (e.g. YouTube)", text: $deskripsi)
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
                        presentImporter.toggle()
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
                        viewModel.addNewMaterial(modelContext: modelContext, status: status, topic: topic, deskripsi: deskripsi, sumber: sumber)
                        dismiss()
                    }
                    .disabled(topic.isEmpty || deskripsi.isEmpty)
                }
            }
            .fileImporter(isPresented: $presentImporter, allowedContentTypes: [.pdf, .image], allowsMultipleSelection: false) { result in
                switch result {
                case .success(let urls):
                    guard let selectedUrl = urls.first else { return }
                    
                    // Bikin akses buat filenya
                    // Tapi kalo dibuild ulang, akses ke filenya ilang, still figurin on how to handlenya
                    let gotAccess = selectedUrl.startAccessingSecurityScopedResource()
                    defer {
                        if gotAccess {
                            selectedUrl.stopAccessingSecurityScopedResource()
                        }
                    }
                    
                    do {
                        let dataPdf = try Data(contentsOf: selectedUrl)
                        
                        let namaFileAsli = selectedUrl.lastPathComponent
                        let urlFilePDF = viewModel.savePdf(fileName: namaFileAsli, pdfData: dataPdf, topic: topic)
                        print("URL: \(urlFilePDF?.absoluteString ?? "")") // debug muncul apa engga
                        sumber.append(urlFilePDF ?? URL(string: "")!)
                        
                    } catch {
                        print("Gagal membaca data file luar: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    print("Gagal mengimpor file: \(error.localizedDescription)")
                }
            }

        }
    }
}
