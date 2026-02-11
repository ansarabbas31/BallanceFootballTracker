import Foundation

struct Match: Codable, Identifiable {
    let id: UUID
    var homeTeam: String
    var awayTeam: String
    var homeScore: Int
    var awayScore: Int
    var date: Date
    var league: String
    var duration: Int
    var isSimulated: Bool
    
    init(id: UUID = UUID(), homeTeam: String, awayTeam: String, homeScore: Int, awayScore: Int, date: Date = Date(), league: String, duration: Int = 90, isSimulated: Bool = false) {
        self.id = id
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.date = date
        self.league = league
        self.duration = duration
        self.isSimulated = isSimulated
    }
}

struct FootballLeague {
    let name: String
    let teams: [String]
}

struct LeagueProvider {
    
    static let leagues: [FootballLeague] = [
        FootballLeague(name: "Premier League", teams: [
            "Arsenal",
            "Aston Villa",
            "Bournemouth",
            "Brentford",
            "Brighton",
            "Chelsea",
            "Crystal Palace",
            "Everton",
            "Fulham",
            "Ipswich Town",
            "Leicester City",
            "Liverpool",
            "Manchester City",
            "Manchester United",
            "Newcastle United",
            "Nottingham Forest",
            "Southampton",
            "Tottenham Hotspur",
            "West Ham United",
            "Wolverhampton"
        ]),
        FootballLeague(name: "La Liga", teams: [
            "Athletic Bilbao",
            "Atletico Madrid",
            "Barcelona",
            "Celta Vigo",
            "Espanyol",
            "Getafe",
            "Girona",
            "Las Palmas",
            "Leganes",
            "Mallorca",
            "Osasuna",
            "Rayo Vallecano",
            "Real Betis",
            "Real Madrid",
            "Real Sociedad",
            "Real Valladolid",
            "Sevilla",
            "Valencia",
            "Villarreal"
        ]),
        FootballLeague(name: "Bundesliga", teams: [
            "Augsburg",
            "Bayer Leverkusen",
            "Bayern Munich",
            "Borussia Dortmund",
            "Borussia Monchengladbach",
            "Eintracht Frankfurt",
            "Freiburg",
            "Heidenheim",
            "Hoffenheim",
            "Holstein Kiel",
            "Mainz 05",
            "RB Leipzig",
            "St. Pauli",
            "Stuttgart",
            "Union Berlin",
            "Werder Bremen",
            "Wolfsburg"
        ]),
        FootballLeague(name: "Serie A", teams: [
            "AC Milan",
            "Atalanta",
            "Bologna",
            "Cagliari",
            "Como",
            "Empoli",
            "Fiorentina",
            "Genoa",
            "Hellas Verona",
            "Inter Milan",
            "Juventus",
            "Lazio",
            "Lecce",
            "Monza",
            "Napoli",
            "Parma",
            "Roma",
            "Torino",
            "Udinese",
            "Venezia"
        ]),
        FootballLeague(name: "Ligue 1", teams: [
            "Angers",
            "Auxerre",
            "Brest",
            "Le Havre",
            "Lens",
            "Lille",
            "Lyon",
            "Marseille",
            "Monaco",
            "Montpellier",
            "Nantes",
            "Nice",
            "Paris Saint-Germain",
            "Reims",
            "Rennes",
            "Saint-Etienne",
            "Strasbourg",
            "Toulouse"
        ]),
        FootballLeague(name: "Champions League", teams: [
            "Arsenal",
            "Atletico Madrid",
            "Barcelona",
            "Bayern Munich",
            "Benfica",
            "Borussia Dortmund",
            "Celtic",
            "Club Brugge",
            "Feyenoord",
            "Inter Milan",
            "Juventus",
            "Lille",
            "Liverpool",
            "Manchester City",
            "Monaco",
            "Paris Saint-Germain",
            "PSV",
            "Real Madrid",
            "Red Bull Salzburg",
            "Sporting CP"
        ])
    ]
    
    static var leagueNames: [String] {
        return leagues.map { $0.name }
    }
    
    static func teams(for leagueIndex: Int) -> [String] {
        guard leagueIndex < leagues.count else { return [] }
        return leagues[leagueIndex].teams
    }
    
    static func leagueName(at index: Int) -> String {
        guard index < leagues.count else { return "" }
        return leagues[index].name
    }
}
