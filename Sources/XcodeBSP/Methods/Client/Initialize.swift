import Foundation
import LanguageServerProtocol
import JSONRPC

public struct Initialize {
    public struct Params: Codable, Hashable, Sendable {
        public let displayName: String
        public let version: String
        public let bspVersion: String
        public let rootUri: URL
        public let capabilities: ClientCapabilities
    }

    public struct Result: Codable, Sendable {
        public let displayName: String
        public let version: String
        public let bspVersion: String
        public let capabilities: BuildServerCapabilities
    }
}

