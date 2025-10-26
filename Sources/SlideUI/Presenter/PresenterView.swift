import SwiftUI

/// Complete presenter view with navigation controls
public struct PresenterView: View {
    let spec: DeckSpec
    @State private var index: Int = 0
    @State private var decodeError: String? = nil
    
    /// Initialize with JSON string
    public init(slideDeck jsonString: String) throws {
        let data = Data(jsonString.utf8)
        self.spec = try JSONDecoder().decode(DeckSpec.self, from: data)
    }
    
    /// Initialize with pre-parsed deck spec
    public init(spec: DeckSpec) {
        self.spec = spec
    }
    
    public var body: some View {
        ZStack {
            // Background with theme support
            themeBackground
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                // Title bar
                titleBar
                
                // Slide content with transitions
                GeometryReader { geometry in
                    slideContent(geometry: geometry)
                }
                
                // Navigation controls
                navigationControls
            }
        }
        #if os(macOS)
        .background(KeyboardHandler(onLeft: previous, onRight: next))
        #endif
    }
    
    // MARK: - View Components
    
    private var themeBackground: some View {
        let resolvedTheme = ThemeResolver.resolveTheme(
            slideTheme: nil,
            deckTheme: spec.theme
        )
        return resolvedTheme.background
    }
    
    private var titleBar: some View {
        HStack {
            Text(spec.title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white.opacity(0.85))
            Spacer()
            Text("\(index + 1) / \(spec.slides.count)")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private func slideContent(geometry: GeometryProxy) -> some View {
        ZStack {
            if spec.slides.indices.contains(index) {
                let slide = spec.slides[index]
                let resolvedTheme = ThemeResolver.resolveTheme(
                    slideTheme: slide.theme,
                    deckTheme: spec.theme
                )
                
                SlideRenderer(slide: slide, theme: resolvedTheme)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .transition(SlideTransition.transition(for: spec.transitions))
                    .animation(SlideTransition.animation(for: spec.transitions), value: index)
            }
        }
    }
    
    private var navigationControls: some View {
        HStack(spacing: 12) {
            Button(action: previous) {
                Image(systemName: "chevron.left")
            }
            .disabled(index == 0)
            
            Slider(
                value: Binding(
                    get: { Double(index) },
                    set: { index = max(0, min(Int($0), spec.slides.count - 1)) }
                ),
                in: 0...Double(max(spec.slides.count - 1, 0))
            )
            .frame(maxWidth: 300)
            
            Button(action: next) {
                Image(systemName: "chevron.right")
            }
            .disabled(index >= spec.slides.count - 1)
        }
        .buttonStyle(.borderedProminent)
        .tint(.white)
        .foregroundColor(.black)
        .padding(.bottom, 12)
    }
    
    // MARK: - Navigation Actions
    
    private func previous() {
        withAnimation(SlideTransition.animation(for: spec.transitions)) {
            index = max(index - 1, 0)
        }
    }
    
    private func next() {
        withAnimation(SlideTransition.animation(for: spec.transitions)) {
            index = min(index + 1, max(spec.slides.count - 1, 0))
        }
    }
}

/// Error view for presentation failures
public struct PresentationErrorView: View {
    let error: String
    
    public init(error: String) {
        self.error = error
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            Text("Failed to load presentation")
                .font(.title2)
                .foregroundColor(.primary)
            Text(error)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
        }
        .padding()
    }
}
