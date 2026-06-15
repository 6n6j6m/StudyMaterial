import SwiftUI
import SwiftData

struct CompletedView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowingAddSheet = false
    
    @State private var studyViewModel = StudyMaterialViewModel()
    @State private var fileViewModel = FileMaterialViewModel()
    
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
                
                CardTitle(filteredMaterials: filteredMaterials, pageStatus: $pageStatus, colorScheme: colorScheme)
                
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
                    ListMaterial(filteredMaterials: filteredMaterials, studyViewModel: studyViewModel, fileViewModel: fileViewModel, colorScheme: colorScheme, modelContext: modelContext)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        }
        .sheet(isPresented: $isShowingAddSheet) {
            AddMaterialView(studyViewModel: studyViewModel, fileViewModel: fileViewModel)
        }
    }
}

#Preview {
    CompletedView()
        .modelContainer(for: [StudyMaterial.self, FileMaterial.self], inMemory: true)
}
