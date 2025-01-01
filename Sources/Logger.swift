import Foundation

class Logger {
    private static let logFilePath: URL = {
        let fileManager = FileManager.default
        let logsDirectory = fileManager.homeDirectoryForCurrentUser.appendingPathComponent("reticle_logs")
        try? fileManager.createDirectory(at: logsDirectory, withIntermediateDirectories: true)
        return logsDirectory.appendingPathComponent("app.log")
    }()


    private static var enableFileLogging: Bool = false  // Default: Logging to file is disabled

    static func configureLogging(from configPath: String = "app_config.json") {
        do {
            let configURL = URL(fileURLWithPath: configPath)
            let data = try Data(contentsOf: configURL)
            if let config = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let enableLogging = config["enableFileLogging"] as? Bool {
                enableFileLogging = enableLogging
            }
        } catch {
            print("Failed to load logging configuration. Defaulting to console logging only.")
        }

        if enableFileLogging {
            clearLogFile()
        }
    }

    static func log(_ message: String, level: String = "INFO", file: String = #file, function: String = #function) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let timestamp = formatter.string(from: Date())
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(timestamp)] [\(level)] [\(fileName):\(function)] \(message)"

        // Print to console
        print(logMessage)

        // Append to log file if enabled
        if enableFileLogging {
            appendToFile(logMessage)
        }
    }

    static func info(_ message: String, file: String = #file, function: String = #function) {
        log(message, level: "INFO", file: file, function: function)
    }

    static func error(_ message: String, file: String = #file, function: String = #function) {
        log(message, level: "ERROR", file: file, function: function)
    }

    static func clearLogFile() {
        do {
            let fileHandle = try FileHandle(forWritingTo: logFilePath)
            fileHandle.truncateFile(atOffset: 0)  // Truncate the file to clear it
            fileHandle.closeFile()
            Logger.info("Cleared log file on launch.")
        } catch {
            Logger.error("Failed to clear log file: \(error)")
        }
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

