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
    var urlToDelete: URL = URL(string: "https://www.google.com") ?? URL(fileURLWithPath: "")
    
    func savePdf(topic: String, url: URL) -> URL {
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
                let emptyUrl = URL(fileURLWithPath: "")
                return emptyUrl
            }
            
            try pdfData.write(to: actualPath, options: .atomic)
            
            let fileMaterial = FileMaterial(id: UUID(), fileURL: actualPath, fileName: fileName, fileSize: fileSize, fileExtension: actualPath.pathExtension)
            
            return actualPath
            
        } catch let error as NSError {
            print("Failed to create directory: \(error.localizedDescription)")
            
            let emptyUrl = URL(fileURLWithPath: "")
            return emptyUrl
        }
    }
    
    func deletePdf(material: StudyMaterial) {
        do {
            try FileManager.default.removeItem(at: urlToDelete)
            material.sumber.removeAll { $0 == urlToDelete}
        } catch {
            print("Delete failed: \(error)")
        }
    }
}
