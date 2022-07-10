import CoreBluetooth
import SwiftUI

@main
struct BLE_PeripheralApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(PeripheralViewModel(peripheralManager: CBPeripheralManager()))
        }
    }
}
