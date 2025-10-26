import SwiftUI

/// SlideUI - A SwiftUI package for rendering stunning slide decks from JSON
///
/// SlideUI provides a complete solution for creating and presenting slide decks
/// from JSON specifications. It supports themes, transitions, media, video,
/// interactive elements, and works on both iOS and macOS.
///
/// ## Quick Start
///
/// ```swift
/// import SlideUI
///
/// // Simple usage with JSON string
/// PresenterView(slideDeck: jsonString)
///
/// // Or with pre-parsed deck
/// let deck = try JSONDecoder().decode(DeckSpec.self, from: jsonData)
/// PresenterView(spec: deck)
/// ```
///
/// ## Custom Rendering
///
/// For custom presenter UIs, use the modular components:
///
/// ```swift
/// let theme = ThemeResolver.resolveTheme(slideTheme: nil, deckTheme: deck.theme)
/// SlideRenderer(slide: deck.slides[index], theme: theme)
/// ```
public enum SlideUI {}
