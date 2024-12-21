import Foundation
import LanguageServerProtocol
import JSONRPC

public extension BuildTarget {
    struct CleanCache {
        public struct Params: Codable, Hashable, Sendable {
            public let targets: [BuildTarget.Identifier]
        }

        public struct Result: Codable, Hashable, Sendable {
            public let cleaned: Bool
            public let message: String?
        }
    }
}
