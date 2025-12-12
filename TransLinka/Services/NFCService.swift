//
//  NFCService.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation
import CoreNFC

class NFCService: NSObject, ObservableObject {
    static let shared = NFCService()
    
    @Published var isReading = false
    @Published var lastReadMessage: String?
    
    private var session: NFCNDEFReaderSession?
    
    private override init() {
        super.init()
    }
    
    func startReading() {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC reading not available on this device")
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.begin()
        isReading = true
    }
    
    func stopReading() {
        session?.invalidateSession()
        isReading = false
    }
    
    func writeTicket(_ ticketData: String) {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC writing not available on this device")
            return
        }
        
        // Implementation for writing NFC tags
        // This would require NFCNDEFWriterSession
    }
}

extension NFCService: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async {
            self.isReading = false
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        DispatchQueue.main.async {
            if let message = messages.first,
               let payload = message.records.first?.payload,
               let string = String(data: payload, encoding: .utf8) {
                self.lastReadMessage = string
            }
        }
    }
}

