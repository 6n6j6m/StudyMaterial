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
    var sumber: [FileMaterial]
    
    init(id: UUID = UUID(), topic: String, deskripsi: String, status: StudyStatus, sumber: [FileMaterial]) {
        self.id = id
        self.topic = topic
        self.deskripsi = deskripsi
        self.status = status
        self.sumber = sumber
    }
}

@Model
class FileMaterial {
    var id: UUID
    var fileURL: URL
    var fileName: String
    var fileSize: Int
    var fileExtension: String
    
    init(id: UUID, fileURL: URL, fileName: String, fileSize: Int, fileExtension: String) {
        self.id = id
        self.fileURL = fileURL
        self.fileName = fileName
        self.fileSize = fileSize
        self.fileExtension = fileExtension
    }
}
