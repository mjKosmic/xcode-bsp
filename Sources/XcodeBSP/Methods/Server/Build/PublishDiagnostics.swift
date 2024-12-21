import JSONRPC
import LanguageServerProtocol

public extension Build.Diagnostics {
    struct Publish {
        public struct Params: Codable, Hashable, Sendable {
            public let textDocument: TextDocumentIdentifier
            public let buildTarget: Build.Target.Identifier
            public let originId: JSONId?
            public let diagnostics: [Diagnostic]
            public let reset: Bool
        }
    }
}
