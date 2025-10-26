import Foundation

/// Represents a single slide in a deck
public struct SlideSpec: Codable, Identifiable {
    /// Unique identifier for the slide
    private var _id: String = UUID().uuidString
    public var id: String { _id }
    
    /// Alignment of content within the slide
    public var alignment: SlideAlignmentSpec?
    
    /// Padding around the slide content
    public var padding: CGFloat?
    
    /// Per-slide theme override
    public var theme: ThemeSpec?
    
    /// Array of content blocks for this slide
    public var blocks: [BlockSpec]
    
    /// Custom decoder to handle missing `id` in JSON
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = (try? container.decode(String.self, forKey: ._id)) ?? UUID().uuidString
        self.alignment = try? container.decode(SlideAlignmentSpec.self, forKey: .alignment)
        self.padding = try? container.decode(CGFloat.self, forKey: .padding)
        self.theme = try? container.decode(ThemeSpec.self, forKey: .theme)
        self.blocks = (try? container.decode([BlockSpec].self, forKey: .blocks)) ?? []
    }
    
    /// Manual CodingKeys mapping `_id` to the JSON key "id"
    enum CodingKeys: String, CodingKey { 
        case _id = "id", alignment, padding, theme, blocks 
    }
    
    /// Default memberwise initializer
    public init(
        id: String = UUID().uuidString,
        alignment: SlideAlignmentSpec? = nil,
        padding: CGFloat? = nil,
        theme: ThemeSpec? = nil,
        blocks: [BlockSpec]
    ) {
        self._id = id
        self.alignment = alignment
        self.padding = padding
        self.theme = theme
        self.blocks = blocks
    }
}

/// Alignment options for slide content
public enum SlideAlignmentSpec: String, Codable {
    case leading, center, trailing
}
