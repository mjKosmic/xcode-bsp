// The Swift Programming Language
// https://docs.swift.org/swift-book
import System
import ArgumentParser
import OSLog
import Foundation
import JSONRPC

@main
struct XcodeBSP: AsyncParsableCommand {

    @Option
    var project: String?

    @Option
    var workspace: String?

    @Option
    var package: String?

    mutating func run() async throws {
        Logger.bsp.info("Starting up XcodeBSP...")
        if let project {
            Logger.bsp.info("Launched with project path: \(project, privacy: .public)")
        }
        if let workspace {
            Logger.bsp.info("Launched with workspace path: \(workspace, privacy: .public)")
        }
        if let package {
            Logger.bsp.info("Launched with package path: \(package, privacy: .public)")
        }

            
        let server: XcodeBSPServer = .init()
        await server.run()

        // Park the main function by sleeping for 10 years.
        // All request handling is done on other threads and sourcekit-lsp exits by calling `_Exit` when it receives a
        // shutdown notification.
        while true {
            try? await Task.sleep(for: .seconds(60 * 60 * 24 * 365 * 10))
            Logger.bsp.fault("10 year wait that's parking the main thread expired. Waiting again.")
        }
    }
}
