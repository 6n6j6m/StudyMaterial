//
//  Model.swift
//  MyBookShelf
//

import Foundation
import SwiftData
import PDFKit
import SwiftUI

// Enum tetap sama, harus Codable agar bisa disimpan
enum StudyStatus: String, Codable, CaseIterable {
    case planned = "Akan Dipelajari"
    case studying = "Sedang Belajar"
    case completed = "Sudah Belajar"
}

@Model
class StudyMaterial {
    var id: UUID
    var topic: String
    var deskripsi: String
    var status: StudyStatus
<<<<<<< HEAD:LearningMaterials/Model.swift
    var sumber: String
    var note: String
    
    init(id: UUID = UUID(),
         topic: String,
         platform: String,
         status: StudyStatus,
         sumber: String,
         note: String = "") {
=======
    var sumber: [URL]
    
    init(id: UUID = UUID(), topic: String, deskripsi: String, status: StudyStatus, sumber: [URL]) {
>>>>>>> Develop-StudyMaterial:LearningMaterials/Model/Data.swift
        self.id = id
        self.topic = topic
        self.deskripsi = deskripsi
        self.status = status
        self.sumber = sumber
        self.note = note
    }
}
