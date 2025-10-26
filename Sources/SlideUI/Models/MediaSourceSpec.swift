import Foundation

/// Represents a media source for images and videos
public enum MediaSourceSpec: Codable {
    case asset(name: String)
    case bundle(file: String)
    case remote(url: URL)
    case videoAsset(name: String)
    case videoBundle(file: String)
    case videoRemote(url: URL)
    
    enum CodingKeys: String, CodingKey { case kind, name, file, url }
    enum Kind: String, Codable { 
        case asset, bundle, remote, videoAsset, videoBundle, videoRemote 
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Kind.self, forKey: .kind) {
        case .asset:  
            self = .asset(name: try container.decode(String.self, forKey: .name))
        case .bundle: 
            self = .bundle(file: try container.decode(String.self, forKey: .file))
        case .remote: 
            self = .remote(url: try container.decode(URL.self, forKey: .url))
        case .videoAsset:
            self = .videoAsset(name: try container.decode(String.self, forKey: .name))
        case .videoBundle:
            self = .videoBundle(file: try container.decode(String.self, forKey: .file))
        case .videoRemote:
            self = .videoRemote(url: try container.decode(URL.self, forKey: .url))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .asset(let name):
            try container.encode(Kind.asset, forKey: .kind)
            try container.encode(name, forKey: .name)
        case .bundle(let file):
            try container.encode(Kind.bundle, forKey: .kind)
            try container.encode(file, forKey: .file)
        case .remote(let url):
            try container.encode(Kind.remote, forKey: .kind)
            try container.encode(url, forKey: .url)
        case .videoAsset(let name):
            try container.encode(Kind.videoAsset, forKey: .kind)
            try container.encode(name, forKey: .name)
        case .videoBundle(let file):
            try container.encode(Kind.videoBundle, forKey: .kind)
            try container.encode(file, forKey: .file)
        case .videoRemote(let url):
            try container.encode(Kind.videoRemote, forKey: .kind)
            try container.encode(url, forKey: .url)
        }
    }
}
