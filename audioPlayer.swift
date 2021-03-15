//
//  audioPlayer.swift
//  mp3_player
//
//  Created by Anna Bukreeva on 10.01.21.
//

import SwiftUI
import AVFoundation
import UIKit

class audioPlayer : ObservableObject {
    
    var action : AVAudioPlayer?
    var currentSelection : MusicItem
    var store = MusicStore()
    
    
    
    @Published var playValue: TimeInterval = 0.0
    @Published var volumeValue : Float = 1.0
    
    var playing = false
    var playerDuration: TimeInterval = 146
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var index_n = 0
    
    
    static let sharedInstance = audioPlayer() // guarantees that there is only one instance of player at the time
    // if you refer to this shared instance variable
//    singleton

    
    init(_ currentSelection : MusicItem = MusicItem.init(path: URL(fileURLWithPath : Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")[0]))) {
        self.currentSelection = currentSelection
    }
    
    
    func playAudioFile(_ selection : MusicItem) {
        do {
            do {
                  try AVAudioSession.sharedInstance().setCategory(.playback) // makes the songs play even if silent mode is on
                currentSelection = selection
               } catch(let error) {
                   print(error.localizedDescription)
               }
            if playing { // is this condition needed?
                playing = false
//                stop the player somehow
                action = nil
            }
            if !playing {
                if (action == nil) {
                    action = try AVAudioPlayer(contentsOf: currentSelection.path)
                    action!.numberOfLoops = 0
                    action?.volume = 1
                    action!.prepareToPlay()
                    action!.play()
                    playing = true
                    playerDuration = action!.duration
                }
            }
            if !playing {
                action!.play()
                playing = true
            }
        } catch {
            print("Could not find and play the sound file.")
        }
    }
        

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //This delegate method will called once it finished playing audio file.
       //Here you can invoke your second file. You can declare counter variable
      //and increment it based on your file and stop playing your file acordingly.
//        counter = counter + 1
//        playAudioFile(counter)
   }


    func pauseItem() {
        if playing == true {
            playing = false
            action?.pause()
        }
    }
    
    func stopSound() {
            action?.stop()
            action = nil
            playing = false
            playValue = 0.0
        }
    
    func skipForward(){
        let wishTime = action!.currentTime + 15
        let currentDuration = action!.duration
        if wishTime < currentDuration {
            action!.currentTime += 15 }
        else {
            playNext()
            action?.currentTime = wishTime - currentDuration
        }
    }
    
    
    func playNext(){
        index_n = store.musicStore.firstIndex(of : currentSelection)!
        index_n += 1
        
        if index_n == store.musicStore.count {
            index_n = 0
        }
        
        currentSelection = store.musicStore[index_n]
        playAudioFile(currentSelection)
    }
    
    func playPrevious(){
//        if action!.currentTime < 3 {
            index_n = store.musicStore.firstIndex(of : currentSelection)!
            index_n -= 1
            if index_n == -1 {
                index_n = store.musicStore.count - 1
            }
            currentSelection = store.musicStore[index_n]
            playAudioFile(currentSelection)
//        }
//        else {
//            action?.currentTime = 0.0
//        }
    }
    
    func skipBack(){
        let wishTime = action!.currentTime - 15
        if wishTime > 15 {
            action!.currentTime -= 15 }
        else {
            playPrevious()
            action!.currentTime = action!.duration + wishTime // +  wishTime cause it's negative
        }
//        action!.currentTime -= 15
    }
    
    func changeSliderValue(_ setting :  String) { // current time and volume settings
        if setting == "volume"{
            action!.volume = Float(volumeValue)
        }
        if setting == "time" {
            if playing {
                pauseItem()
                action!.currentTime = playValue
            }
            else {
                action!.play()
                playing = true
            }}
    }
    
//https://stackoverflow.com/questions/45270696/avaudioplayer-using-array-to-queue-audio-files-swift
}
