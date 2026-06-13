//
//  LearningListView.swift
//  MyBookShelf
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isShowingAddSheet = false
    @State private var viewModel = StudyMaterialViewModel()
    
    // Fetch models yang udah disimpen pake swiftdata
    @Query(sort: \StudyMaterial.topic) private var allMaterial: [StudyMaterial]
    
    @Binding var searchText: String
    let title: String
    
    var filteredData: [StudyMaterial] {
        allMaterial.filter {
            let searchTerm = searchText.lowercased()
            return $0.topic.lowercased().contains(searchTerm)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // Kosong
                    if searchText.isEmpty {
                        Spacer()
                        List {
                            ForEach(allMaterial) { material in
                                NavigationLink {
                                    MaterialDetailView(material: material, viewModel: viewModel)
                                } label: {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(material.topic)
                                            .font(.headline)
                                        Text(material.deskripsi)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                // Swipe Action
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    switch material.status {
                                    case .planned:
                                        Button {
                                            viewModel.changeTopic(material: material, newStatus: .studying)
                                        } label: {
                                            Label("Start", systemImage: "play.circle")
                                        }
                                        .tint(.blue)
                                        
                                    case .studying:
                                        Button {
                                            viewModel.changeTopic(material: material, newStatus: .completed)
                                        } label: {
                                            Label("Done", systemImage: "checkmark.circle")
                                        }
                                        .tint(.green)
                                        
                                    case .completed:
                                        Button {
                                            viewModel.changeTopic(material: material, newStatus: .studying)
                                        } label: {
                                            Label("Re-study", systemImage: "arrow.uturn.backward")
                                        }
                                        .tint(.orange)
                                    }
                                }
                            }
                            
                            // Delete trailing untuk data yang di loop ForEach
                            .onDelete { offsets in
                                // SWIFTDATA: Menghapus material
                                for index in offsets {
                                    let materialToDelete = allMaterial[index]
                                    viewModel.deleteMaterial(modelContext: modelContext, material: materialToDelete)
                                }
                            }
                        }
                        Spacer()
                    } else {
                        // Show the filtered one
                        List {
                            ForEach(filteredData) { material in
                                NavigationLink {
                                    MaterialDetailView(material: material, viewModel: viewModel)
                                } label: {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(material.topic)
                                            .font(.headline)
                                        Text(material.deskripsi)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                // Swipe Action
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    switch material.status {
                                    case .planned:
                                        Button {
                                            viewModel.changeTopic(material: material, newStatus: .studying)
                                        } label: {
                                            Label("Start", systemImage: "play.circle")
                                        }
                                        .tint(.blue)
                                        
                                    case .studying:
                                        Button {
                                            viewModel.changeTopic(material: material, newStatus: .completed)
                                        } label: {
                                            Label("Done", systemImage: "checkmark.circle")
                                        }
                                        .tint(.green)
                                        
                                    case .completed:
                                        Button {
                                            viewModel.changeTopic(material: material, newStatus: .studying)
                                        } label: {
                                            Label("Re-study", systemImage: "arrow.uturn.backward")
                                        }
                                        .tint(.orange)
                                    }
                                }
                            }
                            
                            // Delete trailing untuk data yang di loop ForEach
                            .onDelete { offsets in
                                // SWIFTDATA: Menghapus material
                                for index in offsets {
                                    let materialToDelete = allMaterial[index]
                                    viewModel.deleteMaterial(modelContext: modelContext, material: materialToDelete)
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(title)
        }
    }
}

#Preview {
    @Previewable @State var searchText: String = ""
    SearchView(searchText: $searchText, title: "Search")
        .modelContainer(for: StudyMaterial.self, inMemory: true)
}
