import SwiftUI
import AVKit

/// Renders individual content blocks
public struct BlockRenderer: View {
    let block: BlockSpec
    let theme: ResolvedTheme
    
    public init(block: BlockSpec, theme: ResolvedTheme) {
        self.block = block
        self.theme = theme
    }
    
    public var body: some View {
        switch block {
        case .title(let text, let subtitle):
            TitleBlockView(text: text, subtitle: subtitle, theme: theme)
        case .words(let text):
            WordsBlockView(text: text, theme: theme)
        case .bullets(let style, let items):
            BulletsBlockView(style: style, items: items, theme: theme)
        case .media(let source):
            MediaBlockView(source: source, theme: theme)
        case .video(let source, let autoplay, let loop):
            VideoBlockView(source: source, autoplay: autoplay, loop: loop, theme: theme)
        case .link(let text, let url):
            LinkBlockView(text: text, url: url, theme: theme)
        case .columns(let columns):
            ColumnsBlockView(columns: columns, theme: theme)
        case .code(let code, let enableHighlight):
            CodeBlockView(code: code, enableHighlight: enableHighlight, theme: theme)
        }
    }
}

// MARK: - Individual Block Views

private struct TitleBlockView: View {
    let text: String
    let subtitle: String?
    let theme: ResolvedTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(text)
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(theme.title)
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: 36, weight: .light))
                    .italic()
                    .foregroundColor(theme.subtitle)
            }
        }
    }
}

private struct WordsBlockView: View {
    let text: String
    let theme: ResolvedTheme
    
    var body: some View {
        Text(text)
            .font(.system(size: 36))
            .foregroundColor(theme.body)
    }
}

private struct BulletsBlockView: View {
    let style: BulletStyleSpec?
    let items: [String]
    let theme: ResolvedTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items.indices, id: \.self) { index in
                let item = items[index]
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text(bulletCharacter)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(theme.body)
                    Text(item)
                        .font(.system(size: 36))
                        .foregroundColor(theme.body)
                }
            }
        }
    }
    
    private var bulletCharacter: String {
        style == .dash ? "–" : "•"
    }
}

private struct MediaBlockView: View {
    let source: MediaSourceSpec
    let theme: ResolvedTheme
    
    var body: some View {
        Group {
            switch source {
            case .asset(let name):
                Image(name)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 420)
            case .bundle(let file):
                #if os(macOS)
                Image(nsImage: NSImage(contentsOfFile: file) ?? NSImage())
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 420)
                #else
                Text("Bundle image unsupported on this platform")
                    .foregroundColor(theme.body)
                #endif
            case .remote(let url):
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                        .foregroundColor(theme.body)
                }
                .frame(maxHeight: 420)
            case .videoAsset, .videoBundle, .videoRemote:
                Text("Video source used in media block - use video block instead")
                    .foregroundColor(theme.body)
            }
        }
    }
}

private struct VideoBlockView: View {
    let source: MediaSourceSpec
    let autoplay: Bool
    let loop: Bool
    let theme: ResolvedTheme
    
    var body: some View {
        Group {
            switch source {
            case .videoAsset(let name):
                VideoPlayerView(
                    player: createPlayer(for: .videoAsset(name: name)),
                    autoplay: autoplay,
                    loop: loop
                )
            case .videoBundle(let file):
                VideoPlayerView(
                    player: createPlayer(for: .videoBundle(file: file)),
                    autoplay: autoplay,
                    loop: loop
                )
            case .videoRemote(let url):
                VideoPlayerView(
                    player: createPlayer(for: .videoRemote(url: url)),
                    autoplay: autoplay,
                    loop: loop
                )
            default:
                Text("Non-video source used in video block")
                    .foregroundColor(theme.body)
            }
        }
        .frame(maxHeight: 420)
    }
    
    private func createPlayer(for source: MediaSourceSpec) -> AVPlayer {
        let url: URL
        
        switch source {
        case .videoAsset(let name):
            guard let assetURL = Bundle.main.url(forResource: name, withExtension: nil) else {
                return AVPlayer()
            }
            url = assetURL
        case .videoBundle(let file):
            url = URL(fileURLWithPath: file)
        case .videoRemote(let remoteURL):
            url = remoteURL
        default:
            return AVPlayer()
        }
        
        return AVPlayer(url: url)
    }
}

private struct VideoPlayerView: View {
    let player: AVPlayer
    let autoplay: Bool
    let loop: Bool
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                if autoplay {
                    player.play()
                }
                if loop {
                    NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: player.currentItem,
                        queue: .main
                    ) { _ in
                        player.seek(to: .zero)
                        player.play()
                    }
                }
            }
    }
}

private struct LinkBlockView: View {
    let text: String
    let url: URL
    let theme: ResolvedTheme
    
    var body: some View {
        Link(text, destination: url)
            .font(.system(size: 36))
            .foregroundColor(theme.body)
    }
}

private struct ColumnsBlockView: View {
    let columns: [[BlockSpec]]
    let theme: ResolvedTheme
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            ForEach(columns.indices, id: \.self) { index in
                let columnBlocks = columns[index]
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(columnBlocks.indices, id: \.self) { blockIndex in
                        BlockRenderer(block: columnBlocks[blockIndex], theme: theme)
                    }
                }
            }
        }
    }
}

private struct CodeBlockView: View {
    let code: String
    let enableHighlight: Bool?
    let theme: ResolvedTheme
    
    var body: some View {
        ScrollView {
            Text(code)
                .font(.system(size: 22, weight: .regular, design: .monospaced))
                .textSelection(.enabled)
                .foregroundColor(theme.code)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
        }
        .frame(maxHeight: 420)
        .background(theme.background.opacity(0.7))
        .cornerRadius(8)
    }
}
