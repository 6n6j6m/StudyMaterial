//
//  LearningTaskDetailView.swift
//  MyBookShelf
//

import SwiftUI

struct LearningTaskDetailView: View {
    let task: LearningTask

    var body: some View {
        Form {
            Section("Topic") {
                Text(task.topic)
            }

            Section("Platform") {
                Text(task.platform)
            }

            Section("Status") {
                Text(task.status.rawValue)
            }
            
            Section("URL") {
                Link("\(task.sumber)", destination: URL(string: task.sumber)!)
            }
            
            Section("Catatan") {
                Text(task.note)
            }
        }
        .navigationTitle("Task Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let task = LearningTask(topic: "SwiftUI",
                            platform: "YouTube",
                            status: .studying,
                            sumber: "https://www.youtube.com/watch?v=Q1Q1-Q1Q1Q1",
                            note: "")
    NavigationStack {
        LearningTaskDetailView(task: task)
    }
}
