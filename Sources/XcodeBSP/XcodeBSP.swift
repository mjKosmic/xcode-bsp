import System
import ArgumentParser
import OSLog
import Foundation
import JSONRPC
import LanguageServerProtocol

struct LaunchOptions {
    enum ProjectType {
        case project(scheme: String)
        case workspace(scheme: String)
    }

    let projectType: ProjectType
    var derivedData: URL = FileManager.default.homeDirectoryForCurrentUser.appending(component: "/Library/Developer/Xcode/DerivedData/")
}
@main
struct XcodeBSP: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "xcode-bsp",
        abstract: "Language Server Protocol implementation for Swift and C-based languages",
        subcommands: [
          // DiagnoseCommand.self,
          // DebugCommand.self,
        ]
    )


    static let name = "XcodeBSPSever"
    static let version = "1.0.0"
    static let bspVersion = "2.2.0"

    @Flag
    var project = false

    @Flag
    var workspace = false

    @Option
    var scheme: String

    mutating func run() async throws {
        let launchOptions: LaunchOptions 
        if project {
            launchOptions = .init(projectType: .project(scheme: scheme))
        } else if workspace {
            launchOptions = .init(projectType: .project(scheme: scheme))
        } else {
            //default to regular project
            launchOptions = .init(projectType: .project(scheme: scheme))
        }

        let bspServer: XcodeBSPServer = .init(launchOptions) 
        XcodeBSPServer.shared = bspServer

        let connection: JSONRPCClientConnection = .init(.stdioPipe())
        let requestHandler: BSPRequestHandler = .init()
        let notificationHandler: BSPNotificationHandler = .init()
        let errorHandler: BSPErrorHandler = .init(connection: connection)
        let eventDispatcher: EventDispatcher = .init(connection: connection, requestHandler: requestHandler, notificationHandler: notificationHandler, errorHandler: errorHandler)
        await eventDispatcher.run()

        // Park the main function by sleeping for 10 years.
        // All request handling is done on other threads and sourcekit-lsp exits by calling `_Exit` when it receives a
        // shutdown notification.
        while true {
            try? await Task.sleep(for: .seconds(60 * 60 * 24 * 365 * 10))
            Logger.bsp.fault("10 year wait that's parking the main thread expired. Waiting again.")
        }
    }
}
