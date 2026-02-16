import XCTest
@testable import Models

final class GreetingsAITests: XCTestCase {
    func testUserInit() {
        let user = User(id: "u1", name: "Alice")
        XCTAssertEqual(user.id, "u1")
        XCTAssertEqual(user.name, "Alice")
    }

    func testOccasionAndCard() {
        let occasion = Occasion(id: "o1", title: "Birthday")
        XCTAssertEqual(occasion.title, "Birthday")

        let card = Card(id: "c1", occasionId: occasion.id, message: "Happy Birthday")
        XCTAssertEqual(card.message, "Happy Birthday")
        XCTAssertEqual(card.occasionId, occasion.id)
    }
}
