import SwiftUI
import SwiftData

@main
struct StudyMaterialApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Menambahkan Model Container untuk SwiftData
        .modelContainer(for: [StudyMaterial.self])
    }
}
