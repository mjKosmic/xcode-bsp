import Foundation
import LanguageServerProtocol
import JSONRPC

public extension Build.Target {
    struct InverseSources { 
        public struct Params: Codable, Hashable, Sendable {
            public let textDocument: TextDocumentIdentifier
        }

        public struct Result: Codable, Sendable {
            public let targets: [Build.Target.Identifier]
        }
    }
}
