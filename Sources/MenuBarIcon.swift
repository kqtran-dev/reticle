import Cocoa

class MenuBarIcon {
    private var statusItem: NSStatusItem!

    init() {
        setupMenuBarIcon()
    }

private func setupMenuBarIcon() {
    // Create the menu bar item
    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    // Set an icon (use a system image or custom image)
    if let button = statusItem.button {
        button.image = NSImage(named: "NSApplicationIcon")  // Replace with your custom image if available
        button.image?.isTemplate = true  // Adapts to light/dark mode
    }

    // Create the menu
    let menu = NSMenu()
    let quitMenuItem = NSMenuItem(title: "Quit Reticle", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
    quitMenuItem.target = NSApp  // Ensure the target is the application
    menu.addItem(quitMenuItem)

    statusItem.menu = menu
}

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}

