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
        await server.startServer()


        // Park the main function by sleeping for 10 years.
        // All request handling is done on other threads and sourcekit-lsp exits by calling `_Exit` when it receives a
        // shutdown notification.
        while true {
            try? await Task.sleep(for: .seconds(60 * 60 * 24 * 365 * 10))
            Logger.bsp.fault("10 year wait that's parking the main thread expired. Waiting again.")
        }

        // logger.info("Reading from stdin...")
        // let stdin: FileDescriptor = .standardInput
        // while true {
        //     if let line = readLine() {
        //         logger.info("read line: \(line, privacy: .public)")
        //         if line.contains("Content-Length") {
        //             if let match = line.firstMatch(of: /\d+/), let contentLength: Int = Int(match.output) {
        //                 do {
        //                     var buffer = [Int8](repeating: 0, count: contentLength)
        //                     let bytesRead = try buffer.withUnsafeMutableBytes { buf in
        //                         logger.info("Reading into buffer...")
        //                         return try stdin.read(into: buf)    
        //                     }
        //                     logger.debug("Read \(bytesRead)")
        //                     let json = String(utf8String: buffer)
        //                     if let data = json?.data(using: .utf8) {
        //                         let message = try JSONDecoder().decode(BSPInitializeMessage.self, from: data)
        //                             logger.info("Message Received")
        //                     }
        //                 } catch {
        //                     logger.error("Failed to parse initialize message: \(error.localizedDescription)")
        //                 }
        //             }
        //         }
        //     }

            // let stdin = dup(STDIN_FILENO)
            // if stdin == -1 {
            //     logger.error("Failed to dup stdin")
            // }

        // }
    }
}
