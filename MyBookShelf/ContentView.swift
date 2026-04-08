//
//  ContentView.swift
//  MyBookShelf
//

import SwiftUI

struct ContentView: View {
    // 1. Buat satu sumber kebenaran (source of truth) di sini
    @StateObject var viewModel = LearningViewModel()
    
    var body: some View {
        TabView {
            // Gunakan view generic yang sama, cukup ganti status & judul
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
        // 2. Bagikan VM ke seluruh child views melalui Environment
        .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
