import UIKit

final class TrackerViewController: UIViewController {
    
    private let viewModel = TrackerViewModel()
    
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
        stack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private let statsCard = StatsCardView()
    
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
    
    private let homeScoreLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let awayScoreLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let vsLabel: UILabel = {
        let label = UILabel()
        label.text = "VS"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var homeMinusButton = createScoreButton(title: "-", action: #selector(homeMinusTapped))
    private lazy var homePlusButton = createScoreButton(title: "+", action: #selector(homePlusTapped))
    private lazy var awayMinusButton = createScoreButton(title: "-", action: #selector(awayMinusTapped))
    private lazy var awayPlusButton = createScoreButton(title: "+", action: #selector(awayPlusTapped))
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Match", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
        updateTeamMenus()
        updateStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStats()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setupUI() {
        title = "Match Tracker"
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
        
        contentStack.addArrangedSubview(statsCard)
        contentStack.addArrangedSubview(createSectionLabel("League"))
        contentStack.addArrangedSubview(leagueButton)
        contentStack.addArrangedSubview(createSectionLabel("Home Team"))
        contentStack.addArrangedSubview(homeTeamButton)
        contentStack.addArrangedSubview(createSectionLabel("Away Team"))
        contentStack.addArrangedSubview(awayTeamButton)
        contentStack.addArrangedSubview(createSectionLabel("Score"))
        contentStack.addArrangedSubview(createScoreView())
        contentStack.addArrangedSubview(saveButton)
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
    
    private func createScoreView() -> UIView {
        let scoreStack = UIStackView(arrangedSubviews: [
            homeMinusButton, homeScoreLabel, homePlusButton,
            vsLabel,
            awayMinusButton, awayScoreLabel, awayPlusButton
        ])
        scoreStack.axis = .horizontal
        scoreStack.alignment = .center
        scoreStack.distribution = .equalCentering
        scoreStack.translatesAutoresizingMaskIntoConstraints = false
        
        let wrapper = UIView()
        wrapper.addSubview(scoreStack)
        
        NSLayoutConstraint.activate([
            wrapper.heightAnchor.constraint(equalToConstant: 70),
            scoreStack.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
            scoreStack.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
            scoreStack.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor)
        ])
        
        return wrapper
    }
    
    private func createScoreButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 18
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func updateStats() {
        let stats = viewModel.statistics
        statsCard.configure(
            league: viewModel.selectedLeagueName,
            matches: stats.totalMatches,
            wins: stats.wins,
            draws: stats.draws,
            losses: stats.losses,
            goals: stats.totalGoalsScored,
            winRate: stats.winRate
        )
    }
    
    private func updateScoreLabels() {
        homeScoreLabel.text = "\(viewModel.homeScore)"
        awayScoreLabel.text = "\(viewModel.awayScore)"
    }
    
    @objc private func homeMinusTapped() {
        viewModel.decrementHomeScore()
        updateScoreLabels()
    }
    
    @objc private func homePlusTapped() {
        viewModel.incrementHomeScore()
        updateScoreLabels()
    }
    
    @objc private func awayMinusTapped() {
        viewModel.decrementAwayScore()
        updateScoreLabels()
    }
    
    @objc private func awayPlusTapped() {
        viewModel.incrementAwayScore()
        updateScoreLabels()
    }
    
    @objc private func saveTapped() {
        if viewModel.homeTeamName == viewModel.awayTeamName {
            showAlert(title: "Invalid Selection", message: "Home and Away teams must be different.")
            return
        }
        
        viewModel.saveMatch()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension TrackerViewController: TrackerViewModelDelegate {
    
    func didUpdateStatistics() {
        updateStats()
    }
    
    func didSaveMatch() {
        updateScoreLabels()
        showAlert(title: "Success", message: "Match saved successfully!")
    }
    
    func didUpdateTeams() {
        updateTeamMenus()
        leagueButton.menu = createLeagueMenu()
        updateStats()
    }
}
