import Foundation
import ServiceManagement

class StartupManager {
    static func configureStartup(enabled: Bool) {
        let appService = SMAppService.mainApp

        do {
            if enabled {
                try appService.register()
                Logger.info("Enabled run on startup.")
            } else {
                try appService.unregister()
                Logger.info("Disabled run on startup.")
            }
        } catch {
            Logger.error("Failed to update run on startup setting: \(error)")
        }
    }
}

