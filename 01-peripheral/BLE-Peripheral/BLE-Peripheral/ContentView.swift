import SwiftUI
import CoreBluetooth

struct ContentView {
    @EnvironmentObject var peripheralViewModel: PeripheralViewModel
}

extension ContentView: View {
    var body: some View {
        Text("Hello")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PeripheralViewModel(peripheralManager: CBPeripheralManager()))
    }
}
