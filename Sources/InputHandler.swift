import Cocoa

// class InputHandler {
//     static func trackMouse(for crosshairView: CrosshairView) {
//         NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved, .leftMouseDown, .rightMouseDown, .otherMouseDown]) { event in
//             crosshairView.updatePosition(to: event.locationInWindow)
//         }
//
//         NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDragged, .rightMouseDragged, .otherMouseDragged]) { event in
//             crosshairView.updatePosition(to: event.locationInWindow)
//         }
//     }
// }
//

class InputHandler {
    static func trackMouse(for crosshairView: CrosshairView) {
        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved, .leftMouseDown, .rightMouseDown, .otherMouseDown]) { _ in
            let globalPoint = NSEvent.mouseLocation
            crosshairView.updatePosition(to: globalPoint)
        }

        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDragged, .rightMouseDragged, .otherMouseDragged]) { _ in
            let globalPoint = NSEvent.mouseLocation
            crosshairView.updatePosition(to: globalPoint)
        }
    }
}
