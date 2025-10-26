import SwiftUI

/// Environment key for slide theme
public struct SlideThemeKey: EnvironmentKey {
    public static let defaultValue: ThemeSpec? = nil
}

public extension EnvironmentValues {
    var slideTheme: ThemeSpec? {
        get { self[SlideThemeKey.self] }
        set { self[SlideThemeKey.self] = newValue }
    }
}

/// Theme resolution and application utilities
public struct ThemeResolver {
    /// Resolve the effective theme for a slide
    /// Priority: slide theme → deck theme → default
    public static func resolveTheme(
        slideTheme: ThemeSpec?,
        deckTheme: ThemeSpec?
    ) -> ResolvedTheme {
        let effectiveTheme = slideTheme ?? deckTheme
        return ResolvedTheme(from: effectiveTheme)
    }
}

/// Resolved theme with default fallbacks
public struct ResolvedTheme {
    public let background: Color
    public let title: Color
    public let subtitle: Color
    public let body: Color
    public let code: Color
    
    public init(from theme: ThemeSpec?) {
        self.background = Color(hex: theme?.backgroundHex ?? "#1a1a1a") ?? Color.black.opacity(0.96)
        self.title = Color(hex: theme?.titleColorHex ?? "#ffffff") ?? Color.white
        self.subtitle = Color(hex: theme?.subtitleColorHex ?? "#ffffff") ?? Color.white.opacity(0.85)
        self.body = Color(hex: theme?.bodyColorHex ?? "#e0e0e0") ?? Color.white
        self.code = Color(hex: theme?.codeColorHex ?? "#ffffff") ?? Color.white
    }
}
