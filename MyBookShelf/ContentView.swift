//
//  ContentView.swift
//  MyBookShelf
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            LearningListView(status: .studying, title: Constants.studyingString)
                .tabItem {
                    Label(Constants.studyingString, systemImage: Constants.studyingIconString)
                }
            
            LearningListView(status: .planned, title: Constants.plannedString)
                .tabItem {
                    Label(Constants.plannedString, systemImage: Constants.plannedIconString)
                }
            
            LearningListView(status: .completed, title: Constants.completedString)
                .tabItem {
                    Label(Constants.completedString, systemImage: Constants.completedIconString)
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: LearningTask.self, inMemory: true)
}
