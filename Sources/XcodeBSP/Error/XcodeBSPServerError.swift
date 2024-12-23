

enum XcodeBSPServerError: Error {
    case serverNotInitialized


    var localizedDescription: String {
        switch self {
            case .serverNotInitialized:
                return "Server not initialized"
        }
    }
}
