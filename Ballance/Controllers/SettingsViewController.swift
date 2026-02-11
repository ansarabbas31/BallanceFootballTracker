import UIKit

final class SettingsViewController: UIViewController {
    
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
        stack.spacing = 24
        stack.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 40, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setupUI() {
        title = "Settings"
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
        
        contentStack.addArrangedSubview(createResetSection())
        contentStack.addArrangedSubview(createGuideSection())
    }
    
    private func createResetSection() -> UIView {
        let container = UIView()
        container.backgroundColor = .systemGray6
        container.layer.cornerRadius = 14
        
        let button = UIButton(type: .system)
        button.setTitle("Reset All Statistics", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        
        container.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -14),
            button.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        return container
    }
    
    private func createGuideSection() -> UIView {
        let container = UIView()
        container.backgroundColor = .systemGray6
        container.layer.cornerRadius = 14
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        
        container.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
        ])
        
        let headerLabel = UILabel()
        headerLabel.text = "How to Use Ballance"
        headerLabel.font = .systemFont(ofSize: 20, weight: .bold)
        headerLabel.textColor = .label
        stack.addArrangedSubview(headerLabel)
        
        let introLabel = UILabel()
        introLabel.text = "Ballance is a football match tracker and mini-simulator. Track real match results across top European leagues and simulate exciting matches between your favorite clubs."
        introLabel.font = .systemFont(ofSize: 14)
        introLabel.textColor = .secondaryLabel
        introLabel.numberOfLines = 0
        stack.addArrangedSubview(introLabel)
        
        stack.addArrangedSubview(createGuideItem(
            icon: "soccerball",
            title: "Match Tracker",
            text: "Record real match results. Select a league, pick home and away teams, set the score, and save. Statistics update instantly for the selected league."
        ))
        
        stack.addArrangedSubview(createGuideItem(
            icon: "play.rectangle.fill",
            title: "Match Simulator",
            text: "Watch an animated match simulation on a football pitch powered by SpriteKit. Choose any two teams from the same league, hit Start, and watch the game unfold with goals, shots, saves, fouls, corners, and offsides."
        ))
        
        stack.addArrangedSubview(createGuideItem(
            icon: "clock.fill",
            title: "Match History",
            text: "Browse all recorded and simulated matches. Filter by league to see per-league stats including wins, draws, losses, goals scored, and win rate. Swipe left on any match to delete it."
        ))
        
        stack.addArrangedSubview(createGuideItem(
            icon: "chart.bar.fill",
            title: "League Statistics",
            text: "Each league has independent statistics. Switch leagues in the Tracker or History tabs to see how your results differ across Premier League, La Liga, Bundesliga, Serie A, Ligue 1, and Champions League."
        ))
        
        stack.addArrangedSubview(createGuideItem(
            icon: "arrow.triangle.2.circlepath",
            title: "Simulated vs Real",
            text: "Matches you record manually and matches from the simulator are both saved to history. Simulated matches are marked with an orange SIM badge so you can tell them apart."
        ))
        
        return container
    }
    
    private func createGuideItem(icon: String, title: String, text: String) -> UIView {
        let container = UIView()
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = .systemFont(ofSize: 13)
        textLabel.textColor = .secondaryLabel
        textLabel.numberOfLines = 0
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, textLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(iconView)
        container.addSubview(textStack)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            textStack.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            textStack.topAnchor.constraint(equalTo: container.topAnchor),
            textStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    @objc private func resetTapped() {
        let alert = UIAlertController(
            title: "Reset Statistics",
            message: "Are you sure you want to delete all match history? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { [weak self] _ in
            self?.resetAllData()
        })
        
        present(alert, animated: true)
    }
    
    private func resetAllData() {
        UserDefaults.standard.removeObject(forKey: "saved_matches_key")
        
        let alert = UIAlertController(
            title: "Done",
            message: "All statistics have been reset.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
