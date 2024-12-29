import Cocoa
class CrosshairView: NSView {
    var crosshairPosition: CGPoint = .zero
    var config: Configuration.Crosshair
    private var clickPosition: CGPoint?
    private var clickConfig: Configuration.OnClick?
    private var dotAlpha: CGFloat = 1.0  // Track the current alpha value for fade-out

init(frame frameRect: NSRect, configuration: Configuration.Crosshair?, onclickConfig: Configuration.OnClick?) {
        self.config = configuration ?? Configuration.Crosshair(
            length: 50,
            thickness: 2,
            color: [1.0, 0.0, 0.0, 1.0],
            centerGap: 5,
            dot: Configuration.Crosshair.Dot(enabled: false, size: 0, color: [0.0, 0.0, 0.0, 0.0])
        )
        self.clickConfig = onclickConfig
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Clear the view
        NSColor.clear.set()
        NSBezierPath.fill(bounds)

        // Draw the crosshair
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

        // Draw the onclick visualization AFTER the crosshair
        if let clickPosition = clickPosition, let clickConfig = clickConfig, clickConfig.enabled {
            let clickColor = NSColor(
                red: clickConfig.color[0],
                green: clickConfig.color[1],
                blue: clickConfig.color[2],
                alpha: clickConfig.color[3] * dotAlpha  // Apply fading alpha
            )
            clickColor.set()
            let dotRect = CGRect(
                x: clickPosition.x - clickConfig.size / 2,
                y: clickPosition.y - clickConfig.size / 2,
                width: clickConfig.size,
                height: clickConfig.size
            )
            let dotPath = NSBezierPath(ovalIn: dotRect)
            dotPath.fill()
        }
    }

    func showClickVisualization(at point: CGPoint) {

        guard let clickConfig = clickConfig, clickConfig.enabled else {
            return
        }
        Logger.info("showClickVisualization was called at point: \(point)")
        Logger.info("Click visualization is enabled with size: \(clickConfig.size) and duration: \(clickConfig.duration)")

        clickPosition = convert(point, from: nil)  // Convert global to local coordinates
        dotAlpha = 1.0
        setNeedsDisplay(bounds)  // Trigger a redraw

        let fadeSteps = 10
        let fadeInterval = (Double(clickConfig.fadeDuration) / Double(fadeSteps)) / 1000.0  // Convert milliseconds to seconds
        let displayTime = clickConfig.duration / 1000.0  // Convert milliseconds to seconds

        // If fadeDuration is 0, do not fade out
        if clickConfig.fadeDuration > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + displayTime) {
                var currentStep = 0
                Timer.scheduledTimer(withTimeInterval: fadeInterval, repeats: true) { timer in
                    currentStep += 1
                    self.dotAlpha = max(0.0, 1.0 - CGFloat(currentStep) / CGFloat(fadeSteps))
                    self.setNeedsDisplay(self.bounds)

                    if currentStep >= fadeSteps {
                        timer.invalidate()
                        self.clickPosition = nil
                        self.dotAlpha = 1.0  // Reset for future clicks
                        self.setNeedsDisplay(self.bounds)
                    }
                }
            }
        } else {
            // If no fade-out, just hide after the duration
            DispatchQueue.main.asyncAfter(deadline: .now() + displayTime) {
                self.clickPosition = nil
                self.setNeedsDisplay(self.bounds)
            }
        }

    }

    func updateConfiguration(crosshair: Configuration.Crosshair, onclick: Configuration.OnClick?) {
        self.config = crosshair
        self.clickConfig = onclick
        setNeedsDisplay(bounds)  // Refresh view with new configuration
    }

func updatePosition(to globalPoint: CGPoint) {
    // Identify the screen containing the cursor
    guard let screen = NSScreen.screens.first(where: { $0.frame.contains(globalPoint) }) else {
        Logger.error("Cursor is outside of known screen bounds.")
        return
    }

    // Convert globalPoint to the local screen's coordinate space
    let screenOrigin = screen.frame.origin
    let localPoint = CGPoint(
        x: globalPoint.x - screenOrigin.x,
        y: globalPoint.y - screenOrigin.y
    )

    // Update crosshair position directly in the local coordinate space
    crosshairPosition = localPoint
    Logger.info("""
        Cursor Position (Global): \(globalPoint)
        Screen: \(screen.localizedName)
        Screen Frame: \(screen.frame)
        Local Position (Screen Relative): \(crosshairPosition)
    """)
    setNeedsDisplay(bounds)  // Trigger a redraw
}
}

