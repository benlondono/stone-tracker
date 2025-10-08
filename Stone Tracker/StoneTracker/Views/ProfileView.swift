import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var stoneManager: StoneManager
    @State private var showingEditProfile = false
    @State private var showingSignOutAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    if let user = authManager.currentUser {
                        // Profile Header
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.purple, .blue],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                
                                if user.stones.count == 6 {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.yellow)
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            VStack(spacing: 8) {
                                Text(user.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "diamond.fill")
                                        .foregroundColor(.purple)
                                    Text("\(user.stones.count)/6 stones")
                                        .font(.headline)
                                        .foregroundColor(.purple)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.purple.opacity(0.1))
                                .cornerRadius(20)
                            }
                        }
                        .padding(.top)
                        
                        // Stats Section
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Your Statistics")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                StatRow(
                                    icon: "calendar",
                                    title: "Member Since",
                                    value: formatDate(user.createdAt),
                                    color: .blue
                                )
                                
                                StatRow(
                                    icon: "diamond.fill",
                                    title: "Stones Collected",
                                    value: "\(user.stones.count)",
                                    color: .purple
                                )
                                
                                StatRow(
                                    icon: "percent",
                                    title: "Collection Progress",
                                    value: "\(Int(Double(user.stones.count) / 6.0 * 100))%",
                                    color: .green
                                )
                                
                                StatRow(
                                    icon: "trophy.fill",
                                    title: "Ranking",
                                    value: getRanking(),
                                    color: .orange
                                )
                            }
                            .padding(.horizontal)
                        }
                        
                        // Actions Section
                        VStack(spacing: 15) {
                            Button(action: {
                                showingEditProfile = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Profile")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
                            }
                            
                            Button(action: {
                                showingSignOutAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                    Text("Sign Out")
                                    Spacer()
                                }
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                        
                        // App Info
                        VStack(spacing: 10) {
                            Text("Infinity Stone Tracker")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("Version 1.0")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("Track your infinity stones and compete with other hunters!")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
            .alert("Sign Out", isPresented: $showingSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    authManager.signOut()
                }
            } message: {
                Text("Are you sure you want to sign out? You'll need to sign in again to access your stones.")
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func getRanking() -> String {
        guard let currentUser = authManager.currentUser else { return "Unknown" }
        
        let usersWithMoreStones = stoneManager.allUsers.filter { user in
            user.id != currentUser.id && user.stones.count > currentUser.stones.count
        }.count
        
        let rank = usersWithMoreStones + 1
        let totalUsers = stoneManager.allUsers.count
        
        if rank == 1 && currentUser.stones.count == 6 {
            return "1st (Complete!)"
        } else if rank <= 3 {
            return "\(rank)\(getOrdinalSuffix(rank))"
        } else {
            return "\(rank) of \(totalUsers)"
        }
    }
    
    private func getOrdinalSuffix(_ number: Int) -> String {
        switch number {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
}

struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 25)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationManager())
        .environmentObject(StoneManager())
}
