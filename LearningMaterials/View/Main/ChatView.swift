//
//  ChatView.swift
//  StudyMaterial
//
//  Created by Muhammad Najmi Rahmani  on 23/06/26.
//

import SwiftUI
import FoundationModels

struct ChatView: View {
    
    @Bindable var chatViewModel: ChatViewModel
    
    var body: some View {
        VStack(alignment: .trailing) {
            Button {
                chatViewModel.reset()
            } label: {
                Text("Reset")
            }
            .padding()
            .buttonStyle(.borderedProminent)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(chatViewModel.chatMessages) { message in
                        Text(message.text)
                            .modifier(StreamingViewModifier(sender: message.sender))
                    }
                    
                    if let partial = chatViewModel.partial , let id = chatViewModel.partialId {
                        StreamingResponseView(partial: partial)
                            .id(id)
                    }
                    
                }
                .padding()
                .padding(.bottom, 100)
            }
            
            HStack {
                TextField("Write a question here...", text: $chatViewModel.query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        chatViewModel.sendMessage()
                    }
                Button("Send") {
                    chatViewModel.sendMessage()
                }
//                .disabled(viewModel.isResponding)
            }
            .padding()
        }
    }
}

struct StreamingResponseView: View {
    
    let partial: String.PartiallyGenerated
    
    var body: some View {
        Text(partial)
            .modifier(StreamingViewModifier(sender: .assistant))
            .contentTransition(.opacity)
            .animation(.easeInOut(duration: 0.7), value: partial)
    }
}


struct StreamingViewModifier: ViewModifier {
    
    let sender: ChatMessage.Sender
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(sender == .user ? Color.blue.opacity(0.3) : Color.gray.opacity(0.3))
            .cornerRadius(12)
            .padding(sender == .user ? .leading : .trailing, 20)
            .frame(maxWidth: .infinity,
                   alignment: sender == .user ? .trailing : .leading)
    }
}

#Preview {
    @Previewable @State var chatViewModel = ChatViewModel()
    ChatView(chatViewModel: chatViewModel)
}
