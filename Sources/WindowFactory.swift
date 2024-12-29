import Cocoa

class WindowFactory {
    static func createTransparentWindow(frame: CGRect) -> NSWindow {
        let window = NSWindow(
            contentRect: frame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        window.isOpaque = false
        window.backgroundColor = NSColor.clear
        window.level = .screenSaver  // Ensure it stays above other UI elements
        window.ignoresMouseEvents = true
        window.collectionBehavior = [.canJoinAllSpaces, .ignoresCycle]
        window.makeKeyAndOrderFront(nil)
        return window
    }
}

