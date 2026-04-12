//
//  Model.swift
//  MyBookShelf
//

import Foundation
import SwiftData

// Enum tetap sama, harus Codable agar bisa disimpan
enum StudyStatus: String, Codable, CaseIterable {
    case planned = "Akan Dipelajari"
    case studying = "Sedang Belajar"
    case completed = "Sudah Belajar"
}

@Model
class LearningTask {
    var id: UUID
    var topic: String
    var platform: String
    var status: StudyStatus
    
    init(id: UUID = UUID(), topic: String, platform: String, status: StudyStatus) {
        self.id = id
        self.topic = topic
        self.platform = platform
        self.status = status
    }
}
