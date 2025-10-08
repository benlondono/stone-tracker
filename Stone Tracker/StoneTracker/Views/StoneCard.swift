import SwiftUI

struct StoneCard: View {
    let stone: InfinityStone
    let isOwned: Bool
    let action: () -> Void
    
    private var stoneColor: Color {
        switch stone.color {
        case "purple": return .purple
        case "blue": return .blue
        case "red": return .red
        case "orange": return .orange
        case "green": return .green
        case "yellow": return .yellow
        default: return .gray
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Stone Icon
                ZStack {
                    Circle()
                        .fill(stoneColor.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .stroke(stoneColor, lineWidth: 2)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "diamond.fill")
                        .font(.title2)
                        .foregroundColor(stoneColor)
                }
                
                // Stone Name
                Text(stone.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                // Stone Power
                Text(stone.power)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                // Acquired From (if available)
                if let acquiredFrom = stone.acquiredFrom, !acquiredFrom.isEmpty {
                    VStack(spacing: 2) {
                        Text("From:")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Text(acquiredFrom)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(stoneColor)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(stoneColor.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Action Button
                HStack {
                    Image(systemName: isOwned ? "minus.circle.fill" : "plus.circle.fill")
                    Text(isOwned ? "Remove" : "Add")
                }
                .font(.caption)
                .foregroundColor(isOwned ? .red : stoneColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    (isOwned ? Color.red : stoneColor).opacity(0.1)
                )
                .cornerRadius(12)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(color: stoneColor.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        StoneCard(stone: InfinityStone.allStones[0], isOwned: true) {
            print("Remove stone")
        }
        
        StoneCard(stone: InfinityStone.allStones[1], isOwned: false) {
            print("Add stone")
        }
    }
    .padding()
}
