//
//  MenuScene.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 17/01/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class MenuScene: SKScene {
    var viewController: GameViewController!
    var bannerView: GADBannerView!
    
    /* UI Label */
    //var playLabel = SKLabelNode()
    //var settingLabel = SKLabelNode()
    //var instructLabel = SKLabelNode()
    
    /* Mode UI Label */
    //var easyLabel = SKLabelNode()
    //var hardLabel = SKLabelNode()
    var selectedDifficultyLabel = SKSpriteNode()
    
    /* Layer */
    var buttonLayer = SKNode()
    var instructionLayer = SKNode()
    
    /* Data */
    var difficulty: TimeInterval = Difficulty.easy
    var difficultyOptions: Array<SKNode> = []
    var instructions: Instruction?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        /* Configure and add background */
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        buttonLayer.zPosition = 10
        instructionLayer.zPosition = 20
        self.addChild(buttonLayer)
        self.addChild(instructionLayer)
        
        
        let easyLblPos = CGPoint(x: -self.frame.width / 4, y: 0)
        let easyLabel = TouchableLabel(text: "EASY", name: "Easy", pos: easyLblPos, layer: buttonLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 10, vertAlign: .center, horzAlign: .center)
        
        let hardLblPos = CGPoint(x: self.frame.width / 4, y: 0)
        let hardLabel = TouchableLabel(text: "HARD", name: "Hard", pos: hardLblPos, layer: buttonLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 10, vertAlign: .center, horzAlign: .center)
        
        difficultyOptions = [easyLabel.node, hardLabel.node]

        
        let playLblPos = CGPoint(x: 0, y: easyLabel.node.position.y + easyLabel.node.frame.height * 3)
        _ = TouchableLabel(text: "PLAY", name: "Play", pos: playLblPos, layer: buttonLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 10, vertAlign: .center, horzAlign: .center)
        
        let settingLblPos = CGPoint(x: 0, y: easyLabel.node.position.y - easyLabel.node.frame.height * 3)
        let settingLabel = TouchableLabel(text: "SETTING", name: "Setting", pos: settingLblPos, layer: buttonLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 10, vertAlign: .center, horzAlign: .center)

        let instructLblPos = CGPoint(x: 0, y: settingLabel.node.position.y - settingLabel.node.frame.height * 3)
        _ = TouchableLabel(text: "INSTRUCTION", name: "Instruction", pos: instructLblPos, layer: buttonLayer, fontName: "AvenirNext-Bold", fontSize: size.width / 10, vertAlign: .center, horzAlign: .center)
        
        instructionLayer.isHidden = true
        
        setDifficultyUI()
    }
    
    func setDifficultyUI() {
        let easyLabel = buttonLayer.childNode(withName: "Easy")!
        let difficultySelectorSize = CGSize(width: easyLabel.frame.width + 5, height: easyLabel.frame.height + 5)
        selectedDifficultyLabel = SKSpriteNode(color: UIColor.black, size: difficultySelectorSize)
        selectedDifficultyLabel.position = easyLabel.position
        self.addChild(selectedDifficultyLabel)
    }
    
    // MARK: - touch functions
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: buttonLayer)
        let touchedNode = buttonLayer.nodes(at: location).first
        
        if !instructionLayer.isHidden {
            handleTouchOnInstructLayer(touches: touches)
            return
        }
        
        if touchedNode == buttonLayer.childNode(withName: "Play") {
            let scene = GameScene(size: self.size, difficulty: difficulty)
            scene.interstitialDelegate = viewController
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            scene.size = skView.bounds.size
            skView.presentScene(scene)
            return
        }
        
        if touchedNode != nil && difficultyOptions.contains(touchedNode!) {
            setDifficulty(node: touchedNode!)
            return
        }
        if touchedNode == buttonLayer.childNode(withName: "Instruction") {
            handleTouchOnInstruct()
            return
        }
    }
    
    // MARK: - Touch
    
    func handleTouchOnInstruct() {
        instructions = Instruction()
        instructionLayer.isHidden = false
        
        let prevBtn = SKSpriteNode(color: UIColor.green, size: CGSize(width: 20, height: 20))
        let nextBtn = SKSpriteNode(color: UIColor.green, size: CGSize(width: 20, height: 20))
        let exitBtn = SKLabelNode(text: "Exit")
        
        prevBtn.position = CGPoint(x: -self.size.width / 3, y: 0)
        prevBtn.name = "PrevBtn"
        prevBtn.zPosition = instructionLayer.zPosition
        
        nextBtn.position = CGPoint(x: self.size.width / 3, y: 0)
        nextBtn.name = "NextBtn"
        nextBtn.zPosition = instructionLayer.zPosition

        
        exitBtn.position = CGPoint(x: 0, y: -self.size.height / 4)
        exitBtn.name = "Exit"
        
        instructionLayer.addChild(prevBtn)
        instructionLayer.addChild(nextBtn)
        instructionLayer.addChild(exitBtn)
        instructionLayer.addChild((instructions?.currentImageNode)!)

    }
    
    func handleTouchOnInstructLayer(touches: Set<UITouch>) {
        let touch = touches.first! as UITouch
        let location = touch.location(in: instructionLayer)
        let touchedNode = instructionLayer.nodes(at: location).first
        
        if touchedNode == instructionLayer.childNode(withName: "PrevBtn") {
            instructions?.setPrevTexture()
        }
        if touchedNode == instructionLayer.childNode(withName: "NextBtn") {
            instructions?.setNextTexture()
        }
        
        if touchedNode == instructionLayer.childNode(withName: "Exit") {
            instructionLayer.removeAllChildren()
            instructionLayer.isHidden = true
        }
    }
    
    // MARK: - Feature
    func setDifficulty(node: SKNode) {
        let easyLabel = buttonLayer.childNode(withName: "Easy")!
        let hardLabel = buttonLayer.childNode(withName: "Hard")!

        switch node {
        case easyLabel:
            difficulty = Difficulty.easy
            selectedDifficultyLabel.position = easyLabel.position
            selectedDifficultyLabel.size = CGSize(width: easyLabel.frame.width + 10, height: easyLabel.frame.height + 10)
        
        case hardLabel:
            difficulty = Difficulty.hard
            selectedDifficultyLabel.position = hardLabel.position
            selectedDifficultyLabel.size = CGSize(width: hardLabel.frame.width + 10, height: hardLabel.frame.height + 10)
        default: break
        }        
    }
    


}
