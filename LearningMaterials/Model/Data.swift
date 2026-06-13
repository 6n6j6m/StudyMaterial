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
    var sumber: [URL]
    
    init(id: UUID = UUID(), topic: String, deskripsi: String, status: StudyStatus, sumber: [URL]) {
        self.id = id
        self.topic = topic
        self.deskripsi = deskripsi
        self.status = status
        self.sumber = sumber
    }
}
