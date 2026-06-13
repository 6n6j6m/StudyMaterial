//
//  StudyMaterialViewModel.swift
//  LearningMaterials
//
//  Created by Muhammad Najmi Rahmani  on 10/06/26.
//

import Foundation
import Observation
import SwiftData

@Observable
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
    
    func savePdf(fileName: String, pdfData: Data) -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // masih bingung si unique identifier yg lebih praktis selain uuid
        let formatFile = "StudyMaterial-\(UUID().uuidString)-\(fileName)"
        let actualPath = documentsDirectory.appendingPathComponent(formatFile)
        
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
