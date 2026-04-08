//
//  Model.swift
//  MyBookShelf
//
//  Created by Muhammad Najmi Rahmani  on 08/04/26.
//

import Foundation

// Enum untuk status agar data konsisten
enum StudyStatus: String, Codable, CaseIterable {
    case planned = "Akan Dipelajari"
    case studying = "Sedang Belajar"
    case completed = "Sudah Belajar"
}

struct LearningTask: Identifiable, Codable {
    var id = UUID()
    var topic: String
    var platform: String // Misal: YouTube, Udemy, Books
    var status: StudyStatus
}
