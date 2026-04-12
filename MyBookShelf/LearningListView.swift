//
//  LearningListView.swift
//  MyBookShelf
//

import SwiftUI
import SwiftData

struct LearningListView: View {
    @Environment(\.modelContext) var modelContext
    @State private var isShowingAddSheet = false
    
    // SWIFTDATA: Mengambil semua task dari database
    @Query(sort: \LearningTask.topic) var allTasks: [LearningTask]
    
    let status: StudyStatus
    let title: String
    
    // Filter secara lokal (untuk saat ini)
    var filteredTasks: [LearningTask] {
        allTasks.filter { $0.status == status }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if filteredTasks.isEmpty {
                        Spacer()
                        ContentUnavailableView(
                            "Empty List",
                            systemImage: "book.closed",
                            description: Text("No items in '\(title)'")
                        )
                        Spacer()
                    } else {
                        List {
                            ForEach(filteredTasks) { task in
                                NavigationLink {
                                    LearningTaskDetailView(task: task)
                                } label: {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(task.topic)
                                            .font(.headline)
                                        Text(task.platform)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    switch status {
                                    case .planned:
                                        Button {
                                            task.status = .studying // SwiftData otomatis deteksi perubahan
                                        } label: {
                                            Label("Start", systemImage: "play.circle")
                                        }
                                        .tint(.blue)

                                    case .studying:
                                        Button {
                                            task.status = .completed
                                        } label: {
                                            Label("Done", systemImage: "checkmark.circle")
                                        }
                                        .tint(.green)

                                    case .completed:
                                        Button {
                                            task.status = .studying
                                        } label: {
                                            Label("Re-study", systemImage: "arrow.uturn.backward")
                                        }
                                        .tint(.orange)
                                    }
                                }
                            }
                            .onDelete { offsets in
                                // SWIFTDATA: Menghapus task
                                for index in offsets {
                                    let taskToDelete = filteredTasks[index]
                                    modelContext.delete(taskToDelete)
                                }
                            }
                        }
                    }
                }

                // FAB
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(title)
        }
        .sheet(isPresented: $isShowingAddSheet) {
            AddMaterialView(initialStatus: status)
        }
    }
}
