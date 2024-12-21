import Foundation
import LanguageServerProtocol
import JSONRPC



public struct WorkspaceBuildTargetsResult: Codable, Sendable {
    public let targets: [BuildTarget]
}


