import Foundation
import LanguageServerProtocol
import JSONRPC

public struct InitializeBuildParams: Codable, Hashable, Sendable {
    public let displayName: String
    public let version: String
    public let bspVersion: String
    public let rootUri: URL
    public let capabilities: ClientCapabilities
}
