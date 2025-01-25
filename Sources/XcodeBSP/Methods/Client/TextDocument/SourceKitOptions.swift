import Foundation
import LanguageServerProtocol

public extension TextDocument {
    struct SourceKitOptions {
        public struct Params: Codable, Hashable, Sendable {
            public let textDocument: TextDocumentIdentifier
            public let target: Build.Target.Identifier
            public let language: LanguageIdentifier
        }

        public struct Result: Codable, Sendable {
              /** The compiler options required for the requested file. */
            public let compilerArguments: [String]

              /** The working directory for the compile command. */
            public let workingDirectory: URL?
        }
    }
}
