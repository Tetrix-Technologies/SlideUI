import SwiftUI

/// Renders a complete slide
public struct SlideRenderer: View {
    let slide: SlideSpec
    let theme: ResolvedTheme
    
    public init(slide: SlideSpec, theme: ResolvedTheme) {
        self.slide = slide
        self.theme = theme
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(slide.blocks.indices, id: \.self) { index in
                BlockRenderer(block: slide.blocks[index], theme: theme)
            }
        }
        .padding(slide.padding ?? 60)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
    
    private var alignment: Alignment {
        switch slide.alignment {
        case .center: return .center
        case .trailing: return .trailing
        default: return .leading
        }
    }
}
