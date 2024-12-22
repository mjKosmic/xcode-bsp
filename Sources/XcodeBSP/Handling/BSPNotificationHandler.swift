import LanguageServerProtocol
import OSLog

public actor BSPNotificationHandler: NotificationHandler {

    public func internalError(_ error: Error) async {
		Logger.bsp.error("Internal Error: \(error.localizedDescription, privacy: .public)")
	}

    public func handleNotification(_ notification: ClientNotification) async {
		switch notification {
            case .initialized:
                Logger.bsp.info("Recieved [initialized] notification")
                break
            case .exit:
                break
        }
    }
}
