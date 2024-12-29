import Foundation

struct Configuration: Codable {
    struct Crosshair: Codable {
        struct Dot: Codable {
            let enabled: Bool
            let size: CGFloat
            let color: [CGFloat]
        }

        let length: CGFloat
        let thickness: CGFloat
        let color: [CGFloat]
        let centerGap: CGFloat
        let dot: Dot
    }
    struct Cursor: Codable {
        let hide: Bool
    }

    struct OnClick: Codable {
        let enabled: Bool
        let size: CGFloat
        let color: [CGFloat]
        let duration: TimeInterval
        let fadeDuration: Int // in milliseconds
    }

    let crosshair: Crosshair
    let cursor: Cursor?
    let onclick: OnClick?

    // Default configuration
    static func defaultConfiguration() -> Configuration {
        return Configuration(
            crosshair: Crosshair(
                length: 50,
                thickness: 2,
                color: [1.0, 1.0, 1.0, 1.0],
                centerGap: 10,
                dot: Crosshair.Dot(
                    enabled: false,
                    size: 5,
                    color: [1.0, 1.0, 1.0, 1.0]
                )
            ),
            cursor: Cursor(hide: false), // Default to not hiding the cursor
            onclick: OnClick(
                enabled: true,
                size: 20,
                color: [0.0, 1.0, 0.0, 1.0],
                duration: 0.5,
                fadeDuration: 250
            )
        )
    }

    // Load JSON configuration
    static func load(from path: String) -> Configuration? {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            Logger.error("Failed to load configuration file at \(path).")
            return nil
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Configuration.self, from: data)
        } catch {
            Logger.error("Error decoding JSON configuration: \(error)")
            return nil
        }
    }
}

