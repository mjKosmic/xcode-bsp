import JSONRPC
import LanguageServerProtocol


public protocol NotificationHandler : ErrorHandler {
	func handleNotification(_ notification: ClientNotification) async

    func initialized() async
    func exit() async   
}

public extension NotificationHandler {
	func handleNotification(_ notification: ClientNotification) async {
		await defaultNotificationDispatch(notification)
	}

	func defaultNotificationDispatch(_ notification: ClientNotification) async {
		switch notification {
            case .initialized:
                await initialized()
            case .exit:
                await exit()
		}
	}
}

//Default implementation of "Not Implemented" that we can override when we implement them
public extension NotificationHandler {

    func initialized() async { await internalError(NotImplementedError) }
    func exit() async { await internalError(NotImplementedError) }
}
