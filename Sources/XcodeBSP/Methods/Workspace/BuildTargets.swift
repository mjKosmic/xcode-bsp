import Foundation
import LanguageServerProtocol
import JSONRPC

public extension Workspace {
    struct BuildTargets {
        public struct Result: Codable, Sendable {
            public let targets: [BuildTarget]
        }
    }
}
