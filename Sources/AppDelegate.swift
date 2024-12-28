import Cocoa
import Foundation

@main
struct ReticleApp {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var crosshairView: CrosshairView!
    var configuration: Configuration?
    var fileWatcher: DispatchSourceFileSystemObject?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let configPath = "config.json"
        loadConfiguration(from: configPath)

        let screenFrame = NSScreen.main!.frame

        // Transparent overlay window
        window = NSWindow(
            contentRect: screenFrame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.level = .screenSaver
        window.ignoresMouseEvents = true
        window.collectionBehavior = .canJoinAllSpaces
        window.makeKeyAndOrderFront(nil)

        crosshairView = CrosshairView(frame: screenFrame, configuration: configuration?.crosshair)
        window.contentView?.addSubview(crosshairView)


        // Mouse movement tracking
        NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { event in
            self.crosshairView.updatePosition(to: event.locationInWindow)
        }

        // Mouse drag tracking
        NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged) { event in
            self.crosshairView.updatePosition(to: event.locationInWindow)
        }

        // Set up file watcher
        watchConfigDirectory(containing: configPath)
    }

    private func loadConfiguration(from path: String) {
        if let newConfig = Configuration.load(from: path) {
            configuration = newConfig
            crosshairView?.updateConfiguration(configuration: newConfig.crosshair)
            Logger.info("Configuration updated.")
        } else {
            configuration = Configuration.defaultConfiguration()
            crosshairView?.updateConfiguration(configuration: Configuration.defaultConfiguration().crosshair)
            Logger.error("Invalid or missing configuration. Reverting to default configuration.")
        }
    }

    private func watchConfigDirectory(containing path: String) {
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

        fileWatcher?.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                Logger.info("Directory contents changed. Reloading configuration...")
                self?.loadConfiguration(from: path)
            }
        }

        fileWatcher?.setCancelHandler {
            close(directoryDescriptor)
        }

        fileWatcher?.resume()
    }
}



