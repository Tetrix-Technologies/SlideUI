import Foundation

/// Transition configuration for slide changes
public struct TransitionSpec: Codable {
    /// Type of transition animation
    public var type: TransitionType
    
    /// Duration of the transition in seconds
    public var duration: Double
    
    public init(type: TransitionType, duration: Double) {
        self.type = type
        self.duration = duration
    }
}

/// Available transition types
public enum TransitionType: String, Codable {
    case none
    case slide
    case fade
    case scale
    case push
}
