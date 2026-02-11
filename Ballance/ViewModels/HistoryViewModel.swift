import Foundation

protocol HistoryViewModelDelegate: AnyObject {
    func didUpdateMatches()
    func didUpdateLeague()
}

final class HistoryViewModel {
    
    weak var delegate: HistoryViewModelDelegate?
    
    private let dataService = MatchDataService.shared
    
    var selectedLeagueIndex: Int = 0 {
        didSet {
            delegate?.didUpdateMatches()
            delegate?.didUpdateLeague()
        }
    }
    
    var showAllLeagues: Bool = true {
        didSet {
            delegate?.didUpdateMatches()
            delegate?.didUpdateLeague()
        }
    }
    
    var leagueNames: [String] {
        return LeagueProvider.leagueNames
    }
    
    var selectedLeagueName: String {
        return LeagueProvider.leagueName(at: selectedLeagueIndex)
    }
    
    var currentFilterTitle: String {
        return showAllLeagues ? "All Leagues" : selectedLeagueName
    }
    
    var matches: [Match] {
        let allMatches: [Match]
        if showAllLeagues {
            allMatches = dataService.getAllMatches()
        } else {
            allMatches = dataService.getMatches(forLeague: selectedLeagueName)
        }
        return allMatches.sorted { $0.date > $1.date }
    }
    
    var statistics: Statistics {
        if showAllLeagues {
            return dataService.getAllStatistics()
        }
        return dataService.getStatistics(forLeague: selectedLeagueName)
    }
    
    var matchCount: Int {
        return matches.count
    }
    
    func match(at index: Int) -> Match? {
        guard index < matches.count else { return nil }
        return matches[index]
    }
    
    func deleteMatch(at index: Int) {
        guard let match = match(at: index) else { return }
        dataService.deleteMatch(by: match.id)
        delegate?.didUpdateMatches()
    }
    
    func refreshData() {
        delegate?.didUpdateMatches()
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func getResultText(for match: Match) -> String {
        if match.homeScore > match.awayScore {
            return "Win"
        } else if match.homeScore < match.awayScore {
            return "Loss"
        } else {
            return "Draw"
        }
    }
}
