//
//  AudioManager.swift
//  Turns-v1
//
//  Created by Federico Agnello on 17/07/24.
//

import AVFoundation

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    var player: AVAudioPlayer?
    var isMusicPlaying = false
    var menuSoundName = "Menu2"
    var levelSoundName = "Level2"
    
    func playSound(named soundName: String, volume: Float = 0.09) {
        if !isMusicPlaying {
            isMusicPlaying = true
            guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
                print("Sound file not found")
                return
            }
            
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.numberOfLoops = -1 // Loop infinito
                player?.volume = volume
                player?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
    
    func stopSound() {
        player?.stop()
        isMusicPlaying = false
    }
}

