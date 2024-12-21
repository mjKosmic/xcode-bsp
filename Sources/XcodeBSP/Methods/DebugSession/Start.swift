import Foundation
import LanguageServerProtocol
import JSONRPC

public extension DebugSesson {
    struct Start {
        public struct Params: Codable, Hashable, Sendable {
            public let targets: [BuildTarget.Identifier]
            //data
            //datakind
        }
    }
}   
