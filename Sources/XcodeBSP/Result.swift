import Foundation
import LanguageServerProtocol
import JSONRPC

public struct InitializeBuildResult: Codable, Sendable {
    public let displayName: String
    public let version: String
    public let bspVersion: String
    public let capabilities: BuildServerCapabilities
}

public struct WorkspaceBuildTargetsResult: Codable, Sendable {
    public let targets: [BuildTarget]
}
