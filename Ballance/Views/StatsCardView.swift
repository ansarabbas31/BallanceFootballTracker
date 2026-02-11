import UIKit

final class StatsCardView: UIView {
    
    private let leagueNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    private let topRow: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private let bottomRow: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private let matchesItem = StatItemView()
    private let winsItem = StatItemView()
    private let drawsItem = StatItemView()
    private let lossesItem = StatItemView()
    private let goalsItem = StatItemView()
    private let winRateItem = StatItemView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 0.08)
        layer.cornerRadius = 16
        
        let mainStack = UIStackView(arrangedSubviews: [leagueNameLabel, topRow, bottomRow])
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.axis = .vertical
        mainStack.spacing = 10
        addSubview(mainStack)
        
        topRow.addArrangedSubview(matchesItem)
        topRow.addArrangedSubview(winsItem)
        topRow.addArrangedSubview(drawsItem)
        
        bottomRow.addArrangedSubview(lossesItem)
        bottomRow.addArrangedSubview(goalsItem)
        bottomRow.addArrangedSubview(winRateItem)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
        
        configure(league: "Premier League", matches: 0, wins: 0, draws: 0, losses: 0, goals: 0, winRate: 0)
    }
    
    func configure(league: String, matches: Int, wins: Int, draws: Int, losses: Int, goals: Int, winRate: Double) {
        leagueNameLabel.text = league
        matchesItem.configure(title: "Matches", value: "\(matches)")
        winsItem.configure(title: "Wins", value: "\(wins)", valueColor: UIColor(red: 0.2, green: 0.7, blue: 0.3, alpha: 1.0))
        drawsItem.configure(title: "Draws", value: "\(draws)", valueColor: .systemOrange)
        lossesItem.configure(title: "Losses", value: "\(losses)", valueColor: UIColor(red: 0.9, green: 0.25, blue: 0.25, alpha: 1.0))
        goalsItem.configure(title: "Goals", value: "\(goals)")
        winRateItem.configure(title: "Win Rate", value: String(format: "%.0f%%", winRate))
    }
}

final class StatItemView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let stack = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .center
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(title: String, value: String, valueColor: UIColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)) {
        titleLabel.text = title
        valueLabel.text = value
        valueLabel.textColor = valueColor
    }
}
