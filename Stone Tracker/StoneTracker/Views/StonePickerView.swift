import SwiftUI

struct StonePickerView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var stoneManager: StoneManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedStone: InfinityStone?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let user = authManager.currentUser {
                        let availableStones = stoneManager.getAvailableStones(for: user)
                        
                        if availableStones.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "diamond")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                
                                Text("Collection Complete!")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("You have collected all infinity stones! You are now the most powerful being in the universe!")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 60)
                        } else {
                            Text("Choose a Stone")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                                ForEach(availableStones) { stone in
                                    StoneCard(stone: stone, isOwned: false) {
                                        selectedStone = stone
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Add Stone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(item: $selectedStone) { stone in
                StoneSelectionView(
                    stone: stone,
                    onAdd: { stoneWithAcquiredFrom in
                        if let user = authManager.currentUser {
                            stoneManager.addStone(stoneWithAcquiredFrom, to: user)
                        }
                        dismiss()
                    },
                    onCancel: {
                        selectedStone = nil
                    }
                )
            }
        }
    }
}

#Preview {
    StonePickerView()
        .environmentObject(AuthenticationManager())
        .environmentObject(StoneManager())
}
