//
//  ViewModel.swift
//  MyBookShelf
//

import Foundation
import SwiftUI
internal import Combine

class LearningViewModel: ObservableObject {
    // Satu sumber data untuk seluruh aplikasi
    @Published var tasks: [LearningTask] = [
        LearningTask(topic: "SwiftUI Basics", platform: "Apple Docs", status: .studying),
        LearningTask(topic: "Vapor Framework", platform: "Vapor University", status: .planned),
        LearningTask(topic: "Python Fundamentals", platform: "WPU", status: .completed)
    ]
    
    // Fungsi untuk menambah catatan baru dengan status spesifik
    func addTask(topic: String, platform: String, status: StudyStatus) {
        let newTask = LearningTask(topic: topic, platform: platform, status: status)
        tasks.append(newTask)
    }
    
    // Fungsi untuk menghapus task (opsional, untuk fitur ke depan)
    func deleteTask(at offsets: IndexSet, for status: StudyStatus) {
        let filteredTasks = tasks.filter { $0.status == status }
        for index in offsets {
            let taskToDelete = filteredTasks[index]
            tasks.removeAll { $0.id == taskToDelete.id }
        }
    }
}
