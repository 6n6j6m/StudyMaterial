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
    
    func savePdf(fileName: String, pdfData: Data, topic: String) -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // masih bingung si unique identifier yg lebih praktis selain uuid
//        let formatFile = "StudyMaterial-\(UUID().uuidString)-\(fileName)"
        
//        let folderName = "\(topic)"
//        let formatFile = "\(fileName)"
        
        let folderPath = documentsDirectory.appending(path: topic)
        
        // Bikin directory per topik
        do {
            try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Failed to create directory: \(error.localizedDescription)")
        }
        
        let actualPath = folderPath.appending(path: fileName)
        print(actualPath.path)
        let dataSize = pdfData.count
        
        do {
            try pdfData.write(to: actualPath, options: .atomic)
            

            print("Successfully save PDF to: \(actualPath.path)")
            return actualPath
            
        } catch {
            print("Fail to save PDF: \(error.localizedDescription)")
            
            return nil
        }
    }

    
}
