import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
struct StoneTrackerApp: App {
    @StateObject private var authManager = AuthenticationManager()
    @StateObject private var stoneManager = StoneManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
                .environmentObject(stoneManager)
        }
    }
}
