//
//  ChatMessage.swift
//  StudyMaterial
//
//  Created by Muhammad Najmi Rahmani  on 23/06/26.
//

import Foundation
import SwiftData


struct ChatMessage: Identifiable, Codable {
    
    enum Sender: Codable {
        case user, assistant
    }
    
    let id: UUID
    let text: String
    let sender: Sender
    
    init(id: UUID, text: String, sender: Sender) {
        self.id = id
        self.text = text
        self.sender = sender
    }
}

@Model
class ChatSession {
    var id: UUID
    var title: String
    var chatMessage: [ChatMessage]
    
    init(id: UUID, title: String, chatMessage: [ChatMessage]) {
        self.id = id
        self.title = title
        self.chatMessage = chatMessage
    }
}
