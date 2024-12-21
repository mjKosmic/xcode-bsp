import Foundation
import LanguageServerProtocol
import JSONRPC

public extension Build.Target {
    struct DependencySources {
        public struct Item: Codable, Sendable {
            public let target: Build.Target.Identifier
            public let sources: [URL]
        }

        public struct Params: Codable, Hashable, Sendable {
            public let targets: [Build.Target.Identifier]
        }

        public struct Result: Codable, Sendable {
            public let items: [Item]
        }
    }
}
