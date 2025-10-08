import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        TabView {
            MyStonesView()
                .tabItem {
                    Image(systemName: "diamond")
                    Text("My Stones")
                }
            
            AllGauntletsView()
                .tabItem {
                    Image(systemName: "hand.raised.fill")
                    Text("All Gauntlets")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
        .accentColor(.purple)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AuthenticationManager())
        .environmentObject(StoneManager())
}
