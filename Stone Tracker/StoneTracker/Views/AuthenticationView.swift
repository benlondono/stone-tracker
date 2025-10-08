import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var name = ""
    @State private var email = ""
    @State private var showingSignUp = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // App Title and Icon
            VStack(spacing: 20) {
                Image(systemName: "diamond.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.purple)
                
                Text("Infinity Stone Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Track your collection of infinity stones and see everyone's gauntlet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // Authentication Form
            VStack(spacing: 20) {
                if showingSignUp {
                    TextField("Your Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)
                    
                    TextField("Email (Optional)", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Button(action: {
                    if showingSignUp {
                        authManager.signUp(name: name.isEmpty ? "Anonymous" : name, email: email)
                    } else {
                        authManager.signInAnonymously()
                    }
                }) {
                    HStack {
                        if authManager.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        
                        Text(showingSignUp ? "Join the Hunt" : "Continue Anonymously")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(authManager.isLoading)
                
                Button(action: {
                    showingSignUp.toggle()
                }) {
                    Text(showingSignUp ? "Already have an account?" : "Want to add your name?")
                        .foregroundColor(.purple)
                }
            }
            .padding(.horizontal, 40)
            
            if let errorMessage = authManager.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            // Footer
            Text("Up to 28 users can participate")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom)
        }
        .padding()
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationManager())
}
