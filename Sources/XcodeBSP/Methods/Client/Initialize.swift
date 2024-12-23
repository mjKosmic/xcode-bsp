import Foundation
import LanguageServerProtocol
import JSONRPC

public struct Initialize {
    public typealias DataKind = String
    public struct Params: Codable, Hashable, Sendable {
        public struct Data: Codable, Hashable, Sendable {}

        public let displayName: String
        public let version: String
        public let bspVersion: String
        public let rootUri: URL
        public let capabilities: ClientCapabilities
        public let dataKind: DataKind?
        public let data: Data?
    }

    public struct Result: Codable, Sendable {
        public struct Data: Codable, Sendable {
            let indexStorePath: String?
            let indexDatabasePath: String?
            let prepareProvider: Bool?
            let sourceKitOptionsProvider: Bool?
            let watchers: [FileSystemWatcher]?
        }

        public let displayName: String
        public let version: String
        public let bspVersion: String
        public let capabilities: BuildServerCapabilities
        public let dataKind: DataKind?
        public let data: Data?
    }
}

