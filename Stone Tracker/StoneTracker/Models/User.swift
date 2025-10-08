import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let email: String
    let stones: [InfinityStone]
    let createdAt: Date
    
    init(name: String, email: String, stones: [InfinityStone] = []) {
        self.name = name
        self.email = email
        self.stones = stones
        self.createdAt = Date()
    }
}

struct InfinityStone: Identifiable, Codable {
    let id: String
    let name: String
    let color: String
    let power: String
    let acquiredFrom: String? // Optional field to track who the stone was acquired from
    
    static let allStones: [InfinityStone] = [
        InfinityStone(id: "power", name: "Power Stone", color: "purple", power: "Destructive Energy", acquiredFrom: nil),
        InfinityStone(id: "space", name: "Space Stone", color: "blue", power: "Spatial Manipulation", acquiredFrom: nil),
        InfinityStone(id: "reality", name: "Reality Stone", color: "red", power: "Reality Warping", acquiredFrom: nil),
        InfinityStone(id: "soul", name: "Soul Stone", color: "orange", power: "Soul Manipulation", acquiredFrom: nil),
        InfinityStone(id: "time", name: "Time Stone", color: "green", power: "Time Manipulation", acquiredFrom: nil),
        InfinityStone(id: "mind", name: "Mind Stone", color: "yellow", power: "Mental Manipulation", acquiredFrom: nil)
    ]
    
    static func getStone(by id: String) -> InfinityStone? {
        return allStones.first { $0.id == id }
    }
}
