import Foundation

extension Double {
    public var temperature: String {
        String(format: "%.2f", self)
    }
}
