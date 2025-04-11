import Foundation

struct Leaderboard: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let category: String
    let rank: Int
    let topUsers: [String]
    let lastUpdated: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case category
        case rank
        case topUsers
        case lastUpdated
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(String.self, forKey: .category)
        rank = try container.decode(Int.self, forKey: .rank)
        topUsers = try container.decode([String].self, forKey: .topUsers)
        
        let dateString = try container.decode(String.self, forKey: .lastUpdated)
        let formatter = ISO8601DateFormatter()
        lastUpdated = formatter.date(from: dateString) ?? Date()
    }
    
    init(id: String, title: String, description: String, category: String, rank: Int, topUsers: [String], lastUpdated: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.rank = rank
        self.topUsers = topUsers
        self.lastUpdated = lastUpdated
    }
}

// MARK: - Mock Data Extension
extension Leaderboard {
    static let mockLeaderboards: [Leaderboard] = [
        Leaderboard(
            id: "1",
            title: "Top UI Designers",
            description: "Leading designers in the industry",
            category: "Design",
            rank: 1,
            topUsers: ["Alice Johnson", "David Kim"],
            lastUpdated: Date().addingTimeInterval(-3600)
        ),
        Leaderboard(
            id: "2",
            title: "Best AI Engineers",
            description: "Top performing AI specialists",
            category: "Engineering",
            rank: 2,
            topUsers: ["Michael Lee", "Sophia Carter"],
            lastUpdated: Date().addingTimeInterval(-7200)
        )
    ]
} 