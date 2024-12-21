import Foundation
import LanguageServerProtocol
import JSONRPC


public extension Build.Target {
    struct OutputPath {
        public struct Item: Codable, Hashable, Sendable {
            public enum Kind: Int, Codable, Hashable, Sendable {
                case file = 1
                case directory
            }

            public let uri: URL
            public let kind: Kind 
        }
    }
    struct OutputPaths {
        public struct Item: Codable, Hashable, Sendable {
            public let target: Build.Target.Identifier
            public let outputPaths: [OutputPath.Item]
        }
        public struct Params: Codable, Hashable, Sendable {
            public let targets: [Build.Target.Identifier]
        }

        public struct Result: Codable, Sendable {
            public let items: [Item]
        }
    }
}
