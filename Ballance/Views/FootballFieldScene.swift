import SpriteKit

final class FootballFieldScene: SKScene {
    
    private let fieldColor = SKColor(red: 0.18, green: 0.55, blue: 0.22, alpha: 1.0)
    private let darkerGreen = SKColor(red: 0.15, green: 0.48, blue: 0.19, alpha: 1.0)
    private let lineColor = SKColor.white
    private let homeColor = SKColor(red: 0.2, green: 0.4, blue: 0.9, alpha: 1.0)
    private let awayColor = SKColor(red: 0.9, green: 0.25, blue: 0.25, alpha: 1.0)
    
    private var fieldNode = SKNode()
    private var ballNode = SKShapeNode()
    private var homePlayers: [SKShapeNode] = []
    private var awayPlayers: [SKShapeNode] = []
    private var goalFlashNode = SKSpriteNode()
    private var eventLabelNode = SKLabelNode()
    private var goalLabelNode = SKLabelNode()
    private var leftGoalNetNode = SKShapeNode()
    private var rightGoalNetNode = SKShapeNode()
    
    private let padding: CGFloat = 16
    
    private var fieldRect: CGRect {
        let w = size.width - padding * 2
        let h = size.height - padding * 2
        return CGRect(x: padding, y: padding, width: w, height: h)
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = fieldColor
        buildField()
        buildPlayers()
        buildBall()
        buildOverlays()
        resetPositions()
    }
    
    func layoutField() {
        removeAllChildren()
        fieldNode = SKNode()
        homePlayers.removeAll()
        awayPlayers.removeAll()
        
        buildField()
        buildPlayers()
        buildBall()
        buildOverlays()
        resetPositions()
    }
    
    private func buildField() {
        addChild(fieldNode)
        
        let f = fieldRect
        let stripeH: CGFloat = 22
        var y: CGFloat = 0
        var toggle = false
        while y < size.height {
            if toggle {
                let stripe = SKSpriteNode(color: darkerGreen, size: CGSize(width: size.width, height: stripeH))
                stripe.anchorPoint = .zero
                stripe.position = CGPoint(x: 0, y: y)
                stripe.zPosition = -1
                fieldNode.addChild(stripe)
            }
            y += stripeH
            toggle.toggle()
        }
        
        let border = SKShapeNode(rect: f)
        border.strokeColor = lineColor
        border.lineWidth = 2
        border.fillColor = .clear
        border.zPosition = 1
        fieldNode.addChild(border)
        
        let halfLine = SKShapeNode()
        let halfPath = CGMutablePath()
        halfPath.move(to: CGPoint(x: f.midX, y: f.minY))
        halfPath.addLine(to: CGPoint(x: f.midX, y: f.maxY))
        halfLine.path = halfPath
        halfLine.strokeColor = lineColor
        halfLine.lineWidth = 2
        halfLine.zPosition = 1
        fieldNode.addChild(halfLine)
        
        let centerCircle = SKShapeNode(circleOfRadius: 34)
        centerCircle.position = CGPoint(x: f.midX, y: f.midY)
        centerCircle.strokeColor = lineColor
        centerCircle.lineWidth = 2
        centerCircle.fillColor = .clear
        centerCircle.zPosition = 1
        fieldNode.addChild(centerCircle)
        
        let centerDot = SKShapeNode(circleOfRadius: 3)
        centerDot.position = CGPoint(x: f.midX, y: f.midY)
        centerDot.fillColor = lineColor
        centerDot.strokeColor = .clear
        centerDot.zPosition = 1
        fieldNode.addChild(centerDot)
        
        let penW = f.width * 0.17
        let penH = f.height * 0.55
        
        let leftPenalty = SKShapeNode(rect: CGRect(x: f.minX, y: f.midY - penH / 2, width: penW, height: penH))
        leftPenalty.strokeColor = lineColor
        leftPenalty.lineWidth = 2
        leftPenalty.fillColor = .clear
        leftPenalty.zPosition = 1
        fieldNode.addChild(leftPenalty)
        
        let rightPenalty = SKShapeNode(rect: CGRect(x: f.maxX - penW, y: f.midY - penH / 2, width: penW, height: penH))
        rightPenalty.strokeColor = lineColor
        rightPenalty.lineWidth = 2
        rightPenalty.fillColor = .clear
        rightPenalty.zPosition = 1
        fieldNode.addChild(rightPenalty)
        
        let goalBoxW = f.width * 0.07
        let goalBoxH = f.height * 0.3
        
        let leftGoalBox = SKShapeNode(rect: CGRect(x: f.minX, y: f.midY - goalBoxH / 2, width: goalBoxW, height: goalBoxH))
        leftGoalBox.strokeColor = lineColor
        leftGoalBox.lineWidth = 2
        leftGoalBox.fillColor = .clear
        leftGoalBox.zPosition = 1
        fieldNode.addChild(leftGoalBox)
        
        let rightGoalBox = SKShapeNode(rect: CGRect(x: f.maxX - goalBoxW, y: f.midY - goalBoxH / 2, width: goalBoxW, height: goalBoxH))
        rightGoalBox.strokeColor = lineColor
        rightGoalBox.lineWidth = 2
        rightGoalBox.fillColor = .clear
        rightGoalBox.zPosition = 1
        fieldNode.addChild(rightGoalBox)
        
        let goalNetH = f.height * 0.24
        let goalNetW: CGFloat = 8
        
        leftGoalNetNode = SKShapeNode(rect: CGRect(x: f.minX - goalNetW, y: f.midY - goalNetH / 2, width: goalNetW, height: goalNetH))
        leftGoalNetNode.strokeColor = lineColor
        leftGoalNetNode.lineWidth = 2.5
        leftGoalNetNode.fillColor = SKColor.white.withAlphaComponent(0.25)
        leftGoalNetNode.zPosition = 2
        fieldNode.addChild(leftGoalNetNode)
        
        rightGoalNetNode = SKShapeNode(rect: CGRect(x: f.maxX, y: f.midY - goalNetH / 2, width: goalNetW, height: goalNetH))
        rightGoalNetNode.strokeColor = lineColor
        rightGoalNetNode.lineWidth = 2.5
        rightGoalNetNode.fillColor = SKColor.white.withAlphaComponent(0.25)
        rightGoalNetNode.zPosition = 2
        fieldNode.addChild(rightGoalNetNode)
        
        let leftPenDot = SKShapeNode(circleOfRadius: 2.5)
        leftPenDot.position = CGPoint(x: f.minX + penW * 0.7, y: f.midY)
        leftPenDot.fillColor = lineColor
        leftPenDot.strokeColor = .clear
        leftPenDot.zPosition = 1
        fieldNode.addChild(leftPenDot)
        
        let rightPenDot = SKShapeNode(circleOfRadius: 2.5)
        rightPenDot.position = CGPoint(x: f.maxX - penW * 0.7, y: f.midY)
        rightPenDot.fillColor = lineColor
        rightPenDot.strokeColor = .clear
        rightPenDot.zPosition = 1
        fieldNode.addChild(rightPenDot)
        
        let cornerRadius: CGFloat = 10
        let corners: [(CGPoint, CGFloat, CGFloat)] = [
            (CGPoint(x: f.minX, y: f.minY), 0, .pi / 2),
            (CGPoint(x: f.maxX, y: f.minY), .pi / 2, .pi),
            (CGPoint(x: f.maxX, y: f.maxY), .pi, 3 * .pi / 2),
            (CGPoint(x: f.minX, y: f.maxY), 3 * .pi / 2, 2 * .pi)
        ]
        
        for (center, start, end) in corners {
            let arcPath = CGMutablePath()
            arcPath.addArc(center: center, radius: cornerRadius, startAngle: start, endAngle: end, clockwise: false)
            let arc = SKShapeNode(path: arcPath)
            arc.strokeColor = lineColor
            arc.lineWidth = 2
            arc.zPosition = 1
            fieldNode.addChild(arc)
        }
    }
    
    private func buildPlayers() {
        for _ in 0..<5 {
            let player = createPlayerNode(color: homeColor)
            homePlayers.append(player)
            addChild(player)
        }
        
        for _ in 0..<5 {
            let player = createPlayerNode(color: awayColor)
            awayPlayers.append(player)
            addChild(player)
        }
    }
    
    private func createPlayerNode(color: SKColor) -> SKShapeNode {
        let node = SKShapeNode(circleOfRadius: 8)
        node.fillColor = color
        node.strokeColor = .white
        node.lineWidth = 2
        node.zPosition = 10
        
        let glow = SKShapeNode(circleOfRadius: 11)
        glow.fillColor = color.withAlphaComponent(0.3)
        glow.strokeColor = .clear
        glow.zPosition = -1
        node.addChild(glow)
        
        return node
    }
    
    private func buildBall() {
        ballNode = SKShapeNode(circleOfRadius: 6)
        ballNode.fillColor = .white
        ballNode.strokeColor = SKColor(white: 0.7, alpha: 1.0)
        ballNode.lineWidth = 1
        ballNode.zPosition = 20
        
        let shadow = SKShapeNode(ellipseOf: CGSize(width: 10, height: 5))
        shadow.fillColor = SKColor.black.withAlphaComponent(0.3)
        shadow.strokeColor = .clear
        shadow.position = CGPoint(x: 0, y: -5)
        shadow.zPosition = -1
        ballNode.addChild(shadow)
        
        let pattern1 = SKShapeNode(circleOfRadius: 2)
        pattern1.fillColor = SKColor(white: 0.85, alpha: 1.0)
        pattern1.strokeColor = .clear
        pattern1.position = CGPoint(x: -2, y: 2)
        pattern1.zPosition = 1
        ballNode.addChild(pattern1)
        
        let pattern2 = SKShapeNode(circleOfRadius: 1.5)
        pattern2.fillColor = SKColor(white: 0.85, alpha: 1.0)
        pattern2.strokeColor = .clear
        pattern2.position = CGPoint(x: 2, y: -1)
        pattern2.zPosition = 1
        ballNode.addChild(pattern2)
        
        addChild(ballNode)
    }
    
    private func buildOverlays() {
        goalFlashNode = SKSpriteNode(color: .white, size: size)
        goalFlashNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        goalFlashNode.alpha = 0
        goalFlashNode.zPosition = 50
        addChild(goalFlashNode)
        
        eventLabelNode = SKLabelNode(fontNamed: "Helvetica-Bold")
        eventLabelNode.fontSize = 13
        eventLabelNode.fontColor = .white
        eventLabelNode.position = CGPoint(x: size.width / 2, y: size.height - 18)
        eventLabelNode.alpha = 0
        eventLabelNode.zPosition = 40
        addChild(eventLabelNode)
        
        let eventBg = SKShapeNode(rectOf: CGSize(width: 120, height: 22), cornerRadius: 8)
        eventBg.fillColor = SKColor.black.withAlphaComponent(0.65)
        eventBg.strokeColor = .clear
        eventBg.zPosition = -1
        eventBg.name = "eventBg"
        eventLabelNode.addChild(eventBg)
        
        goalLabelNode = SKLabelNode(fontNamed: "Helvetica-Bold")
        goalLabelNode.fontSize = 42
        goalLabelNode.fontColor = .white
        goalLabelNode.text = "GOAL!"
        goalLabelNode.position = CGPoint(x: size.width / 2, y: size.height / 2 - 10)
        goalLabelNode.alpha = 0
        goalLabelNode.zPosition = 55
        addChild(goalLabelNode)
        
        let goalShadow = SKLabelNode(fontNamed: "Helvetica-Bold")
        goalShadow.fontSize = 42
        goalShadow.fontColor = SKColor.black.withAlphaComponent(0.5)
        goalShadow.text = "GOAL!"
        goalShadow.position = CGPoint(x: 2, y: -2)
        goalShadow.zPosition = -1
        goalLabelNode.addChild(goalShadow)
    }
    
    func resetPositions() {
        let f = fieldRect
        guard f.width > 0 else { return }
        
        ballNode.removeAllActions()
        ballNode.position = CGPoint(x: f.midX, y: f.midY)
        
        let homePos: [(CGFloat, CGFloat)] = [
            (0.12, 0.5), (0.28, 0.2), (0.28, 0.8), (0.42, 0.35), (0.42, 0.65)
        ]
        let awayPos: [(CGFloat, CGFloat)] = [
            (0.88, 0.5), (0.72, 0.2), (0.72, 0.8), (0.58, 0.35), (0.58, 0.65)
        ]
        
        for (i, pos) in homePos.enumerated() {
            guard i < homePlayers.count else { break }
            homePlayers[i].removeAllActions()
            homePlayers[i].position = CGPoint(x: f.minX + f.width * pos.0, y: f.minY + f.height * pos.1)
        }
        
        for (i, pos) in awayPos.enumerated() {
            guard i < awayPlayers.count else { break }
            awayPlayers[i].removeAllActions()
            awayPlayers[i].position = CGPoint(x: f.minX + f.width * pos.0, y: f.minY + f.height * pos.1)
        }
    }
    
    func animateEvent(_ event: MatchEvent) {
        switch event {
        case .kickoff:
            animateKickoff()
        case .passing(let isHome):
            animatePassing(isHome: isHome)
        case .shot(let isHome):
            animateShot(isHome: isHome)
        case .goal(let isHome):
            animateGoal(isHome: isHome)
        case .save(let isHome):
            animateSave(isHome: isHome)
        case .foul(let isHome):
            animateFoul(isHome: isHome)
        case .corner(let isHome):
            animateCorner(isHome: isHome)
        case .offside(let isHome):
            animateOffside(isHome: isHome)
        case .idle:
            animateIdle()
        }
    }
    
    private func animateKickoff() {
        showEventText("KICK OFF")
        let f = fieldRect
        
        moveBall(to: CGPoint(x: f.midX, y: f.midY), duration: 0.3)
        shufflePlayers(homePush: 0.04, awayPush: -0.04, duration: 0.4)
    }
    
    private func animatePassing(isHome: Bool) {
        let f = fieldRect
        let dir: CGFloat = isHome ? 1 : -1
        
        let tx = f.midX + dir * CGFloat.random(in: 20...f.width * 0.35)
        let ty = f.minY + CGFloat.random(in: f.height * 0.15...f.height * 0.85)
        
        moveBall(to: CGPoint(x: tx, y: ty), duration: 0.25)
        
        let trail = createTrailEmitter()
        trail.position = ballNode.position
        addChild(trail)
        trail.run(.sequence([.wait(forDuration: 0.3), .removeFromParent()]))
        
        shufflePlayers(homePush: isHome ? 0.04 : -0.02, awayPush: isHome ? -0.02 : 0.04, duration: 0.3)
    }
    
    private func animateShot(isHome: Bool) {
        showEventText("SHOT!")
        let f = fieldRect
        
        let goalX = isHome ? f.maxX - 8 : f.minX + 8
        let goalY = f.midY + CGFloat.random(in: -f.height * 0.12...f.height * 0.12)
        
        let trail = createShotTrail()
        trail.position = ballNode.position
        addChild(trail)
        
        moveBall(to: CGPoint(x: goalX, y: goalY), duration: 0.18)
        
        let players = isHome ? homePlayers : awayPlayers
        if let attacker = players.last {
            let target = CGPoint(x: goalX - (isHome ? 40 : -40), y: goalY)
            attacker.run(.move(to: target, duration: 0.2))
        }
        
        trail.run(.sequence([.wait(forDuration: 0.25), .fadeOut(withDuration: 0.1), .removeFromParent()]))
    }
    
    private func animateGoal(isHome: Bool) {
        let f = fieldRect
        
        let goalX = isHome ? f.maxX + 4 : f.minX - 4
        let goalY = f.midY + CGFloat.random(in: -f.height * 0.06...f.height * 0.06)
        
        moveBall(to: CGPoint(x: goalX, y: goalY), duration: 0.12)
        
        flashGoalEffect()
        showGoalText()
        shakeNet(isHome: isHome)
        spawnGoalParticles(at: CGPoint(x: goalX, y: goalY))
        
        let scorers = isHome ? homePlayers : awayPlayers
        for (i, player) in scorers.enumerated() {
            let cx = f.midX + (isHome ? 1 : -1) * CGFloat.random(in: 10...50)
            let cy = f.midY + CGFloat(i - 2) * 20
            player.run(.group([
                .move(to: CGPoint(x: cx, y: cy), duration: 0.4),
                .sequence([
                    .scale(to: 1.3, duration: 0.15),
                    .scale(to: 1.0, duration: 0.15),
                    .scale(to: 1.2, duration: 0.1),
                    .scale(to: 1.0, duration: 0.1)
                ])
            ]))
        }
        
        run(.sequence([.wait(forDuration: 1.3), .run { [weak self] in
            self?.resetAfterGoal()
        }]))
    }
    
    private func animateSave(isHome: Bool) {
        showEventText("SAVE!")
        let f = fieldRect
        
        let keeper = isHome ? awayPlayers.first : homePlayers.first
        guard let keeper = keeper else { return }
        
        let keeperX = isHome ? f.maxX - f.width * 0.04 : f.minX + f.width * 0.04
        let keeperY = f.midY + CGFloat.random(in: -25...25)
        
        keeper.run(.group([
            .move(to: CGPoint(x: keeperX, y: keeperY), duration: 0.12),
            .sequence([.scale(to: 1.4, duration: 0.08), .scale(to: 1.0, duration: 0.15)])
        ]))
        
        let bounceX = isHome ? f.maxX - 45 : f.minX + 45
        let bounceY = f.midY + CGFloat.random(in: -35...35)
        moveBall(to: CGPoint(x: bounceX, y: bounceY), duration: 0.2)
    }
    
    private func animateFoul(isHome: Bool) {
        showEventText("FOUL")
        let f = fieldRect
        
        let foulX = f.midX + (isHome ? 1 : -1) * CGFloat.random(in: 10...f.width * 0.3)
        let foulY = f.minY + CGFloat.random(in: f.height * 0.2...f.height * 0.8)
        
        moveBall(to: CGPoint(x: foulX, y: foulY), duration: 0.3)
        
        let foulers = isHome ? homePlayers : awayPlayers
        let idx = Int.random(in: 1..<foulers.count)
        let fouler = foulers[idx]
        
        let orig = fouler.position
        fouler.run(.sequence([
            .move(to: CGPoint(x: orig.x - 5, y: orig.y), duration: 0.05),
            .move(to: CGPoint(x: orig.x + 5, y: orig.y), duration: 0.05),
            .move(to: CGPoint(x: orig.x - 3, y: orig.y), duration: 0.05),
            .move(to: orig, duration: 0.05)
        ]))
        
        let whistle = SKShapeNode(circleOfRadius: 20)
        whistle.position = CGPoint(x: foulX, y: foulY)
        whistle.fillColor = SKColor.yellow.withAlphaComponent(0.3)
        whistle.strokeColor = .yellow
        whistle.lineWidth = 2
        whistle.zPosition = 30
        whistle.setScale(0.3)
        addChild(whistle)
        
        whistle.run(.sequence([
            .group([.scale(to: 1.5, duration: 0.3), .fadeOut(withDuration: 0.4)]),
            .removeFromParent()
        ]))
    }
    
    private func animateCorner(isHome: Bool) {
        showEventText("CORNER")
        let f = fieldRect
        
        let cornerX = isHome ? f.maxX - 2 : f.minX + 2
        let cornerY = Bool.random() ? f.minY + 2 : f.maxY - 2
        
        moveBall(to: CGPoint(x: cornerX, y: cornerY), duration: 0.25)
        
        let attackers = isHome ? homePlayers : awayPlayers
        for player in attackers.suffix(3) {
            let px = isHome ? f.maxX - CGFloat.random(in: 20...f.width * 0.18) : f.minX + CGFloat.random(in: 20...f.width * 0.18)
            let py = f.midY + CGFloat.random(in: -f.height * 0.22...f.height * 0.22)
            player.run(.move(to: CGPoint(x: px, y: py), duration: 0.35))
        }
        
        let flag = SKShapeNode(rectOf: CGSize(width: 3, height: 14))
        flag.fillColor = .yellow
        flag.strokeColor = .clear
        flag.position = CGPoint(x: cornerX, y: cornerY)
        flag.zPosition = 25
        flag.alpha = 0
        addChild(flag)
        
        flag.run(.sequence([
            .fadeIn(withDuration: 0.1),
            .wait(forDuration: 0.6),
            .fadeOut(withDuration: 0.2),
            .removeFromParent()
        ]))
    }
    
    private func animateOffside(isHome: Bool) {
        showEventText("OFFSIDE")
        let f = fieldRect
        
        let offsideX = isHome ? f.maxX - f.width * 0.15 : f.minX + f.width * 0.15
        moveBall(to: CGPoint(x: offsideX, y: f.midY), duration: 0.3)
        
        let lineNode = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: CGPoint(x: offsideX, y: f.minY))
        path.addLine(to: CGPoint(x: offsideX, y: f.maxY))
        lineNode.path = path
        lineNode.strokeColor = SKColor.red.withAlphaComponent(0.7)
        lineNode.lineWidth = 2
        lineNode.zPosition = 25
        lineNode.alpha = 0
        addChild(lineNode)
        
        lineNode.run(.sequence([
            .fadeIn(withDuration: 0.1),
            .wait(forDuration: 0.5),
            .fadeOut(withDuration: 0.3),
            .removeFromParent()
        ]))
    }
    
    private func animateIdle() {
        let f = fieldRect
        guard f.width > 0 else { return }
        
        let bx = f.minX + CGFloat.random(in: f.width * 0.2...f.width * 0.8)
        let by = f.minY + CGFloat.random(in: f.height * 0.15...f.height * 0.85)
        
        moveBall(to: CGPoint(x: bx, y: by), duration: 0.3)
        shufflePlayers(
            homePush: CGFloat.random(in: -0.03...0.03),
            awayPush: CGFloat.random(in: -0.03...0.03),
            duration: 0.35
        )
    }
    
    private func moveBall(to point: CGPoint, duration: TimeInterval) {
        ballNode.removeAllActions()
        
        let spin = SKAction.rotate(byAngle: .pi * 2, duration: duration)
        let move = SKAction.move(to: point, duration: duration)
        move.timingMode = .easeInEaseOut
        
        ballNode.run(.group([move, spin]))
    }
    
    private func shufflePlayers(homePush: CGFloat, awayPush: CGFloat, duration: TimeInterval) {
        let f = fieldRect
        guard f.width > 0 else { return }
        
        for (i, player) in homePlayers.enumerated() {
            var nx = player.position.x + CGFloat.random(in: -10...14) + f.width * homePush
            var ny = player.position.y + CGFloat.random(in: -10...10)
            
            nx = max(f.minX + 10, min(f.maxX - 10, nx))
            ny = max(f.minY + 10, min(f.maxY - 10, ny))
            
            if i == 0 { nx = min(nx, f.minX + f.width * 0.22) }
            
            let move = SKAction.move(to: CGPoint(x: nx, y: ny), duration: duration)
            move.timingMode = .easeInEaseOut
            player.run(move)
        }
        
        for (i, player) in awayPlayers.enumerated() {
            var nx = player.position.x + CGFloat.random(in: -14...10) + f.width * awayPush
            var ny = player.position.y + CGFloat.random(in: -10...10)
            
            nx = max(f.minX + 10, min(f.maxX - 10, nx))
            ny = max(f.minY + 10, min(f.maxY - 10, ny))
            
            if i == 0 { nx = max(nx, f.maxX - f.width * 0.22) }
            
            let move = SKAction.move(to: CGPoint(x: nx, y: ny), duration: duration)
            move.timingMode = .easeInEaseOut
            player.run(move)
        }
    }
    
    private func flashGoalEffect() {
        goalFlashNode.size = size
        goalFlashNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        goalFlashNode.run(.sequence([
            .fadeAlpha(to: 0.7, duration: 0.06),
            .fadeAlpha(to: 0.0, duration: 0.1),
            .fadeAlpha(to: 0.5, duration: 0.06),
            .fadeAlpha(to: 0.0, duration: 0.1),
            .fadeAlpha(to: 0.3, duration: 0.06),
            .fadeAlpha(to: 0.0, duration: 0.15)
        ]))
    }
    
    private func showGoalText() {
        goalLabelNode.position = CGPoint(x: size.width / 2, y: size.height / 2 - 10)
        goalLabelNode.setScale(0.2)
        goalLabelNode.alpha = 0
        
        goalLabelNode.run(.sequence([
            .group([
                .fadeIn(withDuration: 0.15),
                .scale(to: 1.3, duration: 0.2)
            ]),
            .scale(to: 1.0, duration: 0.1),
            .wait(forDuration: 0.5),
            .group([
                .fadeOut(withDuration: 0.3),
                .scale(to: 0.5, duration: 0.3)
            ])
        ]))
    }
    
    private func showEventText(_ text: String) {
        eventLabelNode.text = text
        eventLabelNode.position = CGPoint(x: size.width / 2, y: size.height - 18)
        eventLabelNode.alpha = 0
        
        eventLabelNode.run(.sequence([
            .fadeIn(withDuration: 0.1),
            .wait(forDuration: 0.7),
            .fadeOut(withDuration: 0.2)
        ]))
    }
    
    private func shakeNet(isHome: Bool) {
        let net = isHome ? rightGoalNetNode : leftGoalNetNode
        let orig = net.position
        
        net.run(.sequence([
            .move(to: CGPoint(x: orig.x + (isHome ? 3 : -3), y: orig.y), duration: 0.03),
            .move(to: CGPoint(x: orig.x - (isHome ? 2 : -2), y: orig.y), duration: 0.03),
            .move(to: CGPoint(x: orig.x + (isHome ? 1 : -1), y: orig.y), duration: 0.03),
            .move(to: orig, duration: 0.03)
        ]))
        
        let origFill = net.fillColor
        net.fillColor = SKColor.white.withAlphaComponent(0.6)
        net.run(.sequence([
            .wait(forDuration: 0.2),
            .run { net.fillColor = origFill }
        ]))
    }
    
    private func spawnGoalParticles(at pos: CGPoint) {
        for _ in 0..<12 {
            let particle = SKShapeNode(circleOfRadius: CGFloat.random(in: 2...5))
            particle.fillColor = [SKColor.yellow, SKColor.orange, SKColor.white, SKColor.green].randomElement()!
            particle.strokeColor = .clear
            particle.position = pos
            particle.zPosition = 45
            addChild(particle)
            
            let dx = CGFloat.random(in: -80...80)
            let dy = CGFloat.random(in: -60...60)
            let dur = Double.random(in: 0.4...0.8)
            
            particle.run(.sequence([
                .group([
                    .moveBy(x: dx, y: dy, duration: dur),
                    .fadeOut(withDuration: dur),
                    .scale(to: 0.1, duration: dur)
                ]),
                .removeFromParent()
            ]))
        }
    }
    
    private func createTrailEmitter() -> SKNode {
        let trail = SKNode()
        trail.zPosition = 15
        
        for i in 0..<3 {
            let dot = SKShapeNode(circleOfRadius: 2)
            dot.fillColor = SKColor.white.withAlphaComponent(0.5)
            dot.strokeColor = .clear
            dot.position = CGPoint(x: CGFloat(i) * -4, y: 0)
            trail.addChild(dot)
            
            dot.run(.sequence([
                .wait(forDuration: Double(i) * 0.05),
                .fadeOut(withDuration: 0.2)
            ]))
        }
        
        return trail
    }
    
    private func createShotTrail() -> SKNode {
        let trail = SKNode()
        trail.zPosition = 15
        
        for i in 0..<5 {
            let dot = SKShapeNode(circleOfRadius: CGFloat(3 - i / 2))
            dot.fillColor = SKColor.yellow.withAlphaComponent(0.6)
            dot.strokeColor = .clear
            dot.position = CGPoint(x: CGFloat(i) * -6, y: 0)
            trail.addChild(dot)
            
            dot.run(.sequence([
                .wait(forDuration: Double(i) * 0.03),
                .fadeOut(withDuration: 0.15)
            ]))
        }
        
        return trail
    }
    
    private func resetAfterGoal() {
        let f = fieldRect
        guard f.width > 0 else { return }
        
        moveBall(to: CGPoint(x: f.midX, y: f.midY), duration: 0.4)
        
        let homePos: [(CGFloat, CGFloat)] = [
            (0.12, 0.5), (0.28, 0.2), (0.28, 0.8), (0.42, 0.35), (0.42, 0.65)
        ]
        let awayPos: [(CGFloat, CGFloat)] = [
            (0.88, 0.5), (0.72, 0.2), (0.72, 0.8), (0.58, 0.35), (0.58, 0.65)
        ]
        
        for (i, pos) in homePos.enumerated() {
            guard i < homePlayers.count else { break }
            let p = CGPoint(x: f.minX + f.width * pos.0, y: f.minY + f.height * pos.1)
            let move = SKAction.move(to: p, duration: 0.5)
            move.timingMode = .easeInEaseOut
            homePlayers[i].run(move)
        }
        
        for (i, pos) in awayPos.enumerated() {
            guard i < awayPlayers.count else { break }
            let p = CGPoint(x: f.minX + f.width * pos.0, y: f.minY + f.height * pos.1)
            let move = SKAction.move(to: p, duration: 0.5)
            move.timingMode = .easeInEaseOut
            awayPlayers[i].run(move)
        }
    }
}
