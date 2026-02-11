import Foundation

protocol TrackerViewModelDelegate: AnyObject {
    func didUpdateStatistics()
    func didSaveMatch()
    func didUpdateTeams()
}

final class TrackerViewModel {
    
    weak var delegate: TrackerViewModelDelegate?
    
    private let dataService = MatchDataService.shared
    
    var selectedLeagueIndex: Int = 0 {
        didSet {
            selectedHomeTeamIndex = 0
            selectedAwayTeamIndex = 1
            delegate?.didUpdateTeams()
            delegate?.didUpdateStatistics()
        }
    }
    var selectedHomeTeamIndex: Int = 0
    var selectedAwayTeamIndex: Int = 1
    var homeScore: Int = 0
    var awayScore: Int = 0
    
    var leagueNames: [String] {
        return LeagueProvider.leagueNames
    }
    
    var currentTeams: [String] {
        return LeagueProvider.teams(for: selectedLeagueIndex)
    }
    
    var selectedLeagueName: String {
        return LeagueProvider.leagueName(at: selectedLeagueIndex)
    }
    
    var homeTeamName: String {
        let teams = currentTeams
        guard selectedHomeTeamIndex < teams.count else { return "" }
        return teams[selectedHomeTeamIndex]
    }
    
    var awayTeamName: String {
        let teams = currentTeams
        guard selectedAwayTeamIndex < teams.count else { return "" }
        return teams[selectedAwayTeamIndex]
    }
    
    var statistics: Statistics {
        return dataService.getStatistics(forLeague: selectedLeagueName)
    }
    
    func incrementHomeScore() {
        homeScore += 1
    }
    
    func decrementHomeScore() {
        guard homeScore > 0 else { return }
        homeScore -= 1
    }
    
    func incrementAwayScore() {
        awayScore += 1
    }
    
    func decrementAwayScore() {
        guard awayScore > 0 else { return }
        awayScore -= 1
    }
    
    func saveMatch() {
        guard homeTeamName != awayTeamName else { return }
        
        let match = Match(
            homeTeam: homeTeamName,
            awayTeam: awayTeamName,
            homeScore: homeScore,
            awayScore: awayScore,
            league: selectedLeagueName,
            isSimulated: false
        )
        
        dataService.saveMatch(match)
        resetForm()
        delegate?.didSaveMatch()
        delegate?.didUpdateStatistics()
    }
    
    func resetForm() {
        homeScore = 0
        awayScore = 0
    }
}
