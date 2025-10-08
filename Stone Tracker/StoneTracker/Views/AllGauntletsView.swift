import SwiftUI

struct AllGauntletsView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var stoneManager: StoneManager
    @State private var selectedUser: User?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Statistics Section
                    VStack(spacing: 15) {
                        Text("Infinity Stone Statistics")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack(spacing: 20) {
                            StatCard(
                                title: "Total Users",
                                value: "\(stoneManager.allUsers.count)",
                                color: .blue
                            )
                            
                            StatCard(
                                title: "Complete Gauntlets",
                                value: "\(stoneManager.getUsersWithCompleteGauntlet().count)",
                                color: .yellow
                            )
                            
                            StatCard(
                                title: "Stones Collected",
                                value: "\(stoneManager.allUsers.reduce(0) { $0 + $1.stones.count })/\(stoneManager.allUsers.count * 6)",
                                color: .purple
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Users List
                    if stoneManager.allUsers.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "person.2")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("No Users Yet")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Be the first to join the infinity stone hunt!")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    } else {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("All Hunters")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            LazyVStack(spacing: 12) {
                                ForEach(stoneManager.allUsers) { user in
                                    UserGauntletCard(
                                        user: user,
                                        isCurrentUser: user.id == authManager.currentUser?.id
                                    ) {
                                        selectedUser = user
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("All Gauntlets")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                // Refresh data
                stoneManager.startListeningForUsers()
            }
            .sheet(item: $selectedUser) { user in
                UserDetailView(user: user)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    AllGauntletsView()
        .environmentObject(AuthenticationManager())
        .environmentObject(StoneManager())
}
