import SwiftUI
import SwiftData

struct StudyingView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowingAddSheet = false
    
    @State private var studyViewModel = StudyMaterialViewModel()
    @State private var fileViewModel = FileMaterialViewModel()
    
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
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title.bold())
                    
                    CardTitle(filteredMaterials: filteredMaterials, pageStatus: $pageStatus, colorScheme: colorScheme)
                }
                
                // Kosong
                if filteredMaterials.isEmpty {
                    EmptyView(pageStatus: $pageStatus)
                    
                } else {
                    Text("Current Focus") // kena
                        .font(.system(.headline))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Show the data
                    ListMaterial(filteredMaterials: filteredMaterials, studyViewModel: studyViewModel, fileViewModel: fileViewModel, colorScheme: colorScheme, modelContext: modelContext)
                    
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
            .background(Color.primaryBG)
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
                AddMaterialView(studyViewModel: studyViewModel, fileViewModel: fileViewModel)
            }
            
        }
    }
}

#Preview {
    StudyingView()
        .modelContainer(for: [StudyMaterial.self, FileMaterial.self], inMemory: true)
}
