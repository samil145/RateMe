import Foundation

struct Rating: Codable, Identifiable {
    let id: String
    let fromUserId: String
    let toUserId: String
    let rating: Int
    let comment: String
    let timestamp: Date
    var category: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fromUserId
        case toUserId
        case rating
        case comment
        case timestamp
        case category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        fromUserId = try container.decode(String.self, forKey: .fromUserId)
        toUserId = try container.decode(String.self, forKey: .toUserId)
        rating = try container.decode(Int.self, forKey: .rating)
        comment = try container.decode(String.self, forKey: .comment)
        category = try container.decode(String.self, forKey: .category)
        
        let dateString = try container.decode(String.self, forKey: .timestamp)
        let formatter = ISO8601DateFormatter()
        timestamp = formatter.date(from: dateString) ?? Date()
    }
    
    init(id: String, fromUserId: String, toUserId: String, rating: Int, comment: String, timestamp: Date, category: String) {
        self.id = id
        self.fromUserId = fromUserId
        self.toUserId = toUserId
        self.rating = rating
        self.comment = comment
        self.timestamp = timestamp
        self.category = category
    }
}

// MARK: - Mock Data Extension
extension Rating {
    static let mockRatings: [Rating] = [
        Rating(
            id: "1",
            fromUserId: "user1",
            toUserId: "user2",
            rating: 5,
            comment: "Great UI designer!",
            timestamp: Date().addingTimeInterval(-3600),
            category: "UI Design"
        ),
        Rating(
            id: "2",
            fromUserId: "user2",
            toUserId: "user3",
            rating: 4,
            comment: "Excellent AI engineer",
            timestamp: Date().addingTimeInterval(-7200),
            category: "AI Engineering"
        )
    ]
} 