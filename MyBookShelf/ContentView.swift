//
//  ContentView.swift
//  MyBookShelf
//
//  Created by Muhammad Najmi Rahmani  on 08/04/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = LearningViewModel()
    var body: some View {
        TabView {
            Tab(Constants.completedString, systemImage: Constants.completedIconString){
                CompletedView()
            }
            
            Tab(Constants.studyingString, systemImage: Constants.studyingIconString){
                StudyingView()
            }
            
            Tab(Constants.plannedString, systemImage: Constants.plannedIconString){
                PlannedView()
            }
            
        }
    }
}

#Preview {
    ContentView()
}
