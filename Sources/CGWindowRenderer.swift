import Cocoa
import QuartzCore

class CGWindowRenderer {
    private var overlayWindow: NSWindow!

    init() {
        setupCGWindow()
    }

    private func setupCGWindow() {
        // Calculate the combined frame for all screens
        let combinedFrame = NSScreen.screens.reduce(CGRect.zero) { $0.union($1.frame) }

        // Create an NSWindow for the overlay
        overlayWindow = NSWindow(
            contentRect: combinedFrame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )
        overlayWindow.isOpaque = false
        overlayWindow.backgroundColor = NSColor.clear
        overlayWindow.level = .screenSaver  // Ensures it's above system UI
        overlayWindow.ignoresMouseEvents = true
        overlayWindow.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        overlayWindow.makeKeyAndOrderFront(nil)

        // Set up a layer-backed content view
        overlayWindow.contentView?.wantsLayer = true
        overlayWindow.contentView?.layer = CALayer()
        overlayWindow.contentView?.layer?.backgroundColor = NSColor.clear.cgColor
    }

    func drawReticle(at point: CGPoint, size: CGFloat = 50, color: NSColor = .red) {
        guard let layer = overlayWindow.contentView?.layer else { return }

        // Clear previous drawings
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        // Draw a crosshair
        let crosshairLayer = CALayer()
        crosshairLayer.frame = CGRect(
            x: point.x - size / 2,
            y: point.y - size / 2,
            width: size,
            height: size
        )
        crosshairLayer.backgroundColor = color.cgColor
        crosshairLayer.cornerRadius = size / 2
        layer.addSublayer(crosshairLayer)
    }
}

