//
//  LearningListView.swift
//  MyBookShelf
//

import SwiftUI
import SwiftData

struct CompletedView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowingAddSheet = false
    
    @State private var viewModel = StudyMaterialViewModel()
    
    // Fetch models yang udah disimpen pake swiftdata
    @Query(sort: \StudyMaterial.topic) private var allMaterial: [StudyMaterial]
    
    @State private var pageStatus: StudyStatus = .completed
    private let title: String = "Completed"
    
    // Filter buat status belajarny
    var filteredMaterials: [StudyMaterial] {
        allMaterial.filter{
            $0.status == pageStatus // $0 ngereference element2 yg lagi diinspect/difilter
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 20) {
                    Label("You've Completed", systemImage: "book")
                        .font(.headline)
                        .foregroundStyle(colorScheme == .dark ? .black : .white)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("\(filteredMaterials.count) Material so far")
                        .font(.headline)
                        .foregroundStyle(colorScheme == .dark ? .black : .white)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.primaryBlue)
                .cornerRadius(20)
                                
                // Kosong
                if filteredMaterials.isEmpty {
                    ContentUnavailableView(
                        "Empty List",
                        systemImage: Constants.closedbookIconString,
                        description: Text("No items in \(title)")
                    )
                    Spacer()
                } else {
                    Text("Current Focus")
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Show the data
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
                                Button {
                                    viewModel.changeTopic(material: material, newStatus: .completed)
                                } label: {
                                    Label("Done", systemImage: "checkmark.circle")
                                }
                                .tint(.green)
                            }
                        }
                        
                        // Delete trailing untuk data yang di loop ForEach
                        .onDelete { offsets in
                            // SWIFTDATA: Menghapus material
                            for index in offsets {
                                let materialToDelete = filteredMaterials[index]
                                viewModel.deleteMaterial(modelContext: modelContext, material: materialToDelete)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isShowingAddSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color.primary)
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingAddSheet) {
            AddMaterialView(viewModel: viewModel)
        }
    }
}

#Preview {
    CompletedView()
        .modelContainer(for: StudyMaterial.self, inMemory: true)
}
