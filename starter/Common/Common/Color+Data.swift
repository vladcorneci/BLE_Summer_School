import SwiftUI

extension Color {
    public init?(_ data: Data) {
        guard data.count >= 3 else { return nil }

        self = Color(
            .sRGBLinear,
            red: Double(data[0]) / 255,
            green: Double(data[1]) / 255,
            blue: Double(data[2]) / 255,
            opacity: 1.0
        )
    }
}
