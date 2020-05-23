//
//  Sound constants.swift
//  Swift Mines for macOS
//
//  Created by Ben Leggiero on 2020-04-06.
//  Copyright © 2020 Ben Leggiero. All rights reserved.
//

import AVFoundation
import LazyContainers



/// One of the game's sound effects
public enum SoundEffect: CaseIterable {
    /// The sound that plays when you click a mine and it explodes
    case mineExplosion
}



public extension SoundEffect {
    /// Play this sound effect as soon as possible
    func play() {
        audioPlayer?.play()
    }
}



fileprivate extension SoundEffect {
    /// A way to have a compile-time guarantee that all sound effect properties are initialized properly, and also not
    /// have to `switch` over every sound effect any time one of its properties is needed
    private static let properties = [SoundEffect : Properties](uniqueKeysWithValues:
        Self.allCases.map { ($0, $0.generateProperties()) }
    )
    
    
    /// Generates and returns all the properties for this sound effect.
    /// - Returns: All the properties for this sound effect.
    private func generateProperties() -> Properties {
        switch self {
        case .mineExplosion:
            return Properties(
                resourceNameWithoutExtension: "Mine Explosion",
                audioPlayer: Lazy { self.generateNewAudioPlayer() }
            )
        }
    }
    
    
    /// Generates and returns a new audio player for this sound effect
    /// - Returns: A new audio player for this sound effect
    private func generateNewAudioPlayer() -> AVAudioPlayer? {
        guard
            let soundUrl = Bundle.main.url(forResource: resourceNameWithoutExtension, withExtension: "mp3"),
            let soundData = try? Data(contentsOf: soundUrl, options: Data.ReadingOptions.mappedIfSafe),
            let player = try? AVAudioPlayer(data: soundData, fileTypeHint: AVFileType.mp3.rawValue)
            else
        {
            return nil
        }
        
        player.prepareToPlay()
        return player
    }
    
    
    /// The name of the resource, minus its extension (like "Mine Explosion", rather than "Mine Explosion.mp3")
    var resourceNameWithoutExtension: String {
        Self.properties[self]!.resourceNameWithoutExtension //! This is guaranteed to be here thanks to the switch statement in `properties()`
    }
    
    
    /// The audio player for this sound effect
    var audioPlayer: AVAudioPlayer? {
        Self.properties[self]!.audioPlayer.wrappedValue //! This is guaranteed to be here thanks to the switch statement in `properties()`
    }
    
    
    
    /// The properties of a sound effect
    struct Properties {
        /// The name of the resource, minus its extension (like "Mine Explosion", rather than "Mine Explosion.mp3")
        let resourceNameWithoutExtension: String
        
        /// The lazy-created audio player for this sound effect
        let audioPlayer: Lazy<AVAudioPlayer?>
    }
}
