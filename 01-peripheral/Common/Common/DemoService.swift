import Foundation
import CoreBluetooth

/// UUID generated from  https://www.uuidgenerator.net
public struct DemoService {
    public static let serviceUUID = CBUUID(string: "78e0728d-01d5-4569-83f6-7b11c4a00000")
    public static let colorUUID = CBUUID(string: "78e0728d-01d5-4569-83f6-7b11c4a00001")
    public static let temperatureUUID = CBUUID(string: "78e0728d-01d5-4569-83f6-7b11c4a00002")
}
