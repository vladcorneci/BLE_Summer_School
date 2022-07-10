import Foundation
import CoreBluetooth

/// UUID generated from  https://www.uuidgenerator.net
public struct DemoService {
    public static let serviceUUID = CBUUID(string: "<uuid>")
    public static let colorUUID = CBUUID(string: "<uuid>")
    public static let temperatureUUID = CBUUID(string: "<uuid>")
}
