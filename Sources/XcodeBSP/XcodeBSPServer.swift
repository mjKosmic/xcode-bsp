import JSONRPC
import OSLog
import RegexBuilder
import LanguageServerProtocol


actor XcodeBSPServer {

    var logger: Logger = Logger.bsp

    var channel: DataChannel
    var session: JSONRPCSession

    var serverTask: Task<Void, Never>? 

    init() {
        self.channel = .stdioPipe().withMessageFraming()
        self.session = .init(channel: channel)
    }

    func handleRequest(_ request: ClientRequest, _ handler: JSONRPCEvent.RequestHandler, _ data: Data) {
        logger.info("handling request")
        switch request.method {
            case .initialize: 
                do {
                logger.info("initializing...")
                // try self.sendMessage(message)
                } catch {
                    logger.info("Error decoding initialize method: \(error.localizedDescription, privacy: .public)")
                }
            default:
                break
        }
    }

    func initialize(withParams: JSONValue) {
    }

    func startServer() {
        self.serverTask = Task {
            for await event in await session.eventSequence {
                switch event {
                    case .notification(let notification, let data):
                        logger.info("notification: \(notification.method, privacy: .public)")
                    case .request(let request, let handler, let data): 
                        self.handleRequest(request, handler, data)
                    case .error(let error): 
                        logger.error("error: \(error.localizedDescription, privacy: .public)")
                }
            }
        }
    }

    func stopServer() {
        serverTask?.cancel()
    }

    // func sendMessage(_ message: any BSPRequest) throws {
    //     let data = try JSONEncoder().encode(message)
    //     if let string = String(data: data, encoding: .utf8) {
    //         logger.debug("Outgoing: \(string, privacy: .public)") 
    //     }
    //
    //     session.sendRequest(, method: )
    // }
}
