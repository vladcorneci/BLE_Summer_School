import Combine
import Common
import CoreBluetooth
import Foundation
import os
import SwiftUI

class PeripheralViewModel: NSObject, ObservableObject {
    private let peripheralManager: CBPeripheralManager

    private var cancellables = Set<AnyCancellable>()
    
    init(peripheralManager: CBPeripheralManager) {
        self.peripheralManager = peripheralManager
        super.init()
        self.peripheralManager.delegate = self
    }
}

extension PeripheralViewModel {
    private func registerGATTProfile() {
        // TODO: Add implementation
    }

    private func startAdvertising() {
        // TODO: Add implementation
    }
}

// MARK: TODO Register GATT Profile

extension PeripheralViewModel: CBPeripheralManagerDelegate {
    internal func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            // ... so start working with the peripheral
            os_log("CBPeripheralManager is powered on")

            // Register GATT profile & Start Advertising
            registerGATTProfile()
            startAdvertising()

        case .poweredOff:
            os_log("CBPeripheralManager is not powered on")
            // In a real app, you'd deal with all the states accordingly
            return
        case .resetting:
            os_log("CBPeripheralManager is resetting")
            // In a real app, you'd deal with all the states accordingly
            return
        case .unauthorized:
            // In a real app, you'd deal with all the states accordingly
            os_log("Bluetooth is restricted")
            return
        case .unknown:
            os_log("CBPeripheralManager state is unknown")
            // In a real app, you'd deal with all the states accordingly
            return
        case .unsupported:
            os_log("Bluetooth is not supported on this device")
            // In a real app, you'd deal with all the states accordingly
            return
        @unknown default:
            os_log("A previously unknown peripheral manager state occurred")
            // In a real app, you'd deal with yet unknown cases that might occur in the future
            return
        }
    }

    // MARK: Handle Connection
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        os_log("Central unsubscribed from characteristic \(characteristic.uuid)")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        os_log("Central unsubscribed from characteristic \(characteristic.uuid)")
    }

    // MARK: ATT Requests
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        os_log("Received write requests \(requests.count)")
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        os_log("Received read request for characteristic \(request.characteristic.uuid)")
    }
}
