import Combine
import Common
import CoreBluetooth
import Foundation
import os
import SwiftUI

class PeripheralViewModel: NSObject, ObservableObject {
    @Published var color: Color = .white
    @Published var temperature: String = "39.0"

    private var connectedCentral: CBCentral?
    private var temperatureCharacteristic: CBMutableCharacteristic?
    private var colorCharacteristic: CBMutableCharacteristic?

    private let peripheralManager: CBPeripheralManager

    private var cancellables = Set<AnyCancellable>()
    
    init(peripheralManager: CBPeripheralManager) {
        self.peripheralManager = peripheralManager
        super.init()
        self.peripheralManager.delegate = self
        
        TemperatureGenerator().values
            .assign(to: &$temperature)
        
        $temperature
            .sink { [weak self] value in
                guard
                    let self = self,
                    let temperatureCharacteristic = self.temperatureCharacteristic,
                    let connectedCentral = self.connectedCentral,
                    let newValue = self.temperature.data(using: .ascii)
                else { return }

                temperatureCharacteristic.value = newValue

                // Send notification
                peripheralManager.updateValue(
                    newValue,
                    for: temperatureCharacteristic,
                    onSubscribedCentrals: [connectedCentral]
                )
            }
            .store(in: &cancellables)
    }
}

extension PeripheralViewModel {
    private func registerGATTProfile() {
        let colorCharacteristic = CBMutableCharacteristic(
            type: DemoService.colorUUID,
            properties: [.write, .read, .writeWithoutResponse],
            value: nil,
            permissions: [.readable, .writeable]
        )

        let temperatureCharacteristic = CBMutableCharacteristic(
            type: DemoService.temperatureUUID,
            properties: [.read, .notify],
            value: nil,
            permissions: [.readable]
        )

        let demoService = CBMutableService(
            type: DemoService.serviceUUID,
            primary: true
        )

        self.temperatureCharacteristic = temperatureCharacteristic
        self.colorCharacteristic = colorCharacteristic

        demoService.characteristics = [
            temperatureCharacteristic,
            colorCharacteristic
        ]

        peripheralManager.add(demoService)
    }

    private func startAdvertising(peripheral: CBPeripheralManager) {
        peripheral.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey: [DemoService.serviceUUID]
        ])
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
            startAdvertising(peripheral: peripheral)

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
        connectedCentral = central
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        os_log("Central unsubscribed from characteristic \(characteristic.uuid)")
        connectedCentral = nil
    }

    // MARK: ATT Requests
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        os_log("Received write requests \(requests.count)")
        for request in requests {
            guard
                request.characteristic == colorCharacteristic,
                let value = request.value
            else {
                os_log("Write not permited for request.characteristic")
                peripheral.respond(to: requests.first!, withResult: .writeNotPermitted)
                return
            }

            guard let color = Color(value) else {
                os_log("Could not get a color from write request")
                return
            }

            self.color = color

            guard
                let colorCharacteristic = colorCharacteristic,
                let connectedCentral = connectedCentral
            else { return }
            self.colorCharacteristic?.value = value

            peripheralManager.updateValue(value, for: colorCharacteristic, onSubscribedCentrals: [connectedCentral])
        }
        
        peripheral.respond(to: requests.first!, withResult: .success)
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        os_log("Received read request for characteristic \(request.characteristic.uuid)")

        if request.characteristic == temperatureCharacteristic {
            request.value = temperatureCharacteristic?.value
        } else if request.characteristic == colorCharacteristic {
            request.value = colorCharacteristic?.value
        } else {
            os_log("Received invalid read request for characteristic \(request.characteristic.uuid)")
            peripheral.respond(to: request, withResult: .readNotPermitted)
        }

        peripheral.respond(to: request, withResult: .success)
    }
}
