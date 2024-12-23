import LanguageServerProtocol
import Foundation


public struct TextDocument {}

public extension TextDocument {
    struct RegisterForChanges {
        public enum Action: String, Codable, Hashable, Sendable {
            case register
            case unregister
        }
        public struct Params: Codable, Hashable, Sendable {
            public let uri: URL
            public let action: Action
        }
    }
}

