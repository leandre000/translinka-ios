//
//  QRCodeService.swift
//  TransLinka
//
//  Created on 2024
//

import Foundation
import CoreImage
import SwiftUI

class QRCodeService {
    static let shared = QRCodeService()
    
    private init() {}
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        
        guard let output = filter.outputImage?.transformed(by: transform) else {
            return nil
        }
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(output, from: output.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    func validateQRCode(_ qrCode: String) -> Bool {
        // In production, this would validate against the blockchain
        return !qrCode.isEmpty
    }
}

