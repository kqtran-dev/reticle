import Cocoa

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

    func applicationDidFinishLaunching(_ notification: Notification) {
        let screenFrame = NSScreen.main!.frame

        // Transparent overlay window
        window = NSWindow(
            contentRect: screenFrame,
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

        crosshairView = CrosshairView(frame: screenFrame)
        window.contentView?.addSubview(crosshairView)

        // Mouse tracking
        NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { event in
            self.crosshairView.updatePosition(to: event.locationInWindow)
        }
    }
}

class CrosshairView: NSView {
    var crosshairPosition: CGPoint = .zero

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Clear view
        NSColor.clear.set()
        NSBezierPath.fill(bounds)

        // Draw crosshair
        let lineLength: CGFloat = 50.0
        let lineWidth: CGFloat = 2.0
        let color = NSColor.red
        let center = crosshairPosition

        color.set()
        let path = NSBezierPath()
        path.lineWidth = lineWidth

        // Horizontal line
        path.move(to: CGPoint(x: center.x - lineLength / 2, y: center.y))
        path.line(to: CGPoint(x: center.x + lineLength / 2, y: center.y))

        // Vertical line
        path.move(to: CGPoint(x: center.x, y: center.y - lineLength / 2))
        path.line(to: CGPoint(x: center.x, y: center.y + lineLength / 2))

        path.stroke()
    }

func updatePosition(to globalPoint: CGPoint) {
    // Convert the global point to the window's local coordinates
    let localPoint = convert(globalPoint, from: nil) // Automatically accounts for coordinate flipping
    crosshairPosition = localPoint
    setNeedsDisplay(bounds)  // Refresh the view
    }
    private func convertToViewCoordinates(globalPoint: CGPoint) -> CGPoint {
        guard let screenFrame = NSScreen.main?.frame else { return .zero }
        return CGPoint(x: globalPoint.x, y: screenFrame.height - globalPoint.y)
    }
}
