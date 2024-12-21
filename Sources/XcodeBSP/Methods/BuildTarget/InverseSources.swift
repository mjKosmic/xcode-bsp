import Foundation
import LanguageServerProtocol
import JSONRPC

public extension BuildTarget {
    struct InverseSources { 
        public struct Params: Codable, Hashable, Sendable {
            public let textDocument: TextDocumentIdentifier
        }

        public struct Result: Codable, Sendable {
            public let targets: [BuildTarget.Identifier]
        }
    }
}
