import Foundation

class Logger {
    enum LogLevel: String {
        case info = "INFO"
        case error = "ERROR"
    }

    static func log(_ message: String, level: LogLevel = .info) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let timestamp = formatter.string(from: Date())
        print("[\(timestamp)] [\(level.rawValue)] \(message)")
    }

    static func info(_ message: String) {
        log(message, level: .info)
    }

    static func error(_ message: String) {
        log(message, level: .error)
    }
}
