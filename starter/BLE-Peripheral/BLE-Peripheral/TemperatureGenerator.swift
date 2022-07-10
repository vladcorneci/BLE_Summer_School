import Combine
import Foundation

struct TemperatureGenerator {
    let values: AnyPublisher<String, Never> = Timer
        .TimerPublisher(interval: 2.0, runLoop: .main, mode: .default)
        .autoconnect()
        .map { _ in Double.random(in: 29...31) }
        .map { String(format: "%.2f", $0) }
        .eraseToAnyPublisher()
}
