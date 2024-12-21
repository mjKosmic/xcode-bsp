import Foundation
import LanguageServerProtocol
import JSONRPC

public extension Build.Target {
    struct CleanCache {
        public struct Params: Codable, Hashable, Sendable {
            public let targets: [Build.Target.Identifier]
        }

        public struct Result: Codable, Hashable, Sendable {
            public let cleaned: Bool
            public let message: String?
        }
    }
}
