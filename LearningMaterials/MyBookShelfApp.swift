//
//  MyBookShelfApp.swift
//  MyBookShelf
//

import SwiftUI
import SwiftData

@main
struct MyBookShelfApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Menambahkan Model Container untuk SwiftData
        .modelContainer(for: LearningTask.self)
    }
}
