//
//  FinalScene.swift
//  EndGame
//
//  Created by Alberto Scannaliato on 10/07/24.
//

import Foundation
import SpriteKit

extension SKColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        assert(hexString.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

class FinalScene: SKScene {
    
    var resultsRendered:Bool = false
    
    var viewModel: ViewModel = ViewModel(mpcInterface: MPCInterface())
    
    override func didMove(to view: SKView) {
        // --- ViewModel Initialization ---
        viewModel = ViewModelInjected.viewModel as! ViewModel
        
        self.backgroundColor = .clear
        view.allowsTransparency = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if viewModel.appState.isCompletedLevel && !resultsRendered {
            var blueFruits:[Bool] = viewModel.currentState.collectables[0].collectables
            var orangeFruits:[Bool] = viewModel.currentState.collectables[1].collectables
            
            let tableBase = SKSpriteNode(color: .black, size: CGSize(width: 850, height: 680))
            tableBase.alpha = 0.6
            tableBase.zPosition = 11
            self.addChild(tableBase)
            
            let table = SKSpriteNode(color: .black, size: CGSize(width: 850, height: 680))
            table.alpha = 1
            table.zPosition = 1
            self.addChild(table)
            
            let complimenti = SKLabelNode(fontNamed: "ArcadeClassic")
            complimenti.text = "CONGRATULATIONS !"
            complimenti.fontSize = 90
            complimenti.fontColor = .black
            complimenti.position = CGPoint(x: 0, y: 240)
            complimenti.zPosition = 15
            table.addChild(complimenti)
            
            let complimenti_shadow = SKLabelNode(fontNamed: "ArcadeClassic")
            complimenti_shadow.text = "CONGRATU LATIONS !"
            complimenti_shadow.colorBlendFactor = 0
            //complimenti_shadow.fontColor = SKColor(hex: "#3174B5")
            complimenti_shadow.fontSize = 90
            complimenti_shadow.position = CGPoint(x: 0, y: 5)
            complimenti.addChild(complimenti_shadow)
            
            let stats1 = SKLabelNode(fontNamed: "ArcadeClassic")
            stats1.text = "Co llected  fruit:"
            stats1.fontSize = 65
            stats1.position = CGPoint(x: -150, y: 130)
            stats1.zPosition = 15
            table.addChild(stats1)
            
            //uso array di esempio per verificare il corretto funzionamento di spawnFruit
            let fruitB = spawnFruit(fruits: blueFruits, name: "blueFruit", xPos: -325, yPos: 90)
            for fruitBlu in fruitB {
                fruitBlu.zPosition = 15
                table.addChild(fruitBlu)
            }
            
            //uso array di esempio per verificare il corretto funzionamento di spawnFruit
            let fruit = spawnFruit(fruits: orangeFruits, name: "orangeFruit", xPos: -325, yPos: 30)
            for fruitOrange in fruit {
                fruitOrange.zPosition = 15
                table.addChild(fruitOrange)
            }
            
            let hasFlame = SKLabelNode(fontNamed: "ArcadeClassic")
            hasFlame.text = ("Flame  rescued !")
            hasFlame.fontSize = 65
            hasFlame.position = CGPoint(x: -80, y: -100)
            hasFlame.zPosition = 15
            table.addChild(hasFlame)
            
            /*let stats2 = SKLabelNode(fontNamed: "ArcadeClassic")
             stats2.text = ("Time:")
             stats2.fontSize = 65
             stats2.position = CGPoint(x: -285, y: -290)
             table.addChild(stats2)
             
             let time = SKLabelNode(fontNamed: "ArcadeClassic")
             time.text = "00.00"
             time.fontSize = 100
             time.position = CGPoint(x: 0, y: -300)
             table.addChild(time) */
            
            
            let star_shadow = SKSpriteNode(imageNamed: "Star")
            star_shadow.texture?.filteringMode = .nearest
            star_shadow.color = .black
            star_shadow.colorBlendFactor = 100
            star_shadow.size = CGSize(width: 250, height: 250)
            star_shadow.position = CGPoint(x: -390, y: -350)
            star_shadow.anchorPoint = CGPoint(x: 0, y: 0)
            star_shadow.zPosition = 15
            table.addChild(star_shadow)
            
            let star = SKSpriteNode(imageNamed: "Star")
            star.texture?.filteringMode = .nearest
            star.size = CGSize(width: 175, height: 175)
            star.anchorPoint = CGPoint(x: -0.22, y: -0.22)
            star.zPosition = 16
            star_shadow.addChild(star)
            
            let star_shadow2 = SKSpriteNode(imageNamed: "Star")
            star_shadow2.texture?.filteringMode = .nearest
            star_shadow2.color = .black
            star_shadow2.colorBlendFactor = 100
            star_shadow2.size = CGSize(width: 250, height: 250)
            star_shadow2.position = CGPoint(x: -125, y: -350)
            star_shadow2.anchorPoint = CGPoint(x: 0, y: 0)
            star_shadow2.zPosition = 15
            table.addChild(star_shadow2)
            
            //uso array di prova per verificare il corretto funzionamento di calculateTotalFruit
            let star2 = SKSpriteNode(imageNamed: "Star")
            star2.texture?.filteringMode = .nearest
            star2.size = CGSize(width: 175, height: 175)
            star2.anchorPoint = CGPoint(x: -0.22, y: -0.22)
            star2.isHidden = !calculateTotalFruit(fruitBlue: blueFruits, fruitOrange: orangeFruits, confront: 3)
            star2.zPosition = 16
            star_shadow2.addChild(star2)
            
            let star_shadow3 = SKSpriteNode(imageNamed: "Star")
            star_shadow3.texture?.filteringMode = .nearest
            star_shadow3.color = .black
            star_shadow3.colorBlendFactor = 100
            star_shadow3.size = CGSize(width: 250, height: 250)
            star_shadow3.position = CGPoint(x: 140, y: -350)
            star_shadow3.anchorPoint = CGPoint(x: 0, y: 0)
            star_shadow3.zPosition = 15
            table.addChild(star_shadow3)
            
            //uso array di prova per verificare il corretto funzionamento di calculateTotalFruit
            let star3 = SKSpriteNode(imageNamed: "Star")
            star3.texture?.filteringMode = .nearest
            star3.size = CGSize(width: 175, height: 175)
            star3.anchorPoint = CGPoint(x: -0.22, y: -0.22)
            star3.isHidden = !calculateTotalFruit(fruitBlue: blueFruits, fruitOrange: orangeFruits, confront: 6)
            star3.zPosition = 16
            star_shadow3.addChild(star3)
            
            let blackBackGround = SKSpriteNode(imageNamed: "colorfulBackground")
            blackBackGround.texture?.filteringMode = .nearest
            blackBackGround.size = CGSize(width: 1334, height: 750)
            
            blackBackGround.position = CGPoint(x: -1334/2, y: -750/2)
            blackBackGround.anchorPoint = CGPoint(x: 0, y: 0)
            blackBackGround.zPosition = 10
            self.addChild(blackBackGround)
            
            table.setScale(0.8)
            tableBase.setScale(0.8)

            
            resultsRendered = true
        }
        
    }
    
    func spawnFruit(fruits:[Bool], name:String, xPos:Double, yPos:Double) -> [SKSpriteNode] {
        var allFruit:[SKSpriteNode] = []
        var plusxPos:Double = 0
        for frutta in fruits {
            let fruit = SKSpriteNode(imageNamed: name)
            fruit.color = .black
            if !frutta {
                fruit.colorBlendFactor = 1
            }
            fruit.texture?.filteringMode = .nearest
            fruit.size = CGSize(width: 50, height: 50)
            fruit.position = CGPoint(x: xPos + plusxPos, y: yPos)
            fruit.anchorPoint = CGPoint(x: 0, y: 0.5)
            allFruit.append(fruit)
            plusxPos += 75
        }
        
        return allFruit
    }
    
    func calculateTotalFruit(fruitBlue:[Bool], fruitOrange:[Bool], confront:Int) -> Bool {
        var total:Int = 0
        var isVisible:Bool = false
        
        for blue in fruitBlue {
            if blue {
                total += 1
            }
        }
        
        for orange in fruitOrange {
            if orange {
                total += 1
            }
        }
        
        if total >= confront {
            isVisible = true
            
            return isVisible
        }
        
        return isVisible
    }
}
