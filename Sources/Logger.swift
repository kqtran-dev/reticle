import Foundation

class Logger {
    private static let logFilePath: URL = {
        let fileManager = FileManager.default
        let logsDirectory = fileManager.homeDirectoryForCurrentUser.appendingPathComponent("reticle_logs")
        try? fileManager.createDirectory(at: logsDirectory, withIntermediateDirectories: true)
        return logsDirectory.appendingPathComponent("app.log")
    }()

    static func log(_ message: String, level: String = "INFO", file: String = #file, function: String = #function) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let timestamp = formatter.string(from: Date())
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(timestamp)] [\(level)] [\(fileName):\(function)] \(message)"
        
        // Print to console
        print(logMessage)

        // Append to log file
        appendToFile(logMessage)
    }

    static func info(_ message: String, file: String = #file, function: String = #function) {
        log(message, level: "INFO", file: file, function: function)
    }

    static func error(_ message: String, file: String = #file, function: String = #function) {
        log(message, level: "ERROR", file: file, function: function)
    }

    private static func appendToFile(_ message: String) {
        guard let data = (message + "\n").data(using: .utf8) else { return }
        if FileManager.default.fileExists(atPath: logFilePath.path) {
            try? data.append(to: logFilePath)
        } else {
            try? data.write(to: logFilePath)
        }
    }
}

// Extension to handle appending to existing files
private extension Data {
    func append(to url: URL) throws {
        if let fileHandle = try? FileHandle(forWritingTo: url) {
            defer { fileHandle.closeFile() }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        } else {
            try write(to: url)
        }
    }
}

