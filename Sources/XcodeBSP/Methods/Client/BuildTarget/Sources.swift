import Foundation
import LanguageServerProtocol
import JSONRPC

public extension Build.Target {
    struct Source {
        public struct Item: Codable, Sendable {
            public enum Kind: Int, Codable, Sendable {
                case file = 1
                    case directory
            }
            /** Either a text document or a directory. A directory entry must end with a forward
             * slash "/" and a directory entry implies that every nested text document within the
             * directory belongs to this source item. */
            public let uri: String
            public let kind: Kind
            public let generated: Bool

            // /** Kind of data to expect in the `data` field. If this field is not set, the kind of data is not specified. */
            // dataKind?: SourceItemDataKind;
            //
            // /** Language-specific metadata about this source item. */
            // data?: SourceItemData;
        }
    }

    struct Sources {
        public struct Item: Codable, Sendable {
            public let target: Build.Target.Identifier
            public let sources: [Source.Item]
            public let roots: URL?
        }
        public struct Params: Codable, Hashable, Sendable {
            public let targets: [Build.Target.Identifier]
        }
        public struct Result: Codable, Sendable {
            public let  items: [Sources.Item]
        }
    }
}
