import Cocoa

class MenuBarIcon {
    private var statusItem: NSStatusItem!

    init() {
        setupMenuBarIcon()
    }

    private func setupMenuBarIcon() {
        // Create the menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        // Set the custom image
        if let button = statusItem.button {
            let imagePath = Bundle.main.resourcePath! + "/Assets/menuBarIcon.png"
            if let image = NSImage(contentsOfFile: imagePath) {
                image.isTemplate = true  // Adapts to light/dark mode
                button.image = image
            } else {
                Logger.error("Failed to load menu bar icon from path: \(imagePath)")
            }
        }

        // Create the menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit Reticle", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem.menu = menu
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}

