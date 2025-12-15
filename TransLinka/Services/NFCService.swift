//
//  NFCService.swift
//  TransLinka
//
//  Created on 2024
//
//  NOTE:
//  NFC functionality is currently disabled. This file provides a no-op
//  implementation so the rest of the app can compile without requiring
//  NFC capabilities or entitlements.
//

import Foundation
import Combine

class NFCService: NSObject, ObservableObject {
    static let shared = NFCService()
    
    @Published var isReading = false
    @Published var lastReadMessage: String?
    
    private override init() {
        super.init()
    }
    
    /// Start NFC reading – currently a no-op
    func startReading() {
        // NFC feature is disabled for now
        print("NFCService.startReading() called, but NFC is disabled.")
        isReading = false
    }
    
    /// Stop NFC reading – currently a no-op
    func stopReading() {
        // NFC feature is disabled for now
        isReading = false
    }
    
    /// Write a ticket to NFC – currently a no-op
    func writeTicket(_ ticketData: String) {
        // NFC feature is disabled for now
        print("NFCService.writeTicket(_:) called, but NFC is disabled.")
    }
}

