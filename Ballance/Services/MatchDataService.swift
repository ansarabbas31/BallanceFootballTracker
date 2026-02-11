import Foundation

final class MatchDataService {
    
    static let shared = MatchDataService()
    
    private let defaults = UserDefaults.standard
    private let matchesKey = "saved_matches_key"
    
    private init() {}
    
    func saveMatch(_ match: Match) {
        var matches = getAllMatches()
        matches.append(match)
        saveMatches(matches)
    }
    
    func getAllMatches() -> [Match] {
        guard let data = defaults.data(forKey: matchesKey) else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Match].self, from: data)) ?? []
    }
    
    func getMatches(forLeague league: String) -> [Match] {
        return getAllMatches().filter { $0.league == league }
    }
    
    func deleteMatch(by id: UUID) {
        var matches = getAllMatches()
        matches.removeAll { $0.id == id }
        saveMatches(matches)
    }
    
    func getStatistics(forLeague league: String) -> Statistics {
        let matches = getMatches(forLeague: league)
        return buildStatistics(from: matches)
    }
    
    func getAllStatistics() -> Statistics {
        let matches = getAllMatches()
        return buildStatistics(from: matches)
    }
    
    private func buildStatistics(from matches: [Match]) -> Statistics {
        var stats = Statistics()
        
        stats.totalMatches = matches.count
        stats.simulatedMatches = matches.filter { $0.isSimulated }.count
        
        for match in matches {
            stats.totalGoalsScored += match.homeScore
            stats.totalGoalsConceded += match.awayScore
            
            if match.homeScore > match.awayScore {
                stats.wins += 1
            } else if match.homeScore < match.awayScore {
                stats.losses += 1
            } else {
                stats.draws += 1
            }
        }
        
        return stats
    }
    
    private func saveMatches(_ matches: [Match]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(matches) {
            defaults.set(data, forKey: matchesKey)
        }
    }
}
