//
//  ChatbotService.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation

struct ChatMessage: Identifiable {
    let id: String
    let content: String
    let isUser: Bool
    let timestamp: Date
    
    init(id: String = UUID().uuidString, content: String, isUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.content = content
        self.isUser = isUser
        self.timestamp = timestamp
    }
}

class ChatbotService {
    static let shared = ChatbotService()
    
    private let responses: [String: String] = [
        "hello": "Hello! How can I help you with your TransLinka booking today?",
        "book": "I can help you book a ticket! Please use the search function on the home screen to find available routes.",
        "cancel": "To cancel a booking, go to your bookings section and select the ticket you want to cancel.",
        "refund": "Refunds are processed within 5-7 business days. Please contact support for urgent refund requests.",
        "payment": "We accept Credit/Debit Cards, PayPal, Google Pay, and Apple Pay.",
        "help": "I'm here to help! You can ask me about booking tickets, canceling bookings, payment methods, or any other questions about TransLinka."
    ]
    
    private init() {}
    
    func getResponse(for message: String) async -> String {
        // Simulate AI processing delay
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        let lowercased = message.lowercased()
        
        // Simple keyword matching (in production, this would use AI/ML)
        for (keyword, response) in responses {
            if lowercased.contains(keyword) {
                return response
            }
        }
        
        return "I understand you're asking about '\(message)'. For more specific help, please contact our support team or check the Help Center in your profile."
    }
}

