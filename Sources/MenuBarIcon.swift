import Cocoa

class MenuBarIcon {
    private var statusItem: NSStatusItem!

init() {
        // setupMenuBarIcon()
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
            button.image = NSImage(named: "NSApplicationIcon")  // Use default icon
        }
    }

    // Create the menu
    let menu = NSMenu()

    let quitItem = NSMenuItem(title: "Quit Reticle", action: #selector(quitApp), keyEquivalent: "q")
    quitItem.target = self  // Set target to the current instance
    menu.addItem(quitItem)

    statusItem.menu = menu
}

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}

