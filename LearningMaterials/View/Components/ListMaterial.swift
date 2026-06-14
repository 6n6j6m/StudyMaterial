//
//  ListMaterial.swift
//  StudyMaterial
//
//  Created by Muhammad Najmi Rahmani  on 14/06/26.
//

import SwiftUI
import SwiftData

struct ListMaterial: View {
    let filteredMaterials: [StudyMaterial]
    let viewModel: StudyMaterialViewModel
    let colorScheme: ColorScheme
    let modelContext: ModelContext
    let pageStatus: StudyStatus
    
    var body: some View {
        List {
            ForEach(filteredMaterials) { material in
                NavigationLink {
                    MaterialDetailView(material: material, viewModel: viewModel)
                } label: {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(material.topic)
                            .font(.headline)
                            .foregroundStyle(Color.primary)
                        Text(material.deskripsi)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        Text("\(material.sumber.count) Sources")
                            .padding(5)
                            .font(.caption)
                            .background(Color.primaryBlue)
                            .foregroundStyle(colorScheme == .dark ? .black : .white)
                            .cornerRadius(10)
                    }
                }
                
                // Swipe Action
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    switch pageStatus {
                    case .completed:
                        Button {
                            viewModel.changeTopic(material: material, newStatus: .studying)
                        } label:{
                            Label("Re-study", systemImage: "arrow.uturn.right")
                                .tint(.blue)
                        }
                        
                        
                    case .studying:
                        Button {
                            viewModel.changeTopic(material: material, newStatus: .completed)
                        } label:{
                            Label("Done", systemImage: "checkmark.circle")
                                .tint(.green)
                        }
                        
                        
                    case .planned:
                        Button {
                            viewModel.changeTopic(material: material, newStatus: .studying)
                        } label: {
                            Label("Start", systemImage: "play.circle")
                                .tint(Color.blue)
                        }
                    }
                }
            }
            
            // Delete trailing untuk data yang di loop ForEach
            .onDelete { indexSet in
                // SWIFTDATA: Menghapus material
                for index in indexSet {
                    let materialToDelete = filteredMaterials[index]
                    viewModel.deleteMaterial(modelContext: modelContext, material: materialToDelete)
                }
            }
        }
        .listStyle(.plain)
    }
    
}
//
//#Preview {
//    ListMaterial()
//}
