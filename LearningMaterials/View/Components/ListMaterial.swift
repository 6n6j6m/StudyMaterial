//
//  ListMaterial.swift
//  StudyMaterial
//
//  Created by Muhammad Najmi Rahmani  on 14/06/26.
//

import SwiftUI
import SwiftData

struct ListMaterial: View {
    var filteredMaterials: [StudyMaterial]
    var studyViewModel: StudyMaterialViewModel
    var fileViewModel: FileMaterialViewModel
    var colorScheme: ColorScheme
    var modelContext: ModelContext
    
    var body: some View {
        List(filteredMaterials) { material in
            
            RowMaterialView(material: material, studyViewModel: studyViewModel, fileViewModel: fileViewModel, colorScheme: colorScheme)
            
            // Swipe Action
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    switch material.status {
                    case .completed:
                        Button {
                            studyViewModel.changeTopic(material: material, newStatus: .studying)
                        } label:{
                            Label("Re-study", systemImage: "arrow.uturn.right")
                                .tint(.blue)
                        }
                        
                    case .studying:
                        Button {
                            studyViewModel.changeTopic(material: material, newStatus: .completed)
                        } label:{
                            Label("Done", systemImage: "checkmark.circle")
                                .tint(.green)
                        }
                        
                    case .planned:
                        Button {
                            studyViewModel.changeTopic(material: material, newStatus: .studying)
                        } label: {
                            Label("Start", systemImage: "play.circle")
                                .tint(Color.blue)
                        }
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button { 
                        studyViewModel.deleteMaterial(modelContext: modelContext, material: material)
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .tint(.red)
                    }
                }
            
            //            // Delete trailing untuk data yang di loop ForEach
            //            .onDelete { indexSet in
            //                // SWIFTDATA: Menghapus material
            //                for index in indexSet {
            //                    let materialToDelete = filteredMaterials[index]
            //                    studyViewModel.deleteMaterial(modelContext: modelContext, material: materialToDelete)
            //                }
            //            }
        }
        .listStyle(.plain)
    }
}

struct RowMaterialView: View {
    let material: StudyMaterial
    let studyViewModel: StudyMaterialViewModel
    let fileViewModel: FileMaterialViewModel
    let colorScheme: ColorScheme
    
    var body: some View {
        NavigationLink {
            MaterialDetailView(material: material, studyViewModel: studyViewModel, fileViewModel: fileViewModel)
        } label: {
            VStack(alignment: .leading, spacing: 5) {
                Text(material.topic)
                    .font(.headline)
                    .foregroundStyle(Color.primary)
                Text(material.deskripsi)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text("\(material.sumber.count) Sources")
                    .padding(5)
                    .font(.caption)
                    .background(Color.primaryBlue)
                    .foregroundStyle(colorScheme == .dark ? .black : .white)
                    .cornerRadius(10)
            }
        }
    }
}
//
//#Preview {
//    ListMaterial()
//}
