
import Foundation
import AuthenticationServices
import CloudKit

// Manages the user authentication state and "Sign in with Apple" flow.
@Observable
final class AuthViewModel: NSObject {
    
    // MARK: - State
    var user: User?
    var isLoading: Bool = false
    var errorMessage: String?
    
    // CloudKit user record ID
    private(set) var userRecordID: CKRecord.ID?

    override init() {
        super.init()
        Task {
            await self.checkCurrentUserState()
        }
    }

    // Check for existing iCloud user credentials.
    @MainActor
    func checkCurrentUserState() async {
        isLoading = true
        do {
            let recordID = try await CKContainer.default().userRecordID()
            self.userRecordID = recordID
            
            // Here you would typically fetch a "User" profile record from your DB
            // For simplicity, we'll create a placeholder user object
            self.user = User(record: CKRecord(recordType: "User", recordID: recordID))
            print("User is signed in with iCloud: \(recordID.recordName)")
            
        } catch {
            self.user = nil
            self.userRecordID = nil
            self.errorMessage = "Not signed in. Please sign in with your Apple ID."
            print("User is not signed in to iCloud.")
        }
        isLoading = false
    }

    // Handles the result of the "Sign in with Apple" request.
    @MainActor
    func handleSignInResult(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                errorMessage = "Received invalid credentials."
                return
            }
            
            let newUser = User(credentials: appleIDCredential)
            self.user = newUser
            
            // Here you would save or update the user's details in your CloudKit database
            print("Successfully signed in with Apple. User: \(newUser.id)")
            Task {
                await checkCurrentUserState() // Re-verify with CloudKit
            }
            
        case .failure(let error):
            errorMessage = "Sign in with Apple failed: \(error.localizedDescription)"
        }
    }
    
    @MainActor
    func signOut() {
        self.user = nil
        self.userRecordID = nil
        // You can't programmatically sign a user out of iCloud,
        // but you can clear your app's local state.
        print("User signed out from the app.")
    }
}
