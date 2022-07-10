import CoreBluetooth
import SwiftUI

@main
struct BLE_CentralApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CentralViewModel(centralManager: CBCentralManager()))
        }
    }
}
