import Cocoa
class CrosshairView: NSView {
    var crosshairPosition: CGPoint = .zero
    var config: Configuration.Crosshair

    init(frame frameRect: NSRect, configuration: Configuration.Crosshair?) {
        self.config = configuration ?? Configuration.Crosshair(
            length: 50,
            thickness: 2,
            color: [1.0, 0.0, 0.0, 1.0],
            centerGap: 5,
            dot: Configuration.Crosshair.Dot(enabled: false, size: 0, color: [0.0, 0.0, 0.0, 0.0])
        )
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Clear view
        NSColor.clear.set()
        NSBezierPath.fill(bounds)

        // Draw crosshair
        let color = NSColor(
            red: config.color[0],
            green: config.color[1],
            blue: config.color[2],
            alpha: config.color[3]
        )
        color.set()
        let path = NSBezierPath()
        path.lineWidth = config.thickness

        let center = crosshairPosition
        let gap = config.centerGap
        let length = config.length

        // Horizontal line
        path.move(to: CGPoint(x: center.x - length / 2, y: center.y))
        path.line(to: CGPoint(x: center.x - gap / 2, y: center.y))
        path.move(to: CGPoint(x: center.x + gap / 2, y: center.y))
        path.line(to: CGPoint(x: center.x + length / 2, y: center.y))

        // Vertical line
        path.move(to: CGPoint(x: center.x, y: center.y - length / 2))
        path.line(to: CGPoint(x: center.x, y: center.y - gap / 2))
        path.move(to: CGPoint(x: center.x, y: center.y + gap / 2))
        path.line(to: CGPoint(x: center.x, y: center.y + length / 2))

        path.stroke()

        // Draw center dot if enabled
        if config.dot.enabled {
            let dotColor = NSColor(
                red: config.dot.color[0],
                green: config.dot.color[1],
                blue: config.dot.color[2],
                alpha: config.dot.color[3]
            )
            dotColor.set()
            let dotRect = CGRect(
                x: center.x - config.dot.size / 2,
                y: center.y - config.dot.size / 2,
                width: config.dot.size,
                height: config.dot.size
            )
            let dotPath = NSBezierPath(ovalIn: dotRect)
            dotPath.fill()
        }
    }

    func updatePosition(to globalPoint: CGPoint) {
        let localPoint = convert(globalPoint, from: nil)
        crosshairPosition = localPoint
        setNeedsDisplay(bounds)
    }

    func updateConfiguration(configuration: Configuration.Crosshair) {
        self.config = configuration
        setNeedsDisplay(bounds)  // Refresh view with new configuration
    }
}

