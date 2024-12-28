import Foundation

class FileWatcher {
    private var fileWatcher: DispatchSourceFileSystemObject?

    func watchConfigDirectory(containing path: String, onChange: @escaping () -> Void) {
        let directoryURL = URL(fileURLWithPath: path).deletingLastPathComponent()
        guard FileManager.default.fileExists(atPath: directoryURL.path) else {
            Logger.error("Directory does not exist at \(directoryURL.path).")
            return
        }

        let directoryDescriptor = open(directoryURL.path, O_EVTONLY)
        guard directoryDescriptor >= 0 else {
            Logger.error("Failed to open directory at path: \(directoryURL.path).")
            return
        }

        fileWatcher = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: directoryDescriptor,
            eventMask: .write,
            queue: DispatchQueue.global(qos: .background)
        )

        fileWatcher?.setEventHandler {
            Logger.info("Directory contents changed.")
            onChange()
        }

        fileWatcher?.setCancelHandler {
            close(directoryDescriptor)
        }

        fileWatcher?.resume()
    }
}

