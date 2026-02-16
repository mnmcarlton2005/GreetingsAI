
import Foundation
import CloudKit

// Represents a user of the application.
struct User: Identifiable, Hashable {
    let id: String
    let fullName: String?
    let email: String?

    init(credentials: ASAuthorizationAppleIDCredential) {
        self.id = credentials.user
        self.fullName = [credentials.fullName?.givenName, credentials.fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: " ")
        self.email = credentials.email
    }
    
    init(record: CKRecord) {
        self.id = record.recordID.recordName
        self.fullName = record["fullName"] as? String
        self.email = record["email"] as? String
    }
}
