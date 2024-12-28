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
    var fileWatcher = FileWatcher()

    func applicationDidFinishLaunching(_ notification: Notification) {
        let configPath = "config.json"
        loadConfiguration(from: configPath)

        let screenFrame = NSScreen.main!.frame

        // Create transparent overlay window
        window = WindowFactory.createTransparentWindow(frame: screenFrame)

        // Add crosshair view
        crosshairView = CrosshairView(frame: screenFrame, configuration: configuration?.crosshair)
        window.contentView?.addSubview(crosshairView)

        // Setup input handling
        InputHandler.trackMouse(for: crosshairView)

        // Setup file watcher
        fileWatcher.watchConfigDirectory(containing: configPath) { [weak self] in
            DispatchQueue.main.async {
                Logger.info("Reloading configuration...")
                self?.loadConfiguration(from: configPath)
            }
        }
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
}

