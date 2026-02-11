import UIKit

final class HistoryViewController: UIViewController {
    
    private let viewModel = HistoryViewModel()
    
    private let statsCard = StatsCardView()
    
    private lazy var leagueFilterButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "All Leagues"
        config.baseForegroundColor = .tintColor
        config.baseBackgroundColor = .systemGray6
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        config.image = UIImage(systemName: "line.3.horizontal.decrease.circle")
        config.imagePadding = 8
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            return outgoing
        }
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading
        button.layer.cornerRadius = 10
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.menu = createFilterMenu()
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(MatchCell.self, forCellReuseIdentifier: MatchCell.identifier)
        return table
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No matches yet.\nStart tracking your games!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshData()
        updateStatsCard()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setupUI() {
        title = "Match History"
        view.backgroundColor = .systemBackground
        
        statsCard.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(statsCard)
        view.addSubview(leagueFilterButton)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            statsCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            statsCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            leagueFilterButton.topAnchor.constraint(equalTo: statsCard.bottomAnchor, constant: 12),
            leagueFilterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            leagueFilterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: leagueFilterButton.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
    private func createFilterMenu() -> UIMenu {
        var actions: [UIAction] = []
        
        let allAction = UIAction(
            title: "All Leagues",
            image: UIImage(systemName: "globe"),
            state: viewModel.showAllLeagues ? .on : .off
        ) { [weak self] _ in
            self?.viewModel.showAllLeagues = true
            self?.leagueFilterButton.configuration?.title = "All Leagues"
            self?.leagueFilterButton.menu = self?.createFilterMenu()
        }
        actions.append(allAction)
        
        for (index, name) in viewModel.leagueNames.enumerated() {
            let isSelected = !viewModel.showAllLeagues && index == viewModel.selectedLeagueIndex
            let action = UIAction(
                title: name,
                state: isSelected ? .on : .off
            ) { [weak self] _ in
                self?.viewModel.showAllLeagues = false
                self?.viewModel.selectedLeagueIndex = index
                self?.leagueFilterButton.configuration?.title = name
                self?.leagueFilterButton.menu = self?.createFilterMenu()
            }
            actions.append(action)
        }
        
        return UIMenu(title: "Filter by League", children: actions)
    }
    
    private func updateStatsCard() {
        let stats = viewModel.statistics
        statsCard.configure(
            league: viewModel.currentFilterTitle,
            matches: stats.totalMatches,
            wins: stats.wins,
            draws: stats.draws,
            losses: stats.losses,
            goals: stats.totalGoalsScored,
            winRate: stats.winRate
        )
    }
    
    private func updateEmptyState() {
        emptyLabel.isHidden = viewModel.matchCount > 0
        tableView.isHidden = viewModel.matchCount == 0
    }
}

extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.matchCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MatchCell.identifier, for: indexPath) as? MatchCell,
              let match = viewModel.match(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.configure(
            with: match,
            dateString: viewModel.formatDate(match.date),
            result: viewModel.getResultText(for: match)
        )
        
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteMatch(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension HistoryViewController: HistoryViewModelDelegate {
    
    func didUpdateMatches() {
        tableView.reloadData()
        updateEmptyState()
        updateStatsCard()
    }
    
    func didUpdateLeague() {
        leagueFilterButton.menu = createFilterMenu()
    }
}
