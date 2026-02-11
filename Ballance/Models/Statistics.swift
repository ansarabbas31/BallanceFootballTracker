import Foundation

struct Statistics {
    var totalMatches: Int
    var wins: Int
    var losses: Int
    var draws: Int
    var totalGoalsScored: Int
    var totalGoalsConceded: Int
    var simulatedMatches: Int
    
    var winRate: Double {
        guard totalMatches > 0 else { return 0 }
        return Double(wins) / Double(totalMatches) * 100
    }
    
    var averageGoalsScored: Double {
        guard totalMatches > 0 else { return 0 }
        return Double(totalGoalsScored) / Double(totalMatches)
    }
    
    init() {
        self.totalMatches = 0
        self.wins = 0
        self.losses = 0
        self.draws = 0
        self.totalGoalsScored = 0
        self.totalGoalsConceded = 0
        self.simulatedMatches = 0
    }
}

struct TeamStats: Codable {
    let teamName: String
    var matchesPlayed: Int
    var wins: Int
    var losses: Int
    var draws: Int
    var goalsScored: Int
    var goalsConceded: Int
    
    var points: Int {
        return wins * 3 + draws
    }
    
    var goalDifference: Int {
        return goalsScored - goalsConceded
    }
}
