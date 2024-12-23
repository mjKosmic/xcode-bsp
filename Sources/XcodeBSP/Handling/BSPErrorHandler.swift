import OSLog
import Foundation

public actor BSPErrorHandler: ErrorHandler {

    let connection: JSONRPCClientConnection

    init(connection: JSONRPCClientConnection) {
        self.connection = connection
    }

    public func internalError(_ error: Error) async {
        Logger.bsp.error("Error: \(error.localizedDescription, privacy: .public)")
    }   
}
