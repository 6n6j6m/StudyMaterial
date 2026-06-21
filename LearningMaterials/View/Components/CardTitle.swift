//
//  CardTitle.swift
//  StudyMaterial
//
//  Created by Muhammad Najmi Rahmani  on 14/06/26.
//

import SwiftUI

struct CardTitle: View {
    
    var filteredMaterials: [StudyMaterial]
    let pageStatus: StudyStatus
    let colorScheme: ColorScheme
    
    
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
    
    var imageIcon: String {
        switch pageStatus {
        case .planned:
            return Constants.plannedIconString
        case .studying:
            return Constants.studyingIconString
        case .completed:
            return Constants.completedIconString
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Label(title, systemImage: imageIcon) // kena
                .font(.system(.headline))
                .foregroundStyle(colorScheme == .dark ? .black : .white)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("\(filteredMaterials.count) Material") // kena
                .font(.system(.headline))
                .foregroundStyle(colorScheme == .dark ? .black : .white)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primaryBlue)
        .cornerRadius(20)
    }
}
//
//#Preview {
//    CardTitle()
//}
