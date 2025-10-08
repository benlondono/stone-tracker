import SwiftUI

struct StoneSelectionView: View {
    let stone: InfinityStone
    let onAdd: (InfinityStone) -> Void
    let onCancel: () -> Void
    
    @State private var acquiredFrom: String = ""
    @State private var showingAcquiredFromField = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // Stone Preview
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(getStoneColor(stone.color).opacity(0.2))
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .stroke(getStoneColor(stone.color), lineWidth: 4)
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "diamond.fill")
                            .font(.system(size: 50))
                            .foregroundColor(getStoneColor(stone.color))
                    }
                    
                    VStack(spacing: 8) {
                        Text(stone.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(stone.power)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
                
                // Acquired From Section
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Acquired From (Optional)")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAcquiredFromField.toggle()
                            if !showingAcquiredFromField {
                                acquiredFrom = ""
                            }
                        }) {
                            Text(showingAcquiredFromField ? "Hide" : "Add")
                                .foregroundColor(.purple)
                        }
                    }
                    
                    if showingAcquiredFromField {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Who did you get this stone from?")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            TextField("Enter name (optional)", text: $acquiredFrom)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .autocapitalization(.words)
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        let stoneWithAcquiredFrom = InfinityStone(
                            id: stone.id,
                            name: stone.name,
                            color: stone.color,
                            power: stone.power,
                            acquiredFrom: acquiredFrom.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : acquiredFrom.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        onAdd(stoneWithAcquiredFrom)
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add to My Collection")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(12)
                    }
                    
                    Button(action: onCancel) {
                        Text("Cancel")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Stone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        onCancel()
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
    StoneSelectionView(
        stone: InfinityStone.allStones[0],
        onAdd: { _ in },
        onCancel: { }
    )
}
