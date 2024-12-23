import LanguageServerProtocol
import JSONRPC


extension Build.Target {
    public struct DependencyModule: Codable, Hashable, Sendable {
        public let name: String
        public let version: String
        //public let dataKind: String
        //public let data: Any
    }
    public struct DependencyModules {
        public struct Item: Codable, Hashable, Sendable {
            public let target: Build.Target.Identifier
            public let modules: [DependencyModule]
        }
        public struct Params: Codable, Hashable, Sendable {
            public let targets: [Build.Target.Identifier]
        }

        public struct Result: Codable, Sendable {
            public let items:  [Item]
        }
    }
}
