//
//  ChatViewModel.swift
//  StudyMaterial
//
//  Created by Muhammad Najmi Rahmani  on 23/06/26.
//

import Foundation
import FoundationModels

@Observable
class ChatViewModel {
    
    
    var chatSession: ChatSession
    var chatMessages: [ChatMessage] = []
    var query: String = ""
    var context: [String] = []
    
    var partial: String.PartiallyGenerated?
    
    var partialId: UUID?
    
    private var streamingTask: Task<Void, Never>?
    
    private var modelSession: LanguageModelSession
    private let instructions: String  = "You are a teacher that will gives an answer based on the context given"
    
    init() {
        self.chatSession = ChatSession(id: UUID(), title: "", chatMessage: [])
        self.modelSession = LanguageModelSession(instructions: instructions)
    }
    
    func sendMessage() {
        chatMessages.append(ChatMessage(id: UUID(), text: query, sender: .user))
        
        streamingTask = Task {
            do {
                var contexts = await RAGManager.shared?.searchText(query: query)
                
                let contextText = contexts?.joined(separator: "\n") ?? ""
                let prompt: String

                if contextText.isEmpty {
                    prompt = """
                    You are a helpful assistant that answers questions based on your own knowledge.

                    Question: \(query)

                    Instructions:
                    - Answer concisely and accurately
                    """
                } else {
                    prompt = """
                    You are a helpful assistant that answers questions based on the provided context from uploaded documents and knowledge base.

                    Context:
                    \(contextText)

                    Question: \(query)

                    Instructions:
                    - Prioritize information from context
                    - If context doesn't contain relevant info, say so
                    - Be concise and accurate
                    """
                }
                let prompt2 = query
                print(contexts)
                print(RAGManager.shared?.scores)
                print(contexts?.count)
                let stream = modelSession.streamResponse(to: prompt)
                self.partialId = UUID()
                
                for try await partial in stream {
                    self.partial = partial.content
                }
                
                guard !Task.isCancelled else { return }
                
                chatMessages.append(ChatMessage(id: partialId ?? UUID(), text: partial ?? "", sender: .assistant))
                
                self.partial = nil
                self.partialId = nil
                self.streamingTask = nil
                contexts = []
            } catch {
                print("error: \(error)")
                if let error = error as? FoundationModels.LanguageModelSession.GenerationError {
                    print("error: \(error.localizedDescription)")
                }
                
                streamingTask = nil
            }
        }
    }
    
    // beresin without session dulu
    func createSession() {
        
    }
    
    func reset() {
        chatMessages = []
        query = ""
        
        streamingTask?.cancel()
        streamingTask = nil
        
        modelSession = LanguageModelSession(instructions: instructions)
    }
}
