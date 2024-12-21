import JSONRPC
import LanguageServerProtocol


public extension Build.Target {
    struct Event {
        public enum Kind: Int, Codable, Hashable, Sendable {
            case created = 1
            case changed
            case deleted
        }

        public let target: Build.Target.Identifier
        public let kind: Event.Kind?
        //data
        //data kind
    }
}
