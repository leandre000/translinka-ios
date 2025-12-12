//
//  BlockchainManager.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation

enum BlockchainType {
    case ethereum
    case solana
}

class BlockchainManager {
    static let shared = BlockchainManager()
    
    private var currentBlockchain: BlockchainType = .ethereum
    private let ethereumService = EthereumService.shared
    private let solanaService = SolanaService.shared
    
    private init() {}
    
    /// Create a ticket on the selected blockchain
    /// - Parameters:
    ///   - bookingId: Unique booking identifier
    ///   - userId: User identifier
    ///   - routeId: Route identifier
    ///   - price: Price in standard currency (will be converted to blockchain units)
    /// - Returns: Transaction hash or NFT mint address
    func createTicket(
        bookingId: String,
        userId: String,
        routeId: String,
        price: Double
    ) async throws -> String {
        switch currentBlockchain {
        case .ethereum:
            // Convert price to Wei (1 ETH = 10^18 Wei)
            // Using UInt64 for placeholder, use BigUInt in production with Web3.swift
            let priceInWei = UInt64(price * 1_000_000_000_000_000_000)
            return try await ethereumService.createTicketTransaction(
                bookingId: bookingId,
                userId: userId,
                routeId: routeId,
                price: priceInWei
            )
        case .solana:
            let metadata = TicketMetadata(
                name: "TransLinka Ticket",
                description: "Bus ticket for route \(routeId)",
                image: "",
                attributes: []
            )
            return try await solanaService.createTicketNFT(
                bookingId: bookingId,
                metadata: metadata
            )
        }
    }
    
    func verifyTicket(transactionHash: String) async throws -> Bool {
        switch currentBlockchain {
        case .ethereum:
            return try await ethereumService.verifyTicket(transactionHash: transactionHash)
        case .solana:
            return try await solanaService.verifyTicketNFT(mintAddress: transactionHash)
        }
    }
    
    func setBlockchain(_ type: BlockchainType) {
        currentBlockchain = type
    }
}

