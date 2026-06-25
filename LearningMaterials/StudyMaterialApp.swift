import SwiftUI
import SwiftData

@main
struct StudyMaterialApp: App {
        
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do {
                        try await RAGManager.initialize()
                    } catch {
                        print("\(error.localizedDescription)")
                    }

                }
        }
        // Menambahkan Model Container untuk SwiftData
        .modelContainer(for: [StudyMaterial.self, FileMaterial.self])
    }
}
