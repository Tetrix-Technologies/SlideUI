import XCTest
import SwiftUI
@testable import SlideUI

final class RenderingTests: XCTestCase {
    
    func testThemeResolution() {
        let deckTheme = ThemeSpec(
            backgroundHex: "#1a1a1a",
            titleColorHex: "#ffffff"
        )
        
        let slideTheme = ThemeSpec(
            titleColorHex: "#ff0000"
        )
        
        let resolved = ThemeResolver.resolveTheme(
            slideTheme: slideTheme,
            deckTheme: deckTheme
        )
        
        // Should use slide theme for title color (override)
        XCTAssertEqual(resolved.title, Color(hex: "#ff0000"))
        
        // Should use deck theme for background (no slide override)
        XCTAssertEqual(resolved.background, Color(hex: "#1a1a1a"))
    }
    
    func testDefaultThemeFallback() {
        let resolved = ThemeResolver.resolveTheme(
            slideTheme: nil,
            deckTheme: nil
        )
        
        // Should use default colors
        XCTAssertNotNil(resolved.background)
        XCTAssertNotNil(resolved.title)
        XCTAssertNotNil(resolved.body)
    }
    
    func testColorHexParsing() {
        // Test valid hex colors
        XCTAssertNotNil(Color(hex: "#ffffff"))
        XCTAssertNotNil(Color(hex: "ffffff"))
        XCTAssertNotNil(Color(hex: "#000"))
        XCTAssertNotNil(Color(hex: "000"))
        
        // Test invalid hex colors
        XCTAssertNil(Color(hex: "invalid"))
        XCTAssertNil(Color(hex: "#gggggg"))
    }
}
