

public enum ServerNotifciation: Sendable {
	public enum Method: String, Hashable, Sendable {
		case showMessage = "build/showMessage"
		case logMessage =  "build/logMessage"
		case publishDiagnostics = "build/publishDiagnostics"
		case targetDidChange = "build/targetDidChange" 
		case taskStart = "build/taskStart" 
		case taskProgress = "build/taskProgress" 
		case taskFinish = "build/taskFinish" 
		case printStdout = "run/printStdout"
		case printStderr = "run/printStderr" 
	}


	case showMessage(Build.ShowMessage.Params)
	case logMessage(Build.LogMessage.Params)
	case publishDiagnostics(Build.Diagnostics.Publish.Params)
	case targetDidChange
	case taskStart(Build.Task.Start.Params)
	case taskProgress(Build.Task.Progress.Params)
	case taskFinish(Build.Task.Finish.Params)
	case printStdout
	case printStderr

	public var method: Method {
		switch self {
			case .showMessage:
				return .showMessage
			case .logMessage:
				return .logMessage
			case .publishDiagnostics:
				return .publishDiagnostics
			case .targetDidChange:
				return .targetDidChange
			case .taskStart:
				return .taskStart
			case .taskProgress:
				return .taskProgress
			case .taskFinish:
				return .taskFinish
			case .printStdout:
				return .printStdout
			case .printStderr:
				return .printStderr
		}
	}
}
