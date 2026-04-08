//
//  AddMaterialView.swift
//  MyBookShelf
//

import SwiftUI

struct AddMaterialView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: LearningViewModel // Ambil VM dari environment
    
    // Status awal saat form dibuka (planned, studying, atau completed)
    var initialStatus: StudyStatus
    
    @State private var topic = ""
    @State private var platform = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Learning Details")) {
                    TextField("Topic (e.g. SwiftUI)", text: $topic)
                    TextField("Platform (e.g. YouTube)", text: $platform)
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
                        // NYATA: Tambahkan data ke ViewModel
                        viewModel.addTask(topic: topic, platform: platform, status: initialStatus)
                        dismiss()
                    }
                    .disabled(topic.isEmpty || platform.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddMaterialView(initialStatus: .planned)
        .environmentObject(LearningViewModel())
}
