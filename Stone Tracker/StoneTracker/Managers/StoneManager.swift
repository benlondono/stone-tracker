import Foundation
import FirebaseFirestore
import SwiftUI

class StoneManager: ObservableObject {
    @Published var allUsers: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        startListeningForUsers()
    }
    
    deinit {
        listener?.remove()
    }
    
    private func startListeningForUsers() {
        isLoading = true
        
        listener = db.collection("users")
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        self?.allUsers = []
                        return
                    }
                    
                    do {
                        let users = try documents.compactMap { document -> User? in
                            var user = try document.data(as: User.self)
                            user.id = document.documentID
                            return user
                        }
                        self?.allUsers = users
                        self?.errorMessage = nil
                    } catch {
                        self?.errorMessage = "Failed to parse user data"
                        self?.allUsers = []
                    }
                }
            }
    }
    
    func addStone(_ stone: InfinityStone, to user: User) {
        var updatedStones = user.stones
        
        // Check if user already has this stone
        if updatedStones.contains(where: { $0.id == stone.id }) {
            errorMessage = "User already has this stone"
            return
        }
        
        // Allow multiple users to have the same stone - no exclusivity
        updatedStones.append(stone)
        let updatedUser = User(
            name: user.name,
            email: user.email,
            stones: updatedStones
        )
        
        updateUserInFirestore(updatedUser)
    }
    
    func removeStone(_ stone: InfinityStone, from user: User) {
        let updatedStones = user.stones.filter { $0.id != stone.id }
        let updatedUser = User(
            name: user.name,
            email: user.email,
            stones: updatedStones
        )
        
        updateUserInFirestore(updatedUser)
    }
    
    
    func getAvailableStones(for user: User) -> [InfinityStone] {
        let ownedStoneIds = Set(user.stones.map { $0.id })
        
        // Return all stones that the user doesn't already have
        // Since stones are no longer exclusive, any user can get any stone
        return InfinityStone.allStones.filter { stone in
            !ownedStoneIds.contains(stone.id)
        }
    }
    
    func getUsersWithCompleteGauntlet() -> [User] {
        return allUsers.filter { $0.stones.count == 6 }
    }
    
    func updateUserInFirestore(_ user: User) {
        guard let userId = user.id else {
            errorMessage = "User ID not found"
            return
        }
        
        let userData: [String: Any] = [
            "name": user.name,
            "email": user.email,
            "stones": user.stones.map { stone in
                [
                    "id": stone.id,
                    "name": stone.name,
                    "color": stone.color,
                    "power": stone.power,
                    "acquiredFrom": stone.acquiredFrom as Any
                ]
            },
            "createdAt": Timestamp(date: user.createdAt)
        ]
        
        db.collection("users").document(userId).setData(userData) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
