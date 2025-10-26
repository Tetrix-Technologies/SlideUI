import Foundation

/// Theme configuration for slides and decks
public struct ThemeSpec: Codable {
    /// Optional theme name for reference
    public var name: String?
    
    /// Background color as hex string (e.g., "#1a1a1a")
    public var backgroundHex: String?
    
    /// Title text color as hex string
    public var titleColorHex: String?
    
    /// Subtitle text color as hex string
    public var subtitleColorHex: String?
    
    /// Body text color as hex string
    public var bodyColorHex: String?
    
    /// Code text color as hex string
    public var codeColorHex: String?
    
    public init(
        name: String? = nil,
        backgroundHex: String? = nil,
        titleColorHex: String? = nil,
        subtitleColorHex: String? = nil,
        bodyColorHex: String? = nil,
        codeColorHex: String? = nil
    ) {
        self.name = name
        self.backgroundHex = backgroundHex
        self.titleColorHex = titleColorHex
        self.subtitleColorHex = subtitleColorHex
        self.bodyColorHex = bodyColorHex
        self.codeColorHex = codeColorHex
    }
}
