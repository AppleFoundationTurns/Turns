//
//  TutorialScene.swift
//  EndGame
//
//  Created by Paolosalvatore Piazza 10/07/24.
//

import Foundation
import SpriteKit


class TutorialScene: SKScene {
    
    var bottoneAvvio: SKSpriteNode!
    var viewModel: ViewModel = ViewModel(mpcInterface: MPCInterface())
    
    override func didMove(to view: SKView) {
        // --- ViewModel Initialization ---
        viewModel = ViewModelInjected.viewModel as! ViewModel
        
        self.backgroundColor = .clear
        view.allowsTransparency = true
        
        
        let table = SKSpriteNode(color: .clear, size: CGSize(width: 1334, height: 750))
        table.zPosition = 11
        //table.alpha = 0.5
        scene?.addChild(table)
        
        let complimenti = SKLabelNode(fontNamed: "ArcadeClassic")
        complimenti.text = "Tu toria l:"
        complimenti.fontSize = 90
        complimenti.fontColor = .black
        complimenti.position = CGPoint(x: 0, y: 240)
        table.addChild(complimenti)
        
        let complimenti_shadow = SKLabelNode(fontNamed: "ArcadeClassic")
        complimenti_shadow.text = "Tu toria l:"
        complimenti_shadow.colorBlendFactor = 0
        complimenti_shadow.fontColor = SKColor(hex: "#EF8540")
        complimenti_shadow.fontSize = 90
        complimenti_shadow.position = CGPoint(x: 0, y: 5)
        complimenti.addChild(complimenti_shadow)
        
        let intro1 = SKLabelNode(fontNamed: "ArcadeClassic")
        intro1.text = "Oh  NO!"
        intro1.fontSize = 65
        intro1.position = CGPoint(x: -550, y: 130)
        table.addChild(intro1)
        
        
        //IMMAGINE ANIMATA FIAMMELLA
        let fiamma = SKSpriteNode(imageNamed: "flame1")
        fiamma.texture?.filteringMode = .nearest
        fiamma.position = CGPoint(x: -400, y: 150)
        fiamma.scale(to: CGSize(width: 80, height: 80))
        let f1 = SKTexture(imageNamed: "flame1")
        f1.filteringMode = .nearest
        let f2 = SKTexture(imageNamed: "flame2")
        f2.filteringMode = .nearest
        //ANIMAZIONE
        let action = SKAction.animate(with: [f1, f2], timePerFrame: 0.5)
        fiamma.run(SKAction.repeatForever(action))
        table.addChild(fiamma)
        
        
        let intro2 = SKLabelNode(fontNamed: "ArcadeClassic")
        intro2.text = "is  playing  around  in  the  forest"
        intro2.fontSize = 65
        intro2.position = CGPoint(x: 150, y: 130)
        table.addChild(intro2)
        
        let intro3 = SKLabelNode(fontNamed: "ArcadeClassic")
        intro3.text = "Catch  it  before  it  accidentally  burns  everything!"
        intro3.fontSize = 50
        intro3.position = CGPoint(x: 0, y: 60)
        intro3.fontColor = SKColor(hex: "#EF8540")
        table.addChild(intro3)
        
        
        let blueGuy = SKSpriteNode(imageNamed: "dudeBlue")
        blueGuy.texture?.filteringMode = .nearest
        blueGuy.position = CGPoint(x: -525, y: 10)
        blueGuy.scale(to: CGSize(width: 80, height: 80))
        table.addChild(blueGuy)
        

        
        let scrittablu1 = SKLabelNode(fontNamed: "ArcadeClassic")
        scrittablu1.text = "Can  only  jump  on"
        scrittablu1.fontSize = 60
        scrittablu1.position = CGPoint(x: -250, y: -20)
        table.addChild(scrittablu1)
        
        
        let panel1 = SKSpriteNode(imageNamed: "blueCentral")
        panel1.texture?.filteringMode = .nearest
        panel1.position = CGPoint(x: 70, y: 0)
        panel1.scale(to: CGSize(width: 100, height: 30))
        table.addChild(panel1)
        
        
        let scrittablu2 = SKLabelNode(fontNamed: "ArcadeClassic")
        scrittablu2.text = "and  collect"
        scrittablu2.fontSize = 60
        scrittablu2.position = CGPoint(x: 325, y: -20)
        table.addChild(scrittablu2)
        
        
        let blueFruit = SKSpriteNode(imageNamed: "blueFruit")
        blueFruit.texture?.filteringMode = .nearest
        blueFruit.position = CGPoint(x: 525, y: 0)
        blueFruit.scale(to: CGSize(width: 50, height: 50))
        table.addChild(blueFruit)
        
        
       let orangeGuy = SKSpriteNode(imageNamed: "dudeOrange")
        orangeGuy.texture?.filteringMode = .nearest
        orangeGuy.position = CGPoint(x: -525, y: -60)
        orangeGuy.scale(to: CGSize(width: 80, height: 80))
        table.addChild(orangeGuy)
        

        
       let scrittaArancio1 = SKLabelNode(fontNamed: "ArcadeClassic")
        scrittaArancio1.text = "Can  only  jump  on"
        scrittaArancio1.fontSize = 60
        scrittaArancio1.position = CGPoint(x: -250, y: -90)
        table.addChild(scrittaArancio1)
        
        
        let panel2 = SKSpriteNode(imageNamed: "orangeCentral")
        panel2.texture?.filteringMode = .nearest
        panel2.position = CGPoint(x: 70, y: -70)
        panel2.scale(to: CGSize(width: 100, height: 30))
        table.addChild(panel2)
        
        
        let scrittaArancio2 = SKLabelNode(fontNamed: "ArcadeClassic")
        scrittaArancio2.text = "and  collect"
        scrittaArancio2.fontSize = 60
        scrittaArancio2.position = CGPoint(x: 325, y: -90)
        table.addChild(scrittaArancio2)
        
        
        let orangeFruit = SKSpriteNode(imageNamed: "orangeFruit")
        orangeFruit.texture?.filteringMode = .nearest
        orangeFruit.position = CGPoint(x: 525, y: -70)
        orangeFruit.scale(to: CGSize(width: 50, height: 50))
        table.addChild(orangeFruit)
        
        
        
        
        let scrittaTurn1 = SKLabelNode(fontNamed: "ArcadeClassic")
        scrittaTurn1.text = "Use"
        scrittaTurn1.fontSize = 60
        scrittaTurn1.position = CGPoint(x: -500, y: -180)
         table.addChild(scrittaTurn1)
        
        
        let turn = SKSpriteNode(imageNamed: "orangeSwitchButt")
        turn.texture?.filteringMode = .nearest
        turn.position = CGPoint(x: -400, y: -160)
        turn.scale(to: CGSize(width: 80, height: 80))
        let t1 = SKTexture(imageNamed: "orangeSwitchButt")
        t1.filteringMode = .nearest
        let t2 = SKTexture(imageNamed: "blueSwitchButt")
        t2.filteringMode = .nearest
        //ANIMAZIONE
        let actionT = SKAction.animate(with: [t1, t2], timePerFrame: 0.5)
        turn.run(SKAction.repeatForever(actionT))
        table.addChild(turn)
        
        
        let scrittaTurn2 = SKLabelNode(fontNamed: "ArcadeClassic")
        scrittaTurn2.text = "to  give  the  control  to  your  buddy"
        scrittaTurn2.fontSize = 60
        scrittaTurn2.position = CGPoint(x: 150, y: -180)
         table.addChild(scrittaTurn2)
        
        let blackBackGround = SKSpriteNode(color: .black, size: CGSize(width: 1334, height: 750))
        blackBackGround.alpha = 0.9
        blackBackGround.position = CGPoint(x: -1334/2, y: -750/2)
        blackBackGround.anchorPoint = CGPoint(x: 0, y: 0)
        blackBackGround.zPosition = 10
        scene?.addChild(blackBackGround)
        
        let bottoneAvvio = SKSpriteNode(imageNamed: "bottone")
        bottoneAvvio.texture?.filteringMode = .nearest
        bottoneAvvio.position = CGPoint(x: 0, y: -270)
        bottoneAvvio.scale(to: CGSize(width: 300, height: 80))
        bottoneAvvio.name = "bottoneAvvio"
        table.addChild(bottoneAvvio)
        
        
        let start = SKLabelNode(fontNamed: "ArcadeClassic")
        start.text = "Start"
        start.fontSize = 60
        start.position = CGPoint(x: -40, y: -290)
        start.fontColor = .white
        table.addChild(start)
        
        
        let play = SKSpriteNode(imageNamed: "Play")
        play.texture?.filteringMode = .nearest
        play.position = CGPoint(x: 80, y: -270)
        play.scale(to: CGSize(width: 70, height: 70))
        table.addChild(play)
        
        
        table.setScale(0.8)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodesAtLocation = self.nodes(at: location)
            
            for node in nodesAtLocation {
                if node.name == "bottoneAvvio" {
                    viewModel.appState.isTutorialShown = false
                }
            }
        }
    }
}

