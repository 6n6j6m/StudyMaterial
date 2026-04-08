//
//  ViewModel.swift
//  MyBookShelf
//
//  Created by Muhammad Najmi Rahmani  on 08/04/26.
//

import Foundation
import SwiftUI
internal import Combine

class LearningViewModel: ObservableObject {
    // @Published membuat UI otomatis update saat data berubah
    @Published var tasks: [LearningTask] = [
        LearningTask(topic: "SwiftUI Basics", platform: "Apple Docs", status: .studying),
        LearningTask(topic: "Vapor Framework", platform: "Vapor University", status: .planned),
        LearningTask(topic: "Python Fundamentals", platform: "WPU", status: .completed)
    ]
    
    // Fungsi untuk menambah catatan baru
    func addTask(topic: String, platform: String) {
        let newTask = LearningTask(topic: topic, platform: platform, status: .planned)
        tasks.append(newTask)
    }
}

struct AddMaterialView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var author = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Material Details")) {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                }
            }
            .navigationTitle("New Material")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        viewModel.addTask(topic: <#T##String#>, platform: <#T##String#>)
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
