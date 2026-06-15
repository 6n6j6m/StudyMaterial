//
//  ContentView.swift
//  MyBookShelf
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //    let healthStore = HealthStore()
    //    @State var selection: Int = 0
    @State private var searchText: String = ""
    
    var body: some View {
        TabView() {
            // Tab study
            Tab(Constants.studyingString, systemImage: Constants.studyingIconString){
                StudyingView()
            }
            
            // Tab planned
            Tab(Constants.plannedString, systemImage: Constants.plannedIconString) {
                PlannedView()
            }
            
            // Tab completed
            Tab(Constants.completedString, systemImage: Constants.completedIconString) {
                CompletedView()
            }
            
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                SearchView(searchText: $searchText, title: "Search")
                    .searchable(text: $searchText)
            }
        }
        .tint(Color.primaryBlue)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: StudyMaterial.self, inMemory: true)
}
