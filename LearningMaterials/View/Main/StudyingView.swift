//
//  LearningListView.swift
//  MyBookShelf
//

import SwiftUI
import SwiftData

struct StudyingView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowingAddSheet = false
    
    @State private var viewModel = StudyMaterialViewModel()
    
    // Fetch models yang udah disimpen pake swiftdata
    @Query(sort: \StudyMaterial.topic) private var allMaterial: [StudyMaterial]
    
    @State private var pageStatus: StudyStatus = .studying
    private let title: String = "Studying"
    
    // Filter buat status belajarny
    var filteredMaterials: [StudyMaterial] {
        allMaterial.filter{
            $0.status == pageStatus // $0 ngereference element2 yg lagi diinspect/difilter
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                CardTitle(filteredMaterials: filteredMaterials, pageStatus: $pageStatus, colorScheme: colorScheme)
                
                // Kosong
                if filteredMaterials.isEmpty {
                    EmptyView(pageStatus: $pageStatus)
                    
                } else {
                    Text("Current Focus") // kena
                        .font(.system(.headline))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Show the data
                    ListMaterial(filteredMaterials: filteredMaterials, viewModel: viewModel, colorScheme: colorScheme, modelContext: modelContext)
                    
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
            .background(Color.primaryBG)
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
            .sheet(isPresented: $isShowingAddSheet) {
                AddMaterialView(viewModel: viewModel)
            }
            
        }
    }
}

#Preview {
    StudyingView()
        .modelContainer(for: StudyMaterial.self, inMemory: true)
}
