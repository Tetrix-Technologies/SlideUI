import Foundation

/// Represents a content block within a slide
public enum BlockSpec: Codable {
    case title(text: String, subtitle: String?)
    case words(text: String)
    case bullets(style: BulletStyleSpec?, items: [String])
    case media(source: MediaSourceSpec)
    case video(source: MediaSourceSpec, autoplay: Bool, loop: Bool)
    case link(text: String, url: URL)
    case columns(columns: [[BlockSpec]])
    case code(code: String, enableHighlight: Bool?)
    
    enum Kind: String, Codable { 
        case title, words, bullets, media, video, link, columns, code 
    }
    
    public init(from decoder: Decoder) throws {
        let kind = try decoder.container(keyedBy: CodingKeys.self).decode(Kind.self, forKey: .type)
        switch kind {
        case .title:
            struct T: Codable { let type: Kind; let text: String; let subtitle: String? }
            let v = try T(from: decoder)
            self = .title(text: v.text, subtitle: v.subtitle)
        case .words:
            struct T: Codable { let type: Kind; let text: String }
            let v = try T(from: decoder)
            self = .words(text: v.text)
        case .bullets:
            struct T: Codable { let type: Kind; let style: BulletStyleSpec?; let items: [String] }
            let v = try T(from: decoder)
            self = .bullets(style: v.style, items: v.items)
        case .media:
            struct T: Codable { let type: Kind; let source: MediaSourceSpec }
            let v = try T(from: decoder)
            self = .media(source: v.source)
        case .video:
            struct T: Codable { let type: Kind; let source: MediaSourceSpec; let autoplay: Bool; let loop: Bool }
            let v = try T(from: decoder)
            self = .video(source: v.source, autoplay: v.autoplay, loop: v.loop)
        case .link:
            struct T: Codable { let type: Kind; let text: String; let url: URL }
            let v = try T(from: decoder)
            self = .link(text: v.text, url: v.url)
        case .columns:
            struct T: Codable { let type: Kind; let columns: [[BlockSpec]] }
            let v = try T(from: decoder)
            self = .columns(columns: v.columns)
        case .code:
            struct T: Codable { let type: Kind; let code: String; let enableHighlight: Bool? }
            let v = try T(from: decoder)
            self = .code(code: v.code, enableHighlight: v.enableHighlight)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        
        switch self {
        case .title(let text, let subtitle):
            try container.encode(text, forKey: .text)
            try container.encodeIfPresent(subtitle, forKey: .subtitle)
        case .words(let text):
            try container.encode(text, forKey: .text)
        case .bullets(let style, let items):
            try container.encodeIfPresent(style, forKey: .style)
            try container.encode(items, forKey: .items)
        case .media(let source):
            try container.encode(source, forKey: .source)
        case .video(let source, let autoplay, let loop):
            try container.encode(source, forKey: .source)
            try container.encode(autoplay, forKey: .autoplay)
            try container.encode(loop, forKey: .loop)
        case .link(let text, let url):
            try container.encode(text, forKey: .text)
            try container.encode(url, forKey: .url)
        case .columns(let columns):
            try container.encode(columns, forKey: .columns)
        case .code(let code, let enableHighlight):
            try container.encode(code, forKey: .code)
            try container.encodeIfPresent(enableHighlight, forKey: .enableHighlight)
        }
    }
    
    private var type: Kind {
        switch self {
        case .title: return .title
        case .words: return .words
        case .bullets: return .bullets
        case .media: return .media
        case .video: return .video
        case .link: return .link
        case .columns: return .columns
        case .code: return .code
        }
    }
    
    enum CodingKeys: String, CodingKey { 
        case type, text, subtitle, style, items, source, autoplay, loop, url, columns, code, enableHighlight 
    }
}

/// Bullet style options
public enum BulletStyleSpec: String, Codable { 
    case bullets, dash 
}
