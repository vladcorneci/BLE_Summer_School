import SwiftUI
import CoreBluetooth

struct ContentView {
    @EnvironmentObject var peripheralViewModel: PeripheralViewModel
}

extension ContentView: View {
    var body: some View {
        VStack {
            Text("Current color \(peripheralViewModel.color.description)")
            Rectangle()
                .fill(peripheralViewModel.color)
                .border(.black, width: 2)
                .frame(width: 100, height: 100, alignment: .center)
            if let temperature = peripheralViewModel.temperature {
                Text("Current temperature: \(temperature)")
            } else {
                Text("No value")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PeripheralViewModel(peripheralManager: CBPeripheralManager()))
    }
}
