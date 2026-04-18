//
//  AddMaterialView.swift
//  MyBookShelf
//

import SwiftUI
import SwiftData

struct AddMaterialView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext // Akses SwiftData Context
    
    var initialStatus: StudyStatus
    
    @State private var topic = ""
    @State private var platform = ""
    @State private var link = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Learning Details")) {
                    TextField("Topic (e.g. SwiftUI)", text: $topic)
                    TextField("Platform (e.g. YouTube)", text: $platform)
                    TextField("Sumber belajar (URL)", text: $link)
                    TextField("Notes", text: $notes)
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
                        // SWIFTDATA: Masukkan data baru ke context
                        let newTask = LearningTask(topic: topic, platform: platform, status: initialStatus, sumber: link)
                        modelContext.insert(newTask)
                        dismiss()
                    }
                    .disabled(topic.isEmpty || platform.isEmpty)
                }
            }
        }
    }
}
