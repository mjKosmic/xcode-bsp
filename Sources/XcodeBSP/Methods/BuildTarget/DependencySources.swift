import Foundation
import LanguageServerProtocol
import JSONRPC

public extension BuildTarget {
    struct DependencySources {
        public struct Item: Codable, Sendable {
            public let target: BuildTarget.Identifier
            public let sources: [URL]
        }

        public struct Params: Codable, Hashable, Sendable {
            public let targets: [BuildTarget.Identifier]
        }

        public struct Result: Codable, Sendable {
            public let items: [Item]
        }
    }
}
