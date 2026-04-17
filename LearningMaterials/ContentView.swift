//
//  ContentView.swift
//  MyBookShelf
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            // Tab study
            LearningListView(status: .studying, title: Constants.studyingString)
                .tabItem {
                    Label(Constants.studyingString, systemImage: Constants.studyingIconString)
                }
            
            // Tab planned
            LearningListView(status: .planned, title: Constants.plannedString)
                .tabItem {
                    Label(Constants.plannedString, systemImage: Constants.plannedIconString)
                }
            
            // Tab completed
            LearningListView(status: .completed, title: Constants.completedString)
                .tabItem {
                    Label(Constants.completedString, systemImage: Constants.completedIconString)
                }
            
//            GridExampleView()
//                .tabItem {
//                    Label("Grid", systemImage: "square.grid.3x3")
//                }
//            
//            ContenView()
        }
        .padding(.bottom, 10)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LearningTask.self, inMemory: true)
}
