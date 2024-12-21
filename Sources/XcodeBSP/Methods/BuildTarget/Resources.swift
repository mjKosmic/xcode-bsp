import LanguageServerProtocol
import JSONRPC
import Foundation


public extension BuildTarget {
    public struct Resources {
        public struct Item: Codable, Hashable, Sendable {
            public let target: BuildTarget.Identifier
            public let resources: [URL]
        }

        public struct Result: Codable, Sendable {
            public let items: [Item]
        }

        public struct Params: Codable, Hashable, Sendable {
            public let targets: [BuildTarget.Identifier]
        }
    }
}
