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
        window.level = .screenSaver
        window.ignoresMouseEvents = true
        window.collectionBehavior = .canJoinAllSpaces
        window.makeKeyAndOrderFront(nil)
        return window
    }
}

