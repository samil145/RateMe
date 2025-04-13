import Foundation

struct Profile: Codable, Identifiable {
    let id: String
    let name: String
    let profession: String
    let bio: String
    let skills: [String]
    let rating: Double
    let totalRatings: Int
    let profileImageURL: String?
    let location: String
    let joinedDate: Date
    let socialLinks: SocialLinks
    
    struct SocialLinks: Codable {
        let linkedin: String?
        let instagram: String?
        let youtube: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profession
        case bio
        case skills
        case rating
        case totalRatings
        case profileImageURL
        case location
        case joinedDate
        case socialLinks
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        profession = try container.decode(String.self, forKey: .profession)
        bio = try container.decode(String.self, forKey: .bio)
        skills = try container.decode([String].self, forKey: .skills)
        rating = try container.decode(Double.self, forKey: .rating)
        totalRatings = try container.decode(Int.self, forKey: .totalRatings)
        profileImageURL = try container.decodeIfPresent(String.self, forKey: .profileImageURL)
        location = try container.decode(String.self, forKey: .location)
        socialLinks = try container.decode(SocialLinks.self, forKey: .socialLinks)
        
        let dateString = try container.decode(String.self, forKey: .joinedDate)
        let formatter = ISO8601DateFormatter()
        joinedDate = formatter.date(from: dateString) ?? Date()
    }
    
    init(id: String, name: String, profession: String, bio: String, skills: [String], rating: Double, totalRatings: Int, profileImageURL: String? = nil, location: String, joinedDate: Date, socialLinks: SocialLinks) {
        self.id = id
        self.name = name
        self.profession = profession
        self.bio = bio
        self.skills = skills
        self.rating = rating
        self.totalRatings = totalRatings
        self.profileImageURL = profileImageURL
        self.location = location
        self.joinedDate = joinedDate
        self.socialLinks = socialLinks
    }
}

// MARK: - Mock Data Extension
extension Profile {
    static let mockProfiles: [Profile] = [
        Profile(
            id: "1",
            name: "Alice Johnson",
            profession: "Senior Software Engineer",
            bio: "Senior Software Engineer with 8 years of experience in iOS development. Passionate about creating beautiful and intuitive user interfaces.",
            skills: ["iOS Development", "Swift", "UIKit", "SwiftUI", "Core Data"],
            rating: 4.8,
            totalRatings: 24,
            profileImageURL: "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmVzc2lvbmFsJTIwd29tYW58ZW58MHx8MHx8fDA%3D",
            location: "San Francisco, CA",
            joinedDate: Date().addingTimeInterval(-86400 * 365), // 1 il
            socialLinks: SocialLinks(
                linkedin: "https://linkedin.com/in/alicejohnson",
                instagram: "https://instagram.com/alice_design",
                youtube: nil
            )
        ),
        Profile(
            id: "2",
            name: "Michael Lee",
            profession: "Product Designer",
            bio: "Product Designer with a focus on user experience and accessibility. Specialized in creating inclusive designs that work for everyone.",
            skills: ["UI/UX Design", "Figma", "Sketch", "Accessibility", "User Research"],
            rating: 4.9,
            totalRatings: 32,
            profileImageURL: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmVzc2lvbmFsJTIwbWFufGVufDB8fDB8fHww",
            location: "New York, NY",
            joinedDate: Date().addingTimeInterval(-86400 * 180), // 6 ay
            socialLinks: SocialLinks(
                linkedin: "https://linkedin.com/in/michaellee",
                instagram: nil,
                youtube: "https://youtube.com/michael_ai"
            )
        )
    ]
} 
