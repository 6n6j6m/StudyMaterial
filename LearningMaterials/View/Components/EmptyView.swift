//
//  EmptyView.swift
//  StudyMaterial
//
//  Created by Muhammad Najmi Rahmani  on 14/06/26.
//

import SwiftUI

struct EmptyView: View {
    
    @Binding var pageStatus: StudyStatus
    
    var title: String {
        switch pageStatus {
        case .planned:
            return "You've planned"
        case .studying:
            return "Currently Studying"
        case .completed:
            return "You've completed"
        }
    }
    
    var body: some View {
        ContentUnavailableView(
            "Empty List",
            systemImage: Constants.closedbookIconString,
            description: Text("No items in \(title)")
        )
    }
}
//
//#Preview {
//    EmptyView()
//}
