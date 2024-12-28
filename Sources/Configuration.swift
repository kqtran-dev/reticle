import Foundation

// Define structs for JSON configuration
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

    let crosshair: Crosshair
}

// Load JSON configuration
func loadConfiguration(from path: String) -> Configuration? {
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        print("Failed to load configuration file at \(path).")
        return nil
    }

    do {
        let decoder = JSONDecoder()
        let config = try decoder.decode(Configuration.self, from: data)
        print("Configuration loaded successfully: \(config)")
        return config
    } catch {
        print("Error decoding JSON configuration: \(error)")
        return nil
    }
}

