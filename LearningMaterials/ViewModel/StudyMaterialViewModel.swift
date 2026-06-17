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
    var showAddMaterial: Bool = false
    
    func addNewMaterial(modelContext: ModelContext, status: StudyStatus, topic: String, deskripsi: String, sumber: [FileMaterial]) {
        let newMaterial = StudyMaterial(id: UUID(), topic: topic, deskripsi: deskripsi, status: status, sumber: sumber)
        modelContext.insert(newMaterial)
    }
    
    func deleteMaterial(modelContext: ModelContext, material: StudyMaterial) {
        modelContext.delete(material)
    }
    
    func changeTopic(material: StudyMaterial, newStatus: StudyStatus) {
        material.status = newStatus
    }
    
}
