import LanguageServerProtocol
import JSONRPC
import Foundation


public extension Build.Target {
    public struct Resources {
        public struct Item: Codable, Hashable, Sendable {
            public let target: Build.Target.Identifier
            public let resources: [URL]
        }

        public struct Result: Codable, Sendable {
            public let items: [Item]
        }

        public struct Params: Codable, Hashable, Sendable {
            public let targets: [Build.Target.Identifier]
        }
    }
}
