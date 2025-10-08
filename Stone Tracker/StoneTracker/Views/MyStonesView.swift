import SwiftUI

struct MyStonesView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var stoneManager: StoneManager
    @State private var showingStonePicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // User's Current Stones
                    if let user = authManager.currentUser {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("My Collection")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Text("\(user.stones.count)/6")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(12)
                            }
                            
                            if user.stones.isEmpty {
                                VStack(spacing: 15) {
                                    Image(systemName: "diamond")
                                        .font(.system(size: 50))
                                        .foregroundColor(.gray)
                                    
                                    Text("No stones yet")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    
                                    Text("Tap the + button to add your first infinity stone!")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 40)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(15)
                            } else {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                                    ForEach(user.stones) { stone in
                                        StoneCard(stone: stone, isOwned: true) {
                                            stoneManager.removeStone(stone, from: user)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Available Stones Section
                        let availableStones = stoneManager.getAvailableStones(for: user)
                        
                        if !availableStones.isEmpty {
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Available Stones")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                                    ForEach(availableStones) { stone in
                                        StoneCard(stone: stone, isOwned: false) {
                                            stoneManager.addStone(stone, to: user)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Complete Gauntlet Celebration
                        if user.stones.count == 6 {
                            VStack(spacing: 15) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.yellow)
                                
                                Text("🎉 COMPLETE GAUNTLET! 🎉")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.purple)
                                
                                Text("You have collected all infinity stones! You are now the most powerful being in the universe!")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.purple.opacity(0.1), .yellow.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(15)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Infinity Stones")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let user = authManager.currentUser,
                       !stoneManager.getAvailableStones(for: user).isEmpty {
                        Button(action: {
                            showingStonePicker = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.purple)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingStonePicker) {
                StonePickerView()
            }
        }
        .onAppear {
            if let user = authManager.currentUser {
                stoneManager.updateUserInFirestore(user)
            }
        }
    }
}

#Preview {
    MyStonesView()
        .environmentObject(AuthenticationManager())
        .environmentObject(StoneManager())
}
