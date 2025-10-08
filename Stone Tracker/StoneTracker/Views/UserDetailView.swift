import SwiftUI

struct UserDetailView: View {
    let user: User
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // User Header
                    VStack(spacing: 15) {
                        ZStack {
                            Circle()
                                .fill(Color.purple.opacity(0.2))
                                .frame(width: 100, height: 100)
                            
                            if user.stones.count == 6 {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.yellow)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.purple)
                            }
                        }
                        
                        VStack(spacing: 5) {
                            Text(user.name)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("\(user.stones.count)/6 Infinity Stones")
                                .font(.headline)
                                .foregroundColor(user.stones.count == 6 ? .yellow : .purple)
                        }
                    }
                    .padding(.top)
                    
                    // Gauntlet Visualization
                    VStack(spacing: 15) {
                        Text("Infinity Gauntlet")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if user.stones.isEmpty {
                            VStack(spacing: 15) {
                                Image(systemName: "hand.raised")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                
                                Text("Empty Gauntlet")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Text("This hunter hasn't collected any stones yet.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(15)
                        } else {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                                ForEach(InfinityStone.allStones) { stone in
                                    VStack(spacing: 8) {
                                        ZStack {
                                            Circle()
                                                .fill(getStoneColor(stone.color).opacity(0.2))
                                                .frame(width: 60, height: 60)
                                            
                                            Circle()
                                                .stroke(getStoneColor(stone.color), lineWidth: 3)
                                                .frame(width: 60, height: 60)
                                            
                                            if user.stones.contains(where: { $0.id == stone.id }) {
                                                Image(systemName: "diamond.fill")
                                                    .font(.title2)
                                                    .foregroundColor(getStoneColor(stone.color))
                                            } else {
                                                Image(systemName: "diamond")
                                                    .font(.title2)
                                                    .foregroundColor(.gray.opacity(0.3))
                                            }
                                        }
                                        
                                        Text(stone.name)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .multilineTextAlignment(.center)
                                        
                                        Text(stone.power)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                            .lineLimit(2)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Complete Gauntlet Celebration
                    if user.stones.count == 6 {
                        VStack(spacing: 15) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 40))
                                .foregroundColor(.yellow)
                            
                            Text("🎉 COMPLETE GAUNTLET! 🎉")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                            
                            Text("This hunter has collected all infinity stones and achieved ultimate power!")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.yellow.opacity(0.1), .orange.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(15)
                        .padding(.horizontal)
                    }
                    
                    // Stone Details
                    if !user.stones.isEmpty {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Collected Stones")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ForEach(user.stones) { stone in
                                HStack(spacing: 15) {
                                    ZStack {
                                        Circle()
                                            .fill(getStoneColor(stone.color).opacity(0.2))
                                            .frame(width: 40, height: 40)
                                        
                                        Circle()
                                            .stroke(getStoneColor(stone.color), lineWidth: 2)
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: "diamond.fill")
                                            .font(.title3)
                                            .foregroundColor(getStoneColor(stone.color))
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(stone.name)
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(stone.power)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            
                                            if let acquiredFrom = stone.acquiredFrom, !acquiredFrom.isEmpty {
                                                Text("From: \(acquiredFrom)")
                                                    .font(.caption)
                                                    .foregroundColor(.purple)
                                                    .fontWeight(.medium)
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(color: getStoneColor(stone.color).opacity(0.2), radius: 3, x: 0, y: 1)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Hunter Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func getStoneColor(_ colorString: String) -> Color {
        switch colorString {
        case "purple": return .purple
        case "blue": return .blue
        case "red": return .red
        case "orange": return .orange
        case "green": return .green
        case "yellow": return .yellow
        default: return .gray
        }
    }
}

#Preview {
    UserDetailView(user: User(name: "Test User", email: "test@example.com", stones: [
        InfinityStone.allStones[0],
        InfinityStone.allStones[1],
        InfinityStone.allStones[2]
    ]))
}
