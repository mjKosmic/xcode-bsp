public enum ClientNotification: Sendable {
    public enum Method: String, Hashable, Sendable {
        case initialized = "build/initialized"
        case exit = "build/exit"
        // case runReadStdin = "run/readStdin"
    }

    case initialized
    case exit
    // case runReadStdin

    public var method: Method {
        switch self { 
            case .initialized:
                return .initialized
            case .exit:
                return .exit
            // case .runReadStdin:
            //     return .runReadStdin
        }
    }
}
