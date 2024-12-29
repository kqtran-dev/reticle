import Cocoa

class InputHandler {
    static func trackMouse(for crosshairView: CrosshairView) {
        NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { event in
            crosshairView.updatePosition(to: event.locationInWindow)
        }

        NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDragged) { event in
            crosshairView.updatePosition(to: event.locationInWindow)
        }

        NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { event in
            crosshairView.showClickVisualization(at: event.locationInWindow)
        }
    }
}

