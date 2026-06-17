//
//  SummaryView.swift
//  StudyMaterial
//
//  Created by Muhammad Najmi Rahmani  on 16/06/26.
//

import SwiftUI

struct SummaryView: View {
    @Bindable var fileViewModel: FileMaterialViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading) {
                Section {
                    Text("Overview")
                    Text(fileViewModel.paperSummary.reasoningSteps)
                }
                
                Spacer()
                
                Section {
                    Text("Title")
                    Text(fileViewModel.paperSummary.title)
                }
                
                Spacer()
                
                Section {
                    Text("Authors")
                    Text(fileViewModel.paperSummary.authors)
                }
                
                Spacer()
                
                Section {
                    Text("Methods")
                    Text(fileViewModel.paperSummary.methods)
                }
                
                Spacer()
                
                Section {
                    Text("Context and Objective")
                    Text(fileViewModel.paperSummary.contextAndObjective)
                }
                
                Spacer()
                
                Section {
                    Text("Discussion and Impact")
                    Text(fileViewModel.paperSummary.discussionAndImpact)
                }
                
                Spacer()
                
                Section {
                    Text("Results")
                    Text(fileViewModel.paperSummary.primaryResults)
                }
                
                Spacer()
            }
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}
//
//#Preview {
//    SummaryView()
//}
