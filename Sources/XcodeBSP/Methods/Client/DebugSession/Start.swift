import Foundation
import LanguageServerProtocol
import JSONRPC

public extension DebugSession {
    struct Start {
        public struct Params: Codable, Hashable, Sendable {
            public let targets: [Build.Target.Identifier]
            //data
            //datakind
        }
    }
}   
