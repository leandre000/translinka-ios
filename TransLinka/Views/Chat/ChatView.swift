//
//  ChatView.swift
//  TransLinka
//
//  Created on 2024
//

import SwiftUI

struct ChatView: View {
    @StateObject private var chatViewModel = ChatViewModel()
    @State private var messageText = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Messages List
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: Theme.spacingMedium) {
                            ForEach(chatViewModel.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: chatViewModel.messages.count) { _ in
                        if let lastMessage = chatViewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Input Area
                HStack(spacing: Theme.spacingMedium) {
                    TextField("Type your message...", text: $messageText)
                        .textFieldStyle(CustomTextFieldStyle())
                        .onSubmit {
                            sendMessage()
                        }
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Theme.primaryBlue)
                            .cornerRadius(Theme.cornerRadiusMedium)
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding()
                .background(Theme.cardBackground)
            }
            .navigationTitle("Chat Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        chatViewModel.sendMessage(messageText)
        messageText = ""
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding()
                    .background(message.isUser ? Theme.primaryBlue : Color.gray.opacity(0.2))
                    .foregroundColor(message.isUser ? .white : Theme.textPrimary)
                    .cornerRadius(Theme.cornerRadiusMedium)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(Theme.textSecondary)
            }
            .frame(maxWidth: 250, alignment: message.isUser ? .trailing : .leading)
            
            if !message.isUser {
                Spacer()
            }
        }
    }
}

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    private let chatbotService = ChatbotService.shared
    
    init() {
        addWelcomeMessage()
    }
    
    private func addWelcomeMessage() {
        let welcomeMessage = ChatMessage(
            content: "Hello! I'm your TransLinka AI assistant. How can I help you today?",
            isUser: false
        )
        messages.append(welcomeMessage)
    }
    
    func sendMessage(_ text: String) {
        let userMessage = ChatMessage(content: text, isUser: true)
        messages.append(userMessage)
        
        Task {
            let response = await chatbotService.getResponse(for: text)
            let botMessage = ChatMessage(content: response, isUser: false)
            await MainActor.run {
                messages.append(botMessage)
            }
        }
    }
}

#Preview {
    ChatView()
}

