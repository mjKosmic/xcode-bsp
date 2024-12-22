import JSONRPC
import OSLog
import RegexBuilder
import LanguageServerProtocol


actor XcodeBSPServer {

    var logger: Logger = Logger.bsp
    var eventDispatcher: EventDispatcher

    init() {
        let connection: JSONRPCClientConnection = .init(.stdioPipe())
        let requestHandler: BSPRequestHandler = .init()
        let notificationHandler: BSPNotificationHandler = .init()
        let errorHandler: BSPErrorHandler = .init()
        self.eventDispatcher = .init(connection: connection, requestHandler: requestHandler, notificationHandler: notificationHandler, errorHandler: errorHandler)
    }

    public func run() async {
        await eventDispatcher.run()
    }
}
