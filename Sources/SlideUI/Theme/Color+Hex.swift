import SwiftUI

extension Color {
    /// Initialize a Color from a hex string
    /// - Parameter hex: Hex string (e.g., "#1a1a1a" or "1a1a1a")
    public init?(hex: String) {
        var hexString = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        
        // Handle 3-character hex (e.g., "abc" -> "aabbcc")
        if hexString.count == 3 {
            hexString = hexString.map { "\($0)\($0)" }.joined()
        }
        
        guard hexString.count == 6, let value = Int(hexString, radix: 16) else { 
            return nil 
        }
        
        self = Color(
            red: Double((value >> 16) & 0xFF) / 255.0,
            green: Double((value >> 8) & 0xFF) / 255.0,
            blue: Double(value & 0xFF) / 255.0
        )
    }
}
