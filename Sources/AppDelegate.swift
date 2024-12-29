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
    var menuBarIcon: MenuBarIcon?

    func applicationDidFinishLaunching(_ notification: Notification) {
        menuBarIcon = MenuBarIcon()
        let configPath = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Application Support/reticle/config.json")
        .path
        loadConfiguration(from: configPath)

        let screenFrame = NSScreen.main!.frame

        // Create transparent overlay window
        window = WindowFactory.createTransparentWindow(frame: screenFrame)

        // Add crosshair view
        crosshairView = CrosshairView(
            frame: screenFrame,
            configuration: configuration?.crosshair,
            onclickConfig: configuration?.onclick
        )

        // // Force an initial draw to ensure the crosshair appears immediately
        // crosshairView.setNeedsDisplay(crosshairView.bounds)

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
            crosshairView?.updateConfiguration(
                crosshair: newConfig.crosshair,
                onclick: newConfig.onclick
            )
            Logger.info("Configuration updated.")
        } else {
            configuration = Configuration.defaultConfiguration()
            crosshairView?.updateConfiguration(
                crosshair: Configuration.defaultConfiguration().crosshair,
                onclick: Configuration.defaultConfiguration().onclick
            )
            Logger.error("Invalid or missing configuration. Reverting to default configuration.")
        }}
}

