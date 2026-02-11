import UIKit

final class MatchCell: UITableViewCell {
    
    static let identifier = "MatchCell"
    
    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }()
    
    private let teamsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    private let detailsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let leagueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGreen
        return label
    }()
    
    private let resultBadge: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let simulatedBadge: UILabel = {
        let label = UILabel()
        label.text = "SIM"
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .white
        label.backgroundColor = .systemOrange
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        selectionStyle = .none
        
        contentView.addSubview(containerStack)
        contentView.addSubview(resultBadge)
        
        detailsStack.addArrangedSubview(leagueLabel)
        detailsStack.addArrangedSubview(dateLabel)
        detailsStack.addArrangedSubview(simulatedBadge)
        detailsStack.addArrangedSubview(UIView())
        
        containerStack.addArrangedSubview(teamsLabel)
        containerStack.addArrangedSubview(scoreLabel)
        containerStack.addArrangedSubview(detailsStack)
        
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: resultBadge.leadingAnchor, constant: -10),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            resultBadge.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            resultBadge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            resultBadge.widthAnchor.constraint(equalToConstant: 50),
            resultBadge.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configure(with match: Match, dateString: String, result: String) {
        teamsLabel.text = "\(match.homeTeam) vs \(match.awayTeam)"
        scoreLabel.text = "\(match.homeScore) - \(match.awayScore)"
        dateLabel.text = dateString
        leagueLabel.text = match.league
        resultBadge.text = result
        simulatedBadge.isHidden = !match.isSimulated
        
        switch result {
        case "Win":
            resultBadge.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.2)
            resultBadge.textColor = UIColor(red: 0.1, green: 0.6, blue: 0.3, alpha: 1.0)
        case "Loss":
            resultBadge.backgroundColor = UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 0.2)
            resultBadge.textColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        default:
            resultBadge.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 0.2)
            resultBadge.textColor = UIColor(red: 0.8, green: 0.6, blue: 0.0, alpha: 1.0)
        }
    }
}
