//
//  LearningListView.swift
//  MyBookShelf
//

import SwiftUI

struct LearningListView: View {
    @EnvironmentObject var viewModel: LearningViewModel // Ambil data dari satu VM yang sama
    @State private var isShowingAddSheet = false
    
    let status: StudyStatus
    let title: String
    
    // Filter data hanya yang sesuai status-nya
    var filteredTasks: [LearningTask] {
        viewModel.tasks.filter { $0.status == status }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text(title)
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                if filteredTasks.isEmpty {
                    Spacer()
                    ContentUnavailableView(
                        "Empty List",
                        systemImage: "book.closed",
                        description: Text("Start adding items to '\(title)'")
                    )
                    Spacer()
                } else {
                    List {
                        ForEach(filteredTasks) { task in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(task.topic)
                                    .font(.headline)
                                Text(task.platform)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onDelete { offsets in
                            // Fitur hapus data
                            viewModel.deleteTask(at: offsets, for: status)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        isShowingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.black)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $isShowingAddSheet) {
            AddMaterialView(initialStatus: status)
        }
    }
}

#Preview {
    LearningListView(status: .planned, title: "Planned")
        .environmentObject(LearningViewModel())
}
