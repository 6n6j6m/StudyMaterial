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
    @State private var fileViewModel = FileMaterialViewModel()
    @State private var studyViewModel = StudyMaterialViewModel()
    @State private var chatViewModel = ChatViewModel()
    
    var body: some View {
        TabView() {
            // Tab study
            Tab(Constants.studyingString, systemImage: Constants.studyingIconString){
                StudyingView(studyViewModel: studyViewModel, fileViewModel: fileViewModel)
            }
            
            // Tab planned
//            Tab(Constants.plannedString, systemImage: Constants.plannedIconString) {
//                PlannedView(studyViewModel: studyViewModel, fileViewModel: fileViewModel)
//            }
            
            // Tab completed
            Tab(Constants.completedString, systemImage: Constants.completedIconString) {
                CompletedView(studyViewModel: studyViewModel, fileViewModel: fileViewModel)
            }
            
            Tab("Chat", systemImage: "bubble.left.and.bubble.right.fill") {
                ChatView(chatViewModel: chatViewModel)
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
        .modelContainer(for: [StudyMaterial.self, FileMaterial.self], inMemory: true)
}
