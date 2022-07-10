import Combine
import Common
import CoreBluetooth
import Foundation
import os

class CentralViewModel: NSObject, ObservableObject {
    private var discoveredPeripheral: CBPeripheral?
    private var temperatureCharacteristic: CBCharacteristic?
    private var colorCharacteristic: CBCharacteristic?

    private var centralManager: CBCentralManager

    init(centralManager: CBCentralManager) {
        self.centralManager = centralManager
        super.init()

        self.centralManager.delegate = self
    }
}

extension CentralViewModel {
    /*
     * We will first check if we are already connected to our counterpart
     * Otherwise, scan for peripherals - specifically for our service's 128bit CBUUID
     */
    private func retrievePeripheral() {
        // TODO: Add implementation
    }
}

// MARK: CBCentralManagerDelegate
extension CentralViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            os_log("CBManager is powered on")
            retrievePeripheral()
        case .poweredOff:
            os_log("CBManager is not powered on")
            return
        case .resetting:
            os_log("CBManager is resetting")
            // In a real app, you'd deal with all the states accordingly
            return
        case .unauthorized:
            // In a real app, you'd deal with all the states accordingly
            os_log("Unexpected authorization")
            return
        case .unknown:
            os_log("CBManager state is unknown")
            // In a real app, you'd deal with all the states accordingly
            return
        case .unsupported:
            os_log("Bluetooth is not supported on this device")
            // In a real app, you'd deal with all the states accordingly
            return
        default:
            os_log("A previously unknown central manager state occurred")
            // In a real app, you'd deal with yet unknown cases that might occur in the future
            return
        }
    }

    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {

        // Reject if the signal strength is too low to attempt data transfer.
        // Change the minimum RSSI value depending on your app’s use case.
        guard RSSI.intValue >= -50
            else {
                os_log("Discovered perhiperal not in expected range, at %d", RSSI.intValue)
                return
        }

        os_log("Discovered %s at %d", String(describing: peripheral.name), RSSI.intValue)

        // TODO: Save a reference to CBPeripheral and connect.
    }

    /*
     *  We've connected to the peripheral, now we need to discover the services
     *  and characteristics to find the 'demo' characteristic.
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        os_log("Peripheral Connected")

        // TODO: Stop scanning, set delegate and start Service discovery
    }
}

extension CentralViewModel: CBPeripheralDelegate {
    /*
     *  The Demo Service was discovered
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            os_log("Error discovering services: %s", error.localizedDescription)
            return
        }

        // Discover the characteristic we want...

        // TODO: Loop through the newly filled peripheral.services array.
    }

    /*
     *  The Demo characteristic was discovered.
     *  Once this has been found, we want to subscribe to it, which lets the
     *  peripheral know we want the data it contains
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // Deal with errors (if any).
        if let error = error {
            os_log("Error discovering characteristics: %s", error.localizedDescription)
            return
        }

        // Again, we loop through the array, just in case and check if it's the right one
        // TODO: Save reference to characteristics and setNotify values
    }

    /*
     *   This callback lets us know more data has arrived via notification on the
     *   characteristic.
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // Deal with errors (if any)
        if let error = error {
            os_log("Error discovering characteristics: %s", error.localizedDescription)
            return
        }

        // TODO: Print received data
    }

    /*
     *  The peripheral letting us know whether our subscribe/unsubscribe happened or not
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        // Deal with errors (if any)
        if let error = error {
            os_log("Error changing notification state: %s", error.localizedDescription)
            return
        }

        guard
            characteristic.uuid == DemoService.temperatureUUID ||
            characteristic.uuid == DemoService.colorUUID
        else { return }

        if characteristic.isNotifying {
            // Notification has started
            os_log("Notification began on %@", characteristic)
        } else {
            // Notification has stopped, so disconnect from the peripheral
            os_log("Notification stopped on %@. Disconnecting", characteristic)
        }
    }

    /*
     *  This is called when peripheral is ready to accept more data when using write without response
     */
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        os_log("Peripheral is ready, send data")
    }
}
