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
            
//            GridExampleView()
//                .tabItem {
//                    Label("Grid", systemImage: "square.grid.3x3")
//                }
//            
//            ContenView()
            
            // TryHealthKit
//            TryHealthKit()
//                .tabItem {
//                    Label("Health Data", systemImage: "heart.square.fill")
//                }
            
        }
        .tint(Color.primaryBlue)
//        .onAppear {
//            requestHealthKitAcces()
//        }
    }
//    func requestHealthKitAcces() {
//        healthStore.requestPermission {
//            success, error in
//            if let error = error {
//                print(error)
//            } else {
//                print("success")
//            }
//        }
//    }
}

#Preview {
    ContentView()
        .modelContainer(for: StudyMaterial.self, inMemory: true)
}
