//
//  StudyingView.swift
//  MyBookShelf
//
//  Created by Muhammad Najmi Rahmani  on 08/04/26.
//

import SwiftUI
internal import Combine

struct PlannedView: View {
    @State private var isShowingAddSheet = false
    @StateObject var viewModel = LearningViewModel()
    @State private var selectedStatus: StudyStatus = .planned
    // Anggap saja ini data materials kita, sementara masih kosong
    @State private var materials: [String] = []
    
    var body: some View {
        ZStack {
            // 1. Konten Utama (Background layer)
            VStack {
                Text("Plan Your Learning")
                    .font(.title)
                    .padding()
                
                // Perbaikan: Gunakan logika if-else untuk menampilkan placeholder
                if viewModel.tasks.isEmpty {
                    Spacer()
                    ContentUnavailableView("No Data", systemImage: "book.closed", description: Text("Start adding your learning materials."))
                    Spacer()
                } else {
                    // Daftar Catatan Belajar
                    List {
                        ForEach(viewModel.tasks.filter { $0.status == selectedStatus }) { task in
                            VStack(alignment: .leading) {
                                Text(task.topic)
                                    .font(.headline)
                                Text(task.platform)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // 2. Floating Action Button (Foreground layer)
            VStack {
                Spacer() // Dorong ke bawah
                HStack {
                    Spacer() // Dorong ke kanan
                    
                    Button {
                        isShowingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.black)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $isShowingAddSheet) {
            AddMaterialView()
        }
    }
}

#Preview {
    StudyingView()
}
