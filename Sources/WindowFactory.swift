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
        window.level = .screenSaver  // Ensure it stays above all UI elements
        window.ignoresMouseEvents = true
        window.collectionBehavior = [
            .canJoinAllSpaces,
            .fullScreenAuxiliary,
            .ignoresCycle
        ]
        window.makeKeyAndOrderFront(nil)
        return window
    }
}

