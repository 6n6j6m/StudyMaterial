import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isShowingAddSheet = false
    @State private var viewModel = StudyMaterialViewModel()
    @State private var imageView = UIImageView()
    
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
                        ListMaterial(filteredMaterials: allMaterial, viewModel: viewModel, colorScheme: colorScheme, modelContext: modelContext)
                        Spacer()
                    } else {
                        // Show the filtered one
                        ListMaterial(filteredMaterials: filteredData, viewModel: viewModel, colorScheme: colorScheme, modelContext: modelContext)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primaryBG)
            .navigationTitle(title)
        }
    }
}

#Preview {
    @Previewable @State var searchText: String = ""
    SearchView(searchText: $searchText, title: "Search")
        .modelContainer(for: StudyMaterial.self, inMemory: true)
}
