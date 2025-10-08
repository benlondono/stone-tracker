import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        if let firebaseUser = auth.currentUser {
            fetchUserData(userId: firebaseUser.uid)
        } else {
            isAuthenticated = false
            currentUser = nil
        }
    }
    
    func signInAnonymously() {
        isLoading = true
        errorMessage = nil
        
        auth.signInAnonymously { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                if let firebaseUser = result?.user {
                    self?.fetchUserData(userId: firebaseUser.uid)
                }
            }
        }
    }
    
    func signUp(name: String, email: String) {
        isLoading = true
        errorMessage = nil
        
        auth.signInAnonymously { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                if let firebaseUser = result?.user {
                    let newUser = User(name: name, email: email)
                    self?.createUserInFirestore(user: newUser, userId: firebaseUser.uid)
                }
            }
        }
    }
    
    private func createUserInFirestore(user: User, userId: String) {
        let userData: [String: Any] = [
            "name": user.name,
            "email": user.email,
            "stones": [],
            "createdAt": Timestamp(date: user.createdAt)
        ]
        
        db.collection("users").document(userId).setData(userData) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                self?.fetchUserData(userId: userId)
            }
        }
    }
    
    private func fetchUserData(userId: String) {
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let document = document, document.exists else {
                    self?.errorMessage = "User data not found"
                    return
                }
                
                do {
                    var user = try document.data(as: User.self)
                    user.id = userId
                    self?.currentUser = user
                    self?.isAuthenticated = true
                } catch {
                    self?.errorMessage = "Failed to parse user data"
                }
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
            isAuthenticated = false
            currentUser = nil
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updateUser(_ updatedUser: User) {
        guard let userId = auth.currentUser?.uid else { return }
        
        let userData: [String: Any] = [
            "name": updatedUser.name,
            "email": updatedUser.email,
            "stones": updatedUser.stones.map { stone in
                [
                    "id": stone.id,
                    "name": stone.name,
                    "color": stone.color,
                    "power": stone.power,
                    "acquiredFrom": stone.acquiredFrom as Any
                ]
            },
            "createdAt": Timestamp(date: updatedUser.createdAt)
        ]
        
        db.collection("users").document(userId).setData(userData) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                self?.currentUser = updatedUser
            }
        }
    }
}
