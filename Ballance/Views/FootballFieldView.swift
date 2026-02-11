import UIKit
import SpriteKit

enum MatchEvent {
    case kickoff
    case passing(isHome: Bool)
    case shot(isHome: Bool)
    case goal(isHome: Bool)
    case save(isHome: Bool)
    case foul(isHome: Bool)
    case corner(isHome: Bool)
    case offside(isHome: Bool)
    case idle
}

final class FootballFieldView: UIView {
    
    private var skView: SKView!
    private var fieldScene: FootballFieldScene?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 16
        clipsToBounds = true
        
        skView = SKView(frame: bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        skView.allowsTransparency = false
        skView.ignoresSiblingOrder = true
        addSubview(skView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        skView.frame = bounds
        
        if fieldScene == nil && bounds.width > 0 && bounds.height > 0 {
            let scene = FootballFieldScene(size: bounds.size)
            scene.scaleMode = .resizeFill
            fieldScene = scene
            skView.presentScene(scene)
        } else if let scene = fieldScene {
            scene.size = bounds.size
            scene.layoutField()
        }
    }
    
    func resetPositions() {
        fieldScene?.resetPositions()
    }
    
    func animateEvent(_ event: MatchEvent) {
        fieldScene?.animateEvent(event)
    }
}
