import SwiftUI

struct UserGauntletCard: View {
    let user: User
    let isCurrentUser: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 15) {
                // User Info
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(user.name)
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            if isCurrentUser {
                                Text("(You)")
                                    .font(.caption)
                                    .foregroundColor(.purple)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.purple.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                        
                        Text("\(user.stones.count)/6 stones")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Progress Ring
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 4)
                            .frame(width: 50, height: 50)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(user.stones.count) / 6.0)
                            .stroke(
                                user.stones.count == 6 ? Color.yellow : Color.purple,
                                style: StrokeStyle(lineWidth: 4, lineCap: .round)
                            )
                            .frame(width: 50, height: 50)
                            .rotationEffect(.degrees(-90))
                        
                        if user.stones.count == 6 {
                            Image(systemName: "crown.fill")
                                .font(.title3)
                                .foregroundColor(.yellow)
                        } else {
                            Text("\(user.stones.count)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                // Stones Preview
                if user.stones.isEmpty {
                    HStack {
                        Image(systemName: "diamond")
                            .foregroundColor(.gray)
                        Text("No stones collected yet")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(InfinityStone.allStones) { stone in
                                ZStack {
                                    Circle()
                                        .fill(getStoneColor(stone.color).opacity(0.2))
                                        .frame(width: 30, height: 30)
                                    
                                    Circle()
                                        .stroke(getStoneColor(stone.color), lineWidth: 2)
                                        .frame(width: 30, height: 30)
                                    
                                    if user.stones.contains(where: { $0.id == stone.id }) {
                                        Image(systemName: "diamond.fill")
                                            .font(.caption)
                                            .foregroundColor(getStoneColor(stone.color))
                                    } else {
                                        Image(systemName: "diamond")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isCurrentUser ? Color.purple : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
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
    VStack(spacing: 20) {
        UserGauntletCard(
            user: User(name: "Test User", email: "test@example.com", stones: [
                InfinityStone.allStones[0],
                InfinityStone.allStones[1],
                InfinityStone.allStones[2]
            ]),
            isCurrentUser: false
        ) {
            print("Tapped user")
        }
        
        UserGauntletCard(
            user: User(name: "Complete User", email: "complete@example.com", stones: InfinityStone.allStones),
            isCurrentUser: true
        ) {
            print("Tapped complete user")
        }
    }
    .padding()
}
