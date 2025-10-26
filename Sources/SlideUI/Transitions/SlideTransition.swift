import SwiftUI

/// Slide transition utilities
public struct SlideTransition {
    /// Create a transition based on the transition spec
    public static func transition(for spec: TransitionSpec?) -> AnyTransition {
        guard let spec = spec else { return .identity }
        
        switch spec.type {
        case .none:
            return .identity
        case .slide:
            return .asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)
            )
        case .fade:
            return .opacity
        case .scale:
            return .scale
        case .push:
            return .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            )
        }
    }
    
    /// Animation for the transition
    public static func animation(for spec: TransitionSpec?) -> Animation {
        guard let spec = spec else { return .default }
        return .easeInOut(duration: spec.duration)
    }
}
