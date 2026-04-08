import Foundation

public struct LiturgicalCelebration: Codable, Equatable, Identifiable {
    public var id: String { title + colour }
    public let title: String
    public let colour: String
    public let rank: String
    public let rankNum: Double?
    
    public init(title: String, colour: String, rank: String, rankNum: Double? = nil) {
        self.title = title
        self.colour = colour
        self.rank = rank
        self.rankNum = rankNum
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case colour
        case rank
        case rankNum = "rank_num"
    }
}

public struct LiturgicalDay: Codable, Equatable {
    public let date: String
    public let season: String
    public let seasonWeek: Int?
    public let weekday: String
    public let celebrations: [LiturgicalCelebration]
    
    public init(date: String, season: String, seasonWeek: Int? = nil, weekday: String, celebrations: [LiturgicalCelebration]) {
        self.date = date
        self.season = season
        self.seasonWeek = seasonWeek
        self.weekday = weekday
        self.celebrations = celebrations
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case season
        case seasonWeek = "season_week"
        case weekday
        case celebrations
    }
}
