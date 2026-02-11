import UIKit

final class SimulatorViewController: UIViewController {
    
    private let viewModel = SimulatorViewModel()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 20, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private let scoreboardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.15, alpha: 1.0)
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let homeTeamLabel: UILabel = {
        let label = UILabel()
        label.text = "Home"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let awayTeamLabel: UILabel = {
        let label = UILabel()
        label.text = "Away"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let homeScoreLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .monospacedDigitSystemFont(ofSize: 44, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    private let awayScoreLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .monospacedDigitSystemFont(ofSize: 44, weight: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)
        return label
    }()
    
    private let separatorLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let minuteLabel: UILabel = {
        let label = UILabel()
        label.text = "0'"
        label.font = .monospacedDigitSystemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.3, green: 0.9, blue: 0.4, alpha: 1.0)
        return label
    }()
    
    private let fieldView: FootballFieldView = {
        let field = FootballFieldView()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let eventLogView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let eventLogStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let eventLogTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Match Events"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var eventLabels: [UILabel] = []
    private let maxEvents = 5
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.progressTintColor = UIColor(red: 0.3, green: 0.9, blue: 0.4, alpha: 1.0)
        progress.trackTintColor = UIColor.white.withAlphaComponent(0.15)
        progress.progress = 0
        progress.isHidden = true
        return progress
    }()
    
    private lazy var leagueButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Premier League"
        config.baseForegroundColor = .tintColor
        config.baseBackgroundColor = .systemGray6
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            return outgoing
        }
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        button.layer.cornerRadius = 10
        button.showsMenuAsPrimaryAction = true
        button.menu = createLeagueMenu()
        return button
    }()
    
    private lazy var homeTeamButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Arsenal"
        config.baseForegroundColor = .tintColor
        config.baseBackgroundColor = .systemGray6
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            return outgoing
        }
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        button.layer.cornerRadius = 10
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private lazy var awayTeamButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Aston Villa"
        config.baseForegroundColor = .tintColor
        config.baseBackgroundColor = .systemGray6
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            return outgoing
        }
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        button.layer.cornerRadius = 10
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private lazy var simulateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Simulation", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(simulateTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
        updateTeamMenus()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setupUI() {
        title = "Match Simulator"
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        setupScoreboard()
        setupEventLog()
        
        contentStack.addArrangedSubview(scoreboardView)
        contentStack.addArrangedSubview(fieldView)
        contentStack.addArrangedSubview(eventLogView)
        contentStack.addArrangedSubview(createSectionLabel("League"))
        contentStack.addArrangedSubview(leagueButton)
        contentStack.addArrangedSubview(createSectionLabel("Home Team"))
        contentStack.addArrangedSubview(homeTeamButton)
        contentStack.addArrangedSubview(createSectionLabel("Away Team"))
        contentStack.addArrangedSubview(awayTeamButton)
        contentStack.addArrangedSubview(simulateButton)
        
        NSLayoutConstraint.activate([
            fieldView.heightAnchor.constraint(equalTo: fieldView.widthAnchor, multiplier: 0.6)
        ])
    }
    
    private func setupScoreboard() {
        scoreboardView.translatesAutoresizingMaskIntoConstraints = false
        
        let scoreStack = UIStackView(arrangedSubviews: [homeScoreLabel, separatorLabel, awayScoreLabel])
        scoreStack.axis = .horizontal
        scoreStack.spacing = 12
        scoreStack.alignment = .center
        scoreStack.distribution = .equalCentering
        scoreStack.translatesAutoresizingMaskIntoConstraints = false
        
        let teamsStack = UIStackView(arrangedSubviews: [homeTeamLabel, UIView(), awayTeamLabel])
        teamsStack.axis = .horizontal
        teamsStack.distribution = .equalSpacing
        teamsStack.translatesAutoresizingMaskIntoConstraints = false
        
        minuteLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        scoreboardView.addSubview(teamsStack)
        scoreboardView.addSubview(scoreStack)
        scoreboardView.addSubview(minuteLabel)
        scoreboardView.addSubview(progressView)
        
        let homeDot = UIView()
        homeDot.translatesAutoresizingMaskIntoConstraints = false
        homeDot.backgroundColor = UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 1.0)
        homeDot.layer.cornerRadius = 4
        scoreboardView.addSubview(homeDot)
        
        let awayDot = UIView()
        awayDot.translatesAutoresizingMaskIntoConstraints = false
        awayDot.backgroundColor = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)
        awayDot.layer.cornerRadius = 4
        scoreboardView.addSubview(awayDot)
        
        NSLayoutConstraint.activate([
            scoreboardView.heightAnchor.constraint(equalToConstant: 130),
            
            teamsStack.topAnchor.constraint(equalTo: scoreboardView.topAnchor, constant: 14),
            teamsStack.leadingAnchor.constraint(equalTo: scoreboardView.leadingAnchor, constant: 24),
            teamsStack.trailingAnchor.constraint(equalTo: scoreboardView.trailingAnchor, constant: -24),
            
            scoreStack.centerYAnchor.constraint(equalTo: scoreboardView.centerYAnchor, constant: 4),
            scoreStack.centerXAnchor.constraint(equalTo: scoreboardView.centerXAnchor),
            
            minuteLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -6),
            minuteLabel.centerXAnchor.constraint(equalTo: scoreboardView.centerXAnchor),
            
            progressView.bottomAnchor.constraint(equalTo: scoreboardView.bottomAnchor, constant: -10),
            progressView.leadingAnchor.constraint(equalTo: scoreboardView.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: scoreboardView.trailingAnchor, constant: -20),
            
            homeDot.widthAnchor.constraint(equalToConstant: 8),
            homeDot.heightAnchor.constraint(equalToConstant: 8),
            homeDot.centerYAnchor.constraint(equalTo: homeTeamLabel.centerYAnchor),
            homeDot.trailingAnchor.constraint(equalTo: homeTeamLabel.leadingAnchor, constant: -6),
            
            awayDot.widthAnchor.constraint(equalToConstant: 8),
            awayDot.heightAnchor.constraint(equalToConstant: 8),
            awayDot.centerYAnchor.constraint(equalTo: awayTeamLabel.centerYAnchor),
            awayDot.leadingAnchor.constraint(equalTo: awayTeamLabel.trailingAnchor, constant: 6)
        ])
    }
    
    private func setupEventLog() {
        eventLogView.translatesAutoresizingMaskIntoConstraints = false
        
        eventLogView.addSubview(eventLogStack)
        
        eventLogStack.addArrangedSubview(eventLogTitleLabel)
        
        for _ in 0..<maxEvents {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12)
            label.textColor = .secondaryLabel
            label.text = ""
            eventLabels.append(label)
            eventLogStack.addArrangedSubview(label)
        }
        
        NSLayoutConstraint.activate([
            eventLogStack.topAnchor.constraint(equalTo: eventLogView.topAnchor, constant: 10),
            eventLogStack.leadingAnchor.constraint(equalTo: eventLogView.leadingAnchor, constant: 14),
            eventLogStack.trailingAnchor.constraint(equalTo: eventLogView.trailingAnchor, constant: -14),
            eventLogStack.bottomAnchor.constraint(equalTo: eventLogView.bottomAnchor, constant: -10)
        ])
    }
    
    private func createSectionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }
    
    private func createLeagueMenu() -> UIMenu {
        let actions = viewModel.leagueNames.enumerated().map { index, name in
            UIAction(title: name, state: index == viewModel.selectedLeagueIndex ? .on : .off) { [weak self] _ in
                self?.viewModel.selectedLeagueIndex = index
                self?.leagueButton.configuration?.title = name
                self?.leagueButton.menu = self?.createLeagueMenu()
            }
        }
        return UIMenu(title: "Select League", children: actions)
    }
    
    private func createTeamMenu(isHome: Bool) -> UIMenu {
        let teams = viewModel.currentTeams
        let selectedIndex = isHome ? viewModel.selectedHomeTeamIndex : viewModel.selectedAwayTeamIndex
        
        let actions = teams.enumerated().map { index, name in
            UIAction(title: name, state: index == selectedIndex ? .on : .off) { [weak self] _ in
                if isHome {
                    self?.viewModel.selectedHomeTeamIndex = index
                    self?.homeTeamButton.configuration?.title = name
                } else {
                    self?.viewModel.selectedAwayTeamIndex = index
                    self?.awayTeamButton.configuration?.title = name
                }
                self?.updateTeamMenus()
            }
        }
        return UIMenu(title: isHome ? "Home Team" : "Away Team", children: actions)
    }
    
    private func updateTeamMenus() {
        homeTeamButton.configuration?.title = viewModel.homeTeamName
        awayTeamButton.configuration?.title = viewModel.awayTeamName
        homeTeamButton.menu = createTeamMenu(isHome: true)
        awayTeamButton.menu = createTeamMenu(isHome: false)
    }
    
    @objc private func simulateTapped() {
        if viewModel.isSimulating {
            viewModel.stopSimulation()
            return
        }
        
        if viewModel.homeTeamName == viewModel.awayTeamName {
            showAlert(title: "Invalid Selection", message: "Home and Away teams must be different.")
            return
        }
        
        homeTeamLabel.text = viewModel.homeTeamName
        awayTeamLabel.text = viewModel.awayTeamName
        clearEventLog()
        
        viewModel.startSimulation()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func updateButtonState(isSimulating: Bool) {
        if isSimulating {
            simulateButton.setTitle("Stop Simulation", for: .normal)
            simulateButton.backgroundColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0)
            leagueButton.isEnabled = false
            homeTeamButton.isEnabled = false
            awayTeamButton.isEnabled = false
        } else {
            simulateButton.setTitle("Start Simulation", for: .normal)
            simulateButton.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
            leagueButton.isEnabled = true
            homeTeamButton.isEnabled = true
            awayTeamButton.isEnabled = true
        }
    }
    
    private func addEventToLog(minute: Int, event: MatchEvent) {
        let text: String
        
        switch event {
        case .kickoff:
            text = "\(minute)' - Kick Off"
        case .goal(let isHome):
            let team = isHome ? viewModel.homeTeamName : viewModel.awayTeamName
            text = "\(minute)' - GOAL! \(team)"
        case .shot(let isHome):
            let team = isHome ? viewModel.homeTeamName : viewModel.awayTeamName
            text = "\(minute)' - Shot by \(team)"
        case .save(let isHome):
            let team = isHome ? viewModel.awayTeamName : viewModel.homeTeamName
            text = "\(minute)' - Save by \(team)"
        case .foul(let isHome):
            let team = isHome ? viewModel.homeTeamName : viewModel.awayTeamName
            text = "\(minute)' - Foul by \(team)"
        case .corner(let isHome):
            let team = isHome ? viewModel.homeTeamName : viewModel.awayTeamName
            text = "\(minute)' - Corner for \(team)"
        case .offside(let isHome):
            let team = isHome ? viewModel.homeTeamName : viewModel.awayTeamName
            text = "\(minute)' - Offside \(team)"
        case .passing, .idle:
            return
        }
        
        for i in stride(from: maxEvents - 1, through: 1, by: -1) {
            eventLabels[i].text = eventLabels[i - 1].text
            eventLabels[i].textColor = eventLabels[i - 1].textColor
        }
        
        eventLabels[0].text = text
        
        switch event {
        case .goal:
            eventLabels[0].textColor = UIColor(red: 0.3, green: 0.8, blue: 0.3, alpha: 1.0)
        case .foul:
            eventLabels[0].textColor = .systemYellow
        default:
            eventLabels[0].textColor = .label
        }
    }
    
    private func clearEventLog() {
        for label in eventLabels {
            label.text = ""
        }
    }
}

extension SimulatorViewController: SimulatorViewModelDelegate {
    
    func didStartSimulation() {
        updateButtonState(isSimulating: true)
        progressView.isHidden = false
        progressView.progress = 0
        homeScoreLabel.text = "0"
        awayScoreLabel.text = "0"
        minuteLabel.text = "0'"
        fieldView.resetPositions()
    }
    
    func didUpdateMatch(home: Int, away: Int, minute: Int, event: MatchEvent) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.homeScoreLabel.text = "\(home)"
            self.awayScoreLabel.text = "\(away)"
            self.minuteLabel.text = "\(minute)'"
            self.progressView.progress = Float(minute) / 90.0
            
            self.fieldView.animateEvent(event)
            self.addEventToLog(minute: minute, event: event)
        }
    }
    
    func didFinishSimulation(match: Match) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.updateButtonState(isSimulating: false)
            self.progressView.isHidden = true
            
            let result: String
            if match.homeScore > match.awayScore {
                result = "\(match.homeTeam) Wins!"
            } else if match.homeScore < match.awayScore {
                result = "\(match.awayTeam) Wins!"
            } else {
                result = "It's a Draw!"
            }
            
            self.addEventToLog(minute: 90, event: .kickoff)
            self.showAlert(title: "Full Time", message: "\(match.homeTeam) \(match.homeScore) - \(match.awayScore) \(match.awayTeam)\n\(result)")
        }
    }
    
    func didUpdateTeams() {
        updateTeamMenus()
        leagueButton.menu = createLeagueMenu()
    }
}
