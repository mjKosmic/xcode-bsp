import Foundation

struct CompileCommand: Codable {
    let directory: URL
    let command: String
    let file: String
}
