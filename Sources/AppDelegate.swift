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
        Logger.clearLogFile()
        Logger.configureLogging(from: "path/to/logging_config.json")
        menuBarIcon = MenuBarIcon()

        let configPath = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Application Support/reticle/config.json")
        .path
        loadConfiguration(from: configPath)
        Logger.info("Loaded config from: \(configPath)")
        Logger.info("Loaded border? \(String(describing: configuration?.crosshair.border))")

        // let screenFrame = NSScreen.main!.frame

        // Create transparent overlay window
        window = WindowFactory.createTransparentWindow()

        for (index, screen) in NSScreen.screens.enumerated() {
            Logger.info("Screen \(index): \(screen.frame)")
        }
        Logger.info("Final window frame: \(window.frame)")

        let contentRect = window.contentView?.bounds ?? .zero

        // Add crosshair view
        // crosshairView = CrosshairView(
        //     frame: screenFrame,
        //     configuration: configuration?.crosshair,
        //     onclickConfig: configuration?.onclick
        // )
        crosshairView = CrosshairView(
            frame: contentRect,
                configuration:configuration?.crosshair,
                onclickConfig: configuration?.onclick
        )

        window.contentView?.addSubview(crosshairView)

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
            StartupManager.configureStartup(enabled: newConfig.runOnStartup)
            crosshairView?.updateConfiguration(
                crosshair: newConfig.crosshair,
                onclick: newConfig.onclick
            )
            Logger.info("Configuration updated.")
        } else {
            configuration = Configuration.defaultConfiguration()
            StartupManager.configureStartup(enabled: Configuration.defaultConfiguration().runOnStartup)
            crosshairView?.updateConfiguration(
                crosshair: Configuration.defaultConfiguration().crosshair,
                onclick: Configuration.defaultConfiguration().onclick
            )
            Logger.error("Invalid or missing configuration. Reverting to default configuration.")
        }}
}

