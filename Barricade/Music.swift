//
//  Music.swift
//  game_beaver_damm
//
//  Created by Minh Nguyen on 21/02/2017.
//  Copyright © 2017 Minh Nguyen. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit

enum Sounds: String {
    case playerMove = "playerMove"
    case click = "click" // "click"
    case newHighScore = "newHighScore"
}

class Music {
    
    static var isMute: Bool = false
    
    static func preloadSounds() {
        do {
            let sounds : Array<String> = ["click", "playerMove"]
            for sound in sounds {
                let path : String = Bundle.main.path(forResource: sound, ofType: "wav")!
                let url : URL = URL(fileURLWithPath: path)
                let player : AVAudioPlayer = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
            }
        } catch {
        }
    }
    
    
    static func toggleSound(scene: SKScene, layer: SKNode) {
        let muteNode = layer.childNode(withName: "Mute")! as! SKSpriteNode
        
        if isMute {
            muteNode.texture = SKTexture(imageNamed: "Unmute")
            isMute = false
        } else {
            muteNode.texture = SKTexture(imageNamed: "Mute")
            isMute = true
        }
    }
    
    static func playSound(scene: SKScene, sound: Sounds) {
        if !isMute {
            let filename = sound.rawValue
            let sound = SKAction.playSoundFileNamed(filename, waitForCompletion: false)
            scene.run(sound)
        }
    }
}
