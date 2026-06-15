//
//  FileMaterialViewModel.swift
//  StudyMaterial
//
//  Created by Muhammad Najmi Rahmani  on 15/06/26.
//

import Foundation
import Observation
import SwiftData

@Observable
class FileMaterialViewModel {
    var fileToDelete: FileMaterial = FileMaterial(id: UUID(), fileURL: URL(fileURLWithPath: ""), fileName: "", fileSize: 0, fileExtension: "")
    
    func savePdf(topic: String, url: URL) -> FileMaterial? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // masih bingung si unique identifier yg lebih praktis selain uuid
        //        let fileName = "StudyMaterial-\(UUID().uuidString)-\(fileName)"
        
        
        // Bikin directory per topik
        do {
            let pdfData = try Data(contentsOf: url)
            let fileName = url.lastPathComponent
            
            let folderPath = documentsDirectory.appending(path: topic)
            let fileSize = pdfData.count
            
            try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
            
            let actualPath = folderPath.appending(path: fileName)
            
            // Check filenya udah ada apa belom biar ga ngawur
            if FileManager.default.fileExists(atPath: actualPath.path){
                // skip
                print("File already exists")
                return nil
            }
            
            try pdfData.write(to: actualPath, options: .atomic)
            
//            let fileMaterial = FileMaterial(id: UUID(), fileURL: actualPath, fileName: fileName, fileSize: fileSize, fileExtension: actualPath.pathExtension)
            
            return FileMaterial(id: UUID(), fileURL: actualPath, fileName: fileName, fileSize: fileSize, fileExtension: actualPath.pathExtension)
            
        } catch let error as NSError {
            print("Failed to create directory: \(error.localizedDescription)")
            
            return nil
        }
    }
    
    func deletePdf(material: StudyMaterial) {
        do {
            try FileManager.default.removeItem(at: fileToDelete.fileURL)
            material.sumber.removeAll { $0 == fileToDelete}
        } catch {
            print("Delete failed: \(error)")
        }
    }
}
