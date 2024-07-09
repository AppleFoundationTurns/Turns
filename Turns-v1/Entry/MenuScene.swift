//
//  EntryScene.swift
//  Turns-v1
//
//  Created by Giuseppe Damiata on 28/06/24.
//

import SpriteKit

class MenuScene: SKScene {
    
    let numClouds = 3
    let scaleVal: CGFloat = 1.0
    
    var playButton = SKSpriteNode(imageNamed: "HorizontalFrame")

    let reveal = SKTransition.reveal(with: .left, duration: 1)
    let nextScene = SKScene(fileNamed: "PlatformScene")
    
    override func didMove(to view: SKView) {
        
        let xSize = self.size.width
        let ySize = self.size.height
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        
        createClouds()
        
        let mountains = SKSpriteNode(imageNamed: "Mountains")
        mountains.name = "Mountains"
        mountains.size = CGSize(width: xSize, height: ySize)
        mountains.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mountains.position = CGPoint(x:0, y: 0)
        
        let logo = SKSpriteNode(imageNamed: "pixelLogo")
        logo.name = "Logo"
        logo.setScale(0.5)
        logo.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        logo.position = CGPoint(x: -xSize/5, y: 0)
        logo.colorBlendFactor = 0.3
        logo.color = .black
        
        let logoShadow = SKSpriteNode(imageNamed: "pixelLogo")
        logoShadow.name = "Logo"
        logoShadow.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        logoShadow.position = CGPoint(x: -5, y: 5)
        
        
        let logoText = SKLabelNode(fontNamed: "alagard")
        logoText.text = "TURNS"
        logoText.fontSize = 200
        logoText.position = CGPoint(x: 150, y: 160)
        logoText.fontColor = .systemRed
        logoText.zRotation = -0.4
        
        let textShadow = SKLabelNode(fontNamed: "alagard")
        textShadow.text = "TURNS"
        textShadow.fontSize = 200
        textShadow.position = CGPoint(x: 5, y: -5)
        textShadow.fontColor = .systemRed
        textShadow.colorBlendFactor = 0.5
        textShadow.color = .black
        //textShadow.zRotation = -0.4
        
        playButton.name = "Button_Frame"
        playButton.size = CGSize(width: 96*3, height: 32*3)
        playButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playButton.position = CGPoint(x: xSize/4, y: 0)
        playButton.colorBlendFactor = 0.5
        playButton.color = .white
        
        let playIcon = SKSpriteNode(imageNamed: "Play")
        playIcon.name = "Play_Button"
        playIcon.size = CGSize(width: 60, height: 60)
        playIcon.anchorPoint = CGPoint(x: 1, y: 0.5)
        playIcon.position = CGPoint(x: (90*3)/2, y: 0)
        
        let playLabel = SKLabelNode(fontNamed: "alagard")
        playLabel.text = "PLAY"
        playLabel.fontSize = 70
        playLabel.position = CGPoint(x: -30, y: -25)
        
        let playLabelShadow = SKLabelNode(fontNamed: "alagard")
        playLabelShadow.text = "PLAY"
        playLabelShadow.fontSize = 70
        playLabelShadow.position = CGPoint(x: -3, y: 3)
        playLabelShadow.fontColor = .black
        
        let playFrame = SKSpriteNode()
        playFrame.name = "Play_Frame"
        playFrame.color = .clear
        playFrame.size = CGSize(width: 100*3, height: 35*3)
        playFrame.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playFrame.position = CGPoint(x: 0, y: 0)
        
        self.addChild(mountains)
        self.addChild(logo)
        logo.addChild(logoShadow)
        logo.addChild(logoText)
        logoText.addChild(textShadow)
        self.addChild(playButton)
        playButton.addChild(playIcon)
        playButton.addChild(playLabel)
        playLabel.addChild(playLabelShadow)
        playButton.addChild(playFrame)
        
        nextScene?.size = CGSize(width: 1625, height: 750)
        nextScene?.scaleMode = .aspectFill
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveClouds()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        let node = self.atPoint(location!)
        if node.name == "Play_Frame" {
            playButton.color = .black
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        let node = self.atPoint(location!)
        if node.name == "Play_Frame" {
            scene?.view?.presentScene(nextScene!, transition: reveal)
        }
        playButton.color = .white
    }
    
    func createClouds() {
        for i in 0...numClouds {
            let cloud = SKSpriteNode(imageNamed: "cloudsFullScreen")
            cloud.name = "Cloud"
            cloud.size = CGSize(width: 1334, height: 750)
            cloud.setScale(scaleVal)
            cloud.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            cloud.position = CGPoint(x: CGFloat(i) * cloud.size.width, y: -50)
            
            self.addChild(cloud)
        }
    }
    
    func moveClouds() {
        self.enumerateChildNodes(withName: "Cloud", using: ({
            (node, error) in
            node.position.x -= 0.8
            
            if node.position.x < -((self.scene?.size.width)! * self.scaleVal) {
                node.position.x += (self.scene?.size.width)! * CGFloat(self.numClouds)
            }
        }))
    }
    
}
