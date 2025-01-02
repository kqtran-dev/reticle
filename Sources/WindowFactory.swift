import Cocoa

class WindowFactory {
    static func createTransparentWindow() -> NSWindow {
        // Calculate the combined frame of all screens
        let combinedFrame = NSScreen.screens.reduce(CGRect.zero) { $0.union($1.frame) }

        let window = NSWindow(
            contentRect: combinedFrame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        // window.backgroundColor = NSColor.red
        // window.alphaValue = 0.5
        window.level = .screenSaver  // Ensure it stays above all UI elements
        window.ignoresMouseEvents = true
        window.collectionBehavior = [
            .canJoinAllSpaces, // ensures available on all desktops
            .fullScreenAuxiliary, // keeps window visible in full-screen apps
            .stationary, // prevents from interacting with Mission Control
            .ignoresCycle // excludes window from normal app window cycles
        ]
        window.makeKeyAndOrderFront(nil)
        return window
    }
}

