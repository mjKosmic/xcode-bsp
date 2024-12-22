import OSLog
import Foundation

public actor BSPErrorHandler: ErrorHandler {
    public func internalError(_ error: Error) async {
        Logger.bsp.error("Error: \(error.localizedDescription, privacy: .public)")
    }   
}
