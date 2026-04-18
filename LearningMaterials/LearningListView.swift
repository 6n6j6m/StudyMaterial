//
//  LearningListView.swift
//  MyBookShelf
//

import SwiftUI
import SwiftData

struct LearningListView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowingAddSheet = false
    @State private var searchText = ""
    
    // SWIFTDATA: Mengambil semua task dari database
    @Query(sort: \LearningTask.topic) private var allTasks: [LearningTask]
    
    let status: StudyStatus
    let title: String

    // Filter secara lokal (untuk saat ini)
    var filteredTasks: [LearningTask] {
        if searchText.isEmpty {
            return allTasks.filter { $0.status == status }
        }
        else {
            let searchText = searchText.lowercased()
            return allTasks.filter {
                $0.topic.lowercased().contains(searchText)
                || $0.topic.lowercased().contains(searchText)
                || $0.note.lowercased().contains(searchText)
            }.filter { $0.status == status }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // Di belakang floating action button (layer 1)
                VStack {
                    // Kosong
                    if filteredTasks.isEmpty {
                        Spacer()
                        ContentUnavailableView(
                            "Empty List",
                            systemImage: Constants.closedbookIconString,
                            description: Text("No items in \(title)")
                        )
                        Spacer()
                    } else {
                        // Show the data
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
                                
                                // Swipe Action
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
                            
                            // Delete trailing untuk data yang di loop ForEach
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

                // Floating action button (layer 2)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            isShowingAddSheet = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title2.bold())
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                                .frame(width: 60, height: 60)
                                .background(Color.primary)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                    
                    }
                    .padding(20)
                    .padding(.bottom, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(title)
        }
        .searchable(text: $searchText, prompt: "Cari Materi")
        .sheet(isPresented: $isShowingAddSheet) {
            AddMaterialView(initialStatus: status)
        }
    }
}

#Preview {
    LearningListView(status: .completed, title: Constants.completedString)
        .modelContainer(for: LearningTask.self, inMemory: true)
}
