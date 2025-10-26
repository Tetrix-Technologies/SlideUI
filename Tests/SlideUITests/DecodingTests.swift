import XCTest
@testable import SlideUI

final class DecodingTests: XCTestCase {
    
    func testBasicDeckDecoding() throws {
        let json = """
        {
            "title": "Test Deck",
            "slides": [
                {
                    "blocks": [
                        { "type": "title", "text": "Hello", "subtitle": "World" }
                    ]
                }
            ]
        }
        """
        
        let data = Data(json.utf8)
        let deck = try JSONDecoder().decode(DeckSpec.self, from: data)
        
        XCTAssertEqual(deck.title, "Test Deck")
        XCTAssertEqual(deck.slides.count, 1)
        XCTAssertEqual(deck.slides[0].blocks.count, 1)
    }
    
    func testThemeDecoding() throws {
        let json = """
        {
            "title": "Themed Deck",
            "theme": {
                "backgroundHex": "#1a1a1a",
                "titleColorHex": "#ffffff"
            },
            "slides": []
        }
        """
        
        let data = Data(json.utf8)
        let deck = try JSONDecoder().decode(DeckSpec.self, from: data)
        
        XCTAssertNotNil(deck.theme)
        XCTAssertEqual(deck.theme?.backgroundHex, "#1a1a1a")
        XCTAssertEqual(deck.theme?.titleColorHex, "#ffffff")
    }
    
    func testVideoBlockDecoding() throws {
        let json = """
        {
            "type": "video",
            "source": { "kind": "videoRemote", "url": "https://example.com/video.mp4" },
            "autoplay": true,
            "loop": false
        }
        """
        
        let data = Data(json.utf8)
        let block = try JSONDecoder().decode(BlockSpec.self, from: data)
        
        if case .video(let source, let autoplay, let loop) = block {
            if case .videoRemote(let url) = source {
                XCTAssertEqual(url.absoluteString, "https://example.com/video.mp4")
            } else {
                XCTFail("Expected videoRemote source")
            }
            XCTAssertTrue(autoplay)
            XCTAssertFalse(loop)
        } else {
            XCTFail("Expected video block")
        }
    }
    
    func testLinkBlockDecoding() throws {
        let json = """
        {
            "type": "link",
            "text": "Visit Site",
            "url": "https://example.com"
        }
        """
        
        let data = Data(json.utf8)
        let block = try JSONDecoder().decode(BlockSpec.self, from: data)
        
        if case .link(let text, let url) = block {
            XCTAssertEqual(text, "Visit Site")
            XCTAssertEqual(url.absoluteString, "https://example.com")
        } else {
            XCTFail("Expected link block")
        }
    }
}
