#if os(macOS)
import AppKit
import SwiftUI

/// macOS keyboard handler for slide navigation
public struct KeyboardHandler: NSViewRepresentable {
    let onLeft: () -> Void
    let onRight: () -> Void
    
    public init(onLeft: @escaping () -> Void, onRight: @escaping () -> Void) {
        self.onLeft = onLeft
        self.onRight = onRight
    }
    
    public func makeNSView(context: Context) -> NSView {
        let view = NSView()
        NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { event in
            switch event.keyCode {
            case 123: onLeft()  // left arrow
            case 124: onRight() // right arrow
            case 36: onRight()  // return/enter
            case 53: onLeft()   // escape (go back)
            default: break
            }
            return event
        }
        return view
    }
    
    public func updateNSView(_ nsView: NSView, context: Context) {}
}
#endif
