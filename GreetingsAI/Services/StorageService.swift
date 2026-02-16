
import Foundation
import CloudKit

// Manages data persistence using CloudKit.
@Observable
final class StorageService {
    
    private let container: CKContainer
    private let publicDB: CKDatabase
    
    enum StorageError: Error, LocalizedError {
        case recordCreationFailed
        case recordFetchFailed(Error)
        case recordUpdateFailed(Error)
        case recordDeletionFailed(Error)
        case userNotAuthenticated
        
        var errorDescription: String? {
            switch self {
            case .recordCreationFailed: return "Failed to create the new record in the database."
            case .recordFetchFailed: return "Failed to fetch records from the database."
            case .recordUpdateFailed: return "Failed to update the record in the database."
            case .recordDeletionFailed: return "Failed to delete the record from the database."
            case .userNotAuthenticated: return "User is not authenticated with iCloud."
            }
        }
    }

    init() {
        self.container = CKContainer.default()
        self.publicDB = container.publicCloudDatabase
    }

    // Fetches all cards for a given user ID.
    func fetchCards(for userId: String) async throws -> [Card] {
        let predicate = NSPredicate(format: "userId == %@", userId)
        let query = CKQuery(recordType: "Card", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            let (results, _) = try await publicDB.records(matching: query)
            let cards = results.compactMap { _, result in
                switch result {
                case .success(let record):
                    // This is a simplified conversion. A real app would have robust mapping.
                    return Card(
                        id: record.recordID.recordName,
                        userId: record["userId"] as? String ?? "",
                        occasion: Occasion(rawValue: record["occasion"] as? String ?? "generic") ?? .generic,
                        message: record["message"] as? String ?? "",
                        imageUrl: record["imageUrl"] as? String ?? "",
                        textOverlays: [], // Needs proper decoding
                        createdAt: record["createdAt"] as? Date ?? Date()
                    )
                case .failure:
                    return nil
                }
            }
            return cards
        } catch {
            throw StorageError.recordFetchFailed(error)
        }
    }

    // Saves a new card to CloudKit.
    func saveCard(_ card: Card) async throws {
        let record = CKRecord(recordType: "Card")
        record["userId"] = card.userId
        record["occasion"] = card.occasion.rawValue
        record["message"] = card.message
        record["imageUrl"] = card.imageUrl
        record["createdAt"] = card.createdAt
        // Saving textOverlays would require serializing them (e.g., to JSON).
        
        do {
            try await publicDB.save(record)
        } catch {
            throw StorageError.recordCreationFailed
        }
    }

    // Deletes a card from CloudKit.
    func deleteCard(cardId: String) async throws {
        let recordID = CKRecord.ID(recordName: cardId)
        do {
            try await publicDB.deleteRecord(withID: recordID)
        } catch {
            throw StorageError.recordDeletionFailed(error)
        }
    }
}
