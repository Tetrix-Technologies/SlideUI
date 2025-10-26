# SlideUI

A SwiftUI package for rendering stunning slide decks from JSON. Create beautiful presentations with themes, transitions, media, video, and interactive elements that work on both iOS and macOS.

## Features

- **Themes**: Custom colors and styling for your presentations
- **Transitions**: Smooth slide transitions with multiple animation types
- **Cross-Platform**: Works on iOS 17+ and macOS 14+
- **Media Support**: Images and videos from assets, bundles, or remote URLs
- **Interactive Elements**: Clickable links within slides
- **Modular**: Use complete presenter or build custom UI with components
- **Keyboard Navigation**: Arrow keys and shortcuts on macOS

## Example

<img width="1188" height="788" alt="Screenshot 2025-10-26 at 7 55 51 pm" src="https://github.com/user-attachments/assets/40c56ae2-d59c-48e9-8799-0ace5a6504bf" />


## Installation

Add SlideUI to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/SlideUI.git", from: "1.0.0")
]
```

## Quick Start

### Option 1: Complete Presenter (Simplest)

```swift
import SlideUI

struct ContentView: View {
    let jsonString = """
    {
        "title": "My Presentation",
        "slides": [
            {
                "blocks": [
                    { "type": "title", "text": "Welcome", "subtitle": "to SlideUI" },
                    { "type": "words", "text": "Create beautiful presentations from JSON" }
                ]
            }
        ]
    }
    """
    
    var body: some View {
        try? PresenterView(slideDeck: jsonString)
    }
}
```

### Option 2: Custom Presenter (Flexible)

```swift
import SlideUI

struct CustomPresenterView: View {
    let deck: DeckSpec
    @State private var currentSlide = 0
    
    var body: some View {
        VStack {
            // Your custom navigation
            HStack {
                Button("Previous") { currentSlide -= 1 }
                Text("\(currentSlide + 1) / \(deck.slides.count)")
                Button("Next") { currentSlide += 1 }
            }
            
            // Render current slide
            if deck.slides.indices.contains(currentSlide) {
                let theme = ThemeResolver.resolveTheme(
                    slideTheme: deck.slides[currentSlide].theme,
                    deckTheme: deck.theme
                )
                SlideRenderer(slide: deck.slides[currentSlide], theme: theme)
            }
        }
    }
}
```

## JSON Schema

### Basic Structure

```json
{
    "title": "My Deck",
    "theme": {
        "backgroundHex": "#1a1a1a",
        "titleColorHex": "#ffffff",
        "bodyColorHex": "#e0e0e0"
    },
    "transitions": {
        "type": "slide",
        "duration": 0.3
    },
    "slides": [
        {
            "alignment": "leading",
            "padding": 60,
            "blocks": [
                { "type": "title", "text": "Hello", "subtitle": "World" },
                { "type": "words", "text": "This is a text block" },
                { "type": "bullets", "style": "bullets", "items": ["Item 1", "Item 2"] },
                { "type": "media", "source": { "kind": "remote", "url": "https://example.com/image.jpg" } },
                { "type": "video", "source": { "kind": "remote", "url": "https://example.com/video.mp4" }, "autoplay": true, "loop": false },
                { "type": "link", "text": "Visit Site", "url": "https://example.com" },
                { "type": "code", "code": "print(\"Hello World\")", "enableHighlight": true }
            ]
        }
    ]
}
```

### Block Types

#### Title Block
```json
{ "type": "title", "text": "Main Title", "subtitle": "Optional Subtitle" }
```

#### Words Block
```json
{ "type": "words", "text": "Your text content here" }
```

#### Bullets Block
```json
{ "type": "bullets", "style": "bullets", "items": ["First item", "Second item"] }
```
Styles: `"bullets"` (•) or `"dash"` (–)

#### Media Block
```json
{ "type": "media", "source": { "kind": "remote", "url": "https://example.com/image.jpg" } }
```
Sources: `"asset"`, `"bundle"`, `"remote"`

#### Video Block
```json
{ "type": "video", "source": { "kind": "remote", "url": "https://example.com/video.mp4" }, "autoplay": true, "loop": false }
```

#### Link Block
```json
{ "type": "link", "text": "Click here", "url": "https://example.com" }
```

#### Code Block
```json
{ "type": "code", "code": "print(\"Hello World\")", "enableHighlight": true }
```

#### Columns Block
```json
{ "type": "columns", "columns": [
    [{ "type": "words", "text": "Left column" }],
    [{ "type": "words", "text": "Right column" }]
]}
```

### Media Sources

#### Asset Images/Videos
```json
{ "kind": "asset", "name": "my-image" }
{ "kind": "videoAsset", "name": "my-video" }
```

#### Bundle Files
```json
{ "kind": "bundle", "file": "/path/to/file.jpg" }
{ "kind": "videoBundle", "file": "/path/to/video.mp4" }
```

#### Remote URLs
```json
{ "kind": "remote", "url": "https://example.com/image.jpg" }
{ "kind": "videoRemote", "url": "https://example.com/video.mp4" }
```

### Themes

```json
{
    "theme": {
        "name": "Dark Theme",
        "backgroundHex": "#1a1a1a",
        "titleColorHex": "#ffffff",
        "subtitleColorHex": "#e0e0e0",
        "bodyColorHex": "#cccccc",
        "codeColorHex": "#00ff00"
    }
}
```

### Transitions

```json
{
    "transitions": {
        "type": "slide",
        "duration": 0.3
    }
}
```

Available transition types:
- `"none"` - No transition
- `"slide"` - Slide from right to left
- `"fade"` - Fade in/out
- `"scale"` - Scale in/out
- `"push"` - Push transition

## API Reference

### Core Types

- `DeckSpec` - Complete deck specification
- `SlideSpec` - Individual slide with blocks and alignment
- `BlockSpec` - Content blocks (title, words, bullets, media, etc.)
- `ThemeSpec` - Color and styling configuration
- `TransitionSpec` - Animation configuration

### Main Views

- `PresenterView` - Complete presenter with navigation
- `SlideRenderer` - Render individual slides
- `BlockRenderer` - Render individual blocks

### Utilities

- `ThemeResolver` - Resolve effective themes
- `SlideTransition` - Apply slide transitions
- `MediaRenderer` - Handle media sources

## Platform Support

- **iOS 17+**: Full support with touch navigation
- **macOS 14+**: Full support with keyboard navigation (arrow keys, return, escape)

## Examples

Check out the `DeckKitApp` example in this repository for a complete working example.

## License

MIT License - see LICENSE file for details.
