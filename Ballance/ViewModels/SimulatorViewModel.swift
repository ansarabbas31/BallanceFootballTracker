import Foundation

protocol SimulatorViewModelDelegate: AnyObject {
    func didStartSimulation()
    func didUpdateMatch(home: Int, away: Int, minute: Int, event: MatchEvent)
    func didFinishSimulation(match: Match)
    func didUpdateTeams()
}

final class SimulatorViewModel {
    
    weak var delegate: SimulatorViewModelDelegate?
    
    private let dataService = MatchDataService.shared
    private var simulationTimer: Timer?
    private var currentMinute: Int = 0
    private var pendingGoal: Bool = false
    private var pendingGoalIsHome: Bool = false
    private var shotSequenceStep: Int = 0
    
    var selectedLeagueIndex: Int = 0 {
        didSet {
            selectedHomeTeamIndex = 0
            selectedAwayTeamIndex = 1
            delegate?.didUpdateTeams()
        }
    }
    var selectedHomeTeamIndex: Int = 0
    var selectedAwayTeamIndex: Int = 1
    var homeScore: Int = 0
    var awayScore: Int = 0
    var isSimulating: Bool = false
    
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
    
    func startSimulation() {
        guard homeTeamName != awayTeamName else { return }
        
        resetSimulation()
        isSimulating = true
        delegate?.didStartSimulation()
        
        delegate?.didUpdateMatch(home: 0, away: 0, minute: 0, event: .kickoff)
        
        simulationTimer = Timer.scheduledTimer(withTimeInterval: 0.12, repeats: true) { [weak self] _ in
            self?.simulateMinute()
        }
    }
    
    func stopSimulation() {
        simulationTimer?.invalidate()
        simulationTimer = nil
        isSimulating = false
        saveSimulatedMatch()
    }
    
    private func simulateMinute() {
        currentMinute += 1
        
        if shotSequenceStep > 0 {
            handleShotSequence()
            return
        }
        
        let event = generateEvent()
        
        delegate?.didUpdateMatch(home: homeScore, away: awayScore, minute: currentMinute, event: event)
        
        if currentMinute >= 90 {
            stopSimulation()
        }
    }
    
    private func generateEvent() -> MatchEvent {
        let roll = Double.random(in: 0...1)
        let isHome = Bool.random()
        
        if roll < 0.025 {
            pendingGoal = true
            pendingGoalIsHome = isHome
            shotSequenceStep = 1
            return .passing(isHome: isHome)
        }
        
        if roll < 0.05 {
            shotSequenceStep = 0
            let shotHome = Bool.random()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) { [weak self] in
                guard let self = self, self.isSimulating else { return }
                let saveOrMiss = Double.random(in: 0...1)
                if saveOrMiss < 0.6 {
                    self.delegate?.didUpdateMatch(home: self.homeScore, away: self.awayScore, minute: self.currentMinute, event: .save(isHome: shotHome))
                }
            }
            
            return .shot(isHome: shotHome)
        }
        
        if roll < 0.08 {
            return .foul(isHome: isHome)
        }
        
        if roll < 0.1 {
            return .corner(isHome: isHome)
        }
        
        if roll < 0.12 {
            return .offside(isHome: isHome)
        }
        
        if roll < 0.55 {
            return .passing(isHome: isHome)
        }
        
        return .idle
    }
    
    private func handleShotSequence() {
        switch shotSequenceStep {
        case 1:
            delegate?.didUpdateMatch(home: homeScore, away: awayScore, minute: currentMinute, event: .shot(isHome: pendingGoalIsHome))
            shotSequenceStep = 2
        case 2:
            if pendingGoalIsHome {
                homeScore += 1
            } else {
                awayScore += 1
            }
            delegate?.didUpdateMatch(home: homeScore, away: awayScore, minute: currentMinute, event: .goal(isHome: pendingGoalIsHome))
            shotSequenceStep = 3
        default:
            shotSequenceStep = 0
            pendingGoal = false
            delegate?.didUpdateMatch(home: homeScore, away: awayScore, minute: currentMinute, event: .kickoff)
        }
        
        if currentMinute >= 90 && shotSequenceStep == 0 {
            stopSimulation()
        }
    }
    
    private func saveSimulatedMatch() {
        let match = Match(
            homeTeam: homeTeamName,
            awayTeam: awayTeamName,
            homeScore: homeScore,
            awayScore: awayScore,
            league: selectedLeagueName,
            isSimulated: true
        )
        
        dataService.saveMatch(match)
        delegate?.didFinishSimulation(match: match)
    }
    
    private func resetSimulation() {
        homeScore = 0
        awayScore = 0
        currentMinute = 0
        shotSequenceStep = 0
        pendingGoal = false
    }
}
