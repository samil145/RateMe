import Foundation

struct AppNotification: Codable, Identifiable {
    let id: String
    let type: NotificationType
    let message: String
    let timestamp: Date
    let isRead: Bool
    
    enum NotificationType: String, Codable {
        case newRating
        case newComment
        case newFollower
        case profileUpdate
        case milestone
        case leaderboardRank
        case followerActivity
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case message
        case timestamp
        case isRead
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(NotificationType.self, forKey: .type)
        message = try container.decode(String.self, forKey: .message)
        isRead = try container.decode(Bool.self, forKey: .isRead)
        
        let dateString = try container.decode(String.self, forKey: .timestamp)
        let formatter = ISO8601DateFormatter()
        timestamp = formatter.date(from: dateString) ?? Date()
    }
    
    init(id: String, type: NotificationType, message: String, timestamp: Date, isRead: Bool = false) {
        self.id = id
        self.type = type
        self.message = message
        self.timestamp = timestamp
        self.isRead = isRead
    }
}

// MARK: - Mock Data Extension
extension AppNotification {
    static let mockNotifications: [AppNotification] = [
        AppNotification(
            id: "1",
            type: .newRating,
            message: "John Doe rated you 5 stars",
            timestamp: Date().addingTimeInterval(-3600) // 1 hour ago
        ),
        AppNotification(
            id: "2",
            type: .newComment,
            message: "Jane Smith commented on your profile",
            timestamp: Date().addingTimeInterval(-7200) // 2 hours ago
        ),
        AppNotification(
            id: "3",
            type: .newFollower,
            message: "Mike Johnson started following you",
            timestamp: Date().addingTimeInterval(-86400) // 1 day ago
        ),
        AppNotification(
            id: "4",
            type: .profileUpdate,
            message: "Your profile was featured in the weekly spotlight",
            timestamp: Date().addingTimeInterval(-172800) // 2 days ago
        ),
        AppNotification(
            id: "5",
            type: .milestone,
            message: "Congratulations! You've reached 100 followers",
            timestamp: Date().addingTimeInterval(-259200) // 3 days ago
        ),
        AppNotification(
            id: "6",
            type: .leaderboardRank,
            message: "You're now #1 in the Design category",
            timestamp: Date().addingTimeInterval(-345600) // 4 days ago
        ),
        AppNotification(
            id: "7",
            type: .followerActivity,
            message: "Sarah Wilson shared your profile",
            timestamp: Date().addingTimeInterval(-432000) // 5 days ago
        )
    ]
} 