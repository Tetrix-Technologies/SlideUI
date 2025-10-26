import SwiftUI
import AVKit

/// Specialized media rendering utilities
public struct MediaRenderer {
    /// Create an image view from a media source
    public static func imageView(from source: MediaSourceSpec, maxHeight: CGFloat = 420) -> some View {
        Group {
            switch source {
            case .asset(let name):
                Image(name)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: maxHeight)
            case .bundle(let file):
                #if os(macOS)
                Image(nsImage: NSImage(contentsOfFile: file) ?? NSImage())
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: maxHeight)
                #else
                Text("Bundle image unsupported on this platform")
                    .foregroundColor(.secondary)
                #endif
            case .remote(let url):
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxHeight: maxHeight)
            case .videoAsset, .videoBundle, .videoRemote:
                Text("Video source used in image context")
                    .foregroundColor(.secondary)
            }
        }
    }
    
    /// Create a video player view from a video source
    public static func videoView(
        from source: MediaSourceSpec,
        autoplay: Bool = false,
        loop: Bool = false,
        maxHeight: CGFloat = 420
    ) -> some View {
        VideoPlayerView(
            player: createPlayer(for: source),
            autoplay: autoplay,
            loop: loop
        )
        .frame(maxHeight: maxHeight)
    }
    
    private static func createPlayer(for source: MediaSourceSpec) -> AVPlayer {
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
