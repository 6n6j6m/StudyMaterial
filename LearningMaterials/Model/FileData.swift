//
//  FileData.swift
//  StudyMaterial
//
//  Created by Muhammad Najmi Rahmani  on 16/06/26.
//

import Foundation
import SwiftData

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
