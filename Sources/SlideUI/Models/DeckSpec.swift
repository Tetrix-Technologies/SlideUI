import Foundation

/// Represents a complete slide deck specification
public struct DeckSpec: Codable {
    /// The title of the deck
    public var title: String
    
    /// Optional theme configuration for the entire deck
    public var theme: ThemeSpec?
    
    /// Optional transition configuration for slide changes
    public var transitions: TransitionSpec?
    
    /// Array of slides in the deck
    public var slides: [SlideSpec]
    
    public init(
        title: String,
        theme: ThemeSpec? = nil,
        transitions: TransitionSpec? = nil,
        slides: [SlideSpec]
    ) {
        self.title = title
        self.theme = theme
        self.transitions = transitions
        self.slides = slides
    }
}
