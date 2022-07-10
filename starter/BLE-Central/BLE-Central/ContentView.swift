import CoreBluetooth
import SwiftUI

struct ContentView {
    @EnvironmentObject var centralViewModel: CentralViewModel
}


extension ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CentralViewModel(centralManager: CBCentralManager()))
    }
}
