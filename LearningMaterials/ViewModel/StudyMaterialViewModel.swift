//
//  StudyMaterialViewModel.swift
//  LearningMaterials
//
//  Created by Muhammad Najmi Rahmani  on 10/06/26.
//

import Foundation
import Observation
import SwiftData

@MainActor @Observable
class StudyMaterialViewModel {
    var selectedURL: URL = URL(string: "https://www.google.com") ?? URL(fileURLWithPath: "")
    
    
    func addNewMaterial(modelContext: ModelContext, status: StudyStatus, topic: String, deskripsi: String, sumber: [URL]) {
        let newMaterial = StudyMaterial(id: UUID(), topic: topic, deskripsi: deskripsi, status: status, sumber: sumber)
        modelContext.insert(newMaterial)
    }
    
    func deleteMaterial(modelContext: ModelContext, material: StudyMaterial) {
        modelContext.delete(material)
    }
    
    func changeTopic(material: StudyMaterial, newStatus: StudyStatus) {
        material.status = newStatus
    }
    
    func savePdf(topic: String, url: URL) -> (url: URL, size: Int) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // masih bingung si unique identifier yg lebih praktis selain uuid
        //        let fileName = "StudyMaterial-\(UUID().uuidString)-\(fileName)"
        
        
        // Bikin directory per topik
        do {
            let pdfData = try Data(contentsOf: url)
            let fileName = url.lastPathComponent
            
            let folderPath = documentsDirectory.appending(path: topic)
            let dataSize = pdfData.count
            
            try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
            
            let actualPath = folderPath.appending(path: fileName)
            
            // Check filenya udah ada apa belom biar ga ngawur
            if FileManager.default.fileExists(atPath: actualPath.path){
                // skip
                print("File already exists")
                let emptyUrl = URL(fileURLWithPath: "")
                return (emptyUrl, 0)
            }
            
            try pdfData.write(to: actualPath, options: .atomic)
            
            return (actualPath, dataSize)
            
        } catch let error as NSError {
            print("Failed to create directory: \(error.localizedDescription)")
            
            let emptyUrl = URL(fileURLWithPath: "")
            return (emptyUrl, 0)
        }
    }
    
    func deletePdf(material: StudyMaterial) {
        do {
            try FileManager.default.removeItem(at: selectedURL)
            material.sumber.removeAll { $0 == selectedURL}
        } catch {
            print("Delete failed: \(error)")
        }
    }
    
}
