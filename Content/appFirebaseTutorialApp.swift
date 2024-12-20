import SwiftUI
import Firebase
import FirebaseAuth

@main
struct appFirebaseTutorialApp: App {
    @StateObject var dataManager = DataManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(dataManager)
        }
    }
}
