//
//  audioPlayer.swift
//  mp3_player
//
//  Created by Anna Bukreeva on 18.01.21.
//

import SwiftUI
import AVFoundation
import UIKit
import MediaPlayer

class musicPlayer : ObservableObject {
    
    var action = MPMusicPlayerController.systemMusicPlayer
    var musicStore = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")
    @Published var playValue: TimeInterval = 0.0 // do i need this variable?
    
    var playing = false
    var playerDuration: TimeInterval = 146
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var index_n = 0
    var currentSelection : String?
    
    
    static let sharedInstance = musicPlayer() // guarantees that there is only one instance of player at the time
    // if you refer to this shared instance variable
//    singleton
    
//    init() {
//        currentSelection = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")[index_n]
//    }
    
//    init(musicStore : [String] = [""]){
//        self.musicStore = musicStore
//    }
    
//    func playAudioFile(_ index: Int) {
//        do {
//            musicPlayer.play()
//            if playing == true { // is this condition needed?
//                playing = false
////                stop the player somehow
//                action = nil
//            }
//            if playing == false {
//                index_n = index
//                currentSelection = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")[index_n]
//                print(index_n)
//                if (action == nil) {
//                    action = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicStore[index]))
//                    action!.numberOfLoops = 0
////                    action?.volume = 1
//                    action!.prepareToPlay()
//                    action!.play()
//                    playing = true
//                    playerDuration = action!.duration
//                }
//            }
//            if playing == false {
//                action!.play()
//                playing = true
//            }
//            print(URL(fileURLWithPath: musicStore[index_n]))
//        } catch {
//            print("Could not find and play the sound file.")
//        }
//    }
        

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //This delegate method will called once it finished playing audio file.
       //Here you can invoke your second file. You can declare counter variable
      //and increment it based on your file and stop playing your file acordingly.
//        counter = counter + 1
//        playAudioFile(counter)
   }


//    func pauseItem() {
//        if playing == true {
//            playing = false
//            action?.pause()
//        }
//    }
//
//    func stopSound() {
//            action?.stop()
//            action = nil
//            playing = false
//            playValue = 0.0
//        }
//
//    func skipForward(){
//        action!.currentTime += 15
//    }
//
//
//    func playNext(){
//        index_n += 1
//        if index_n == musicStore.count {
//            index_n = 0
//        }
//        playAudioFile(index_n)
//        currentSelection = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")[index_n]
//    }
//
//    func playPrevious(){
//        if action!.currentTime < 3 {
//            index_n -= 1
//            if index_n == -1 {
//                index_n = musicStore.count - 1
//            }
//            playAudioFile(index_n)
//            currentSelection = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")[index_n]
//        }
//        else {
//            action?.currentTime = 0.0
//        }
//    }
//
//    func skipBack(){
//        action!.currentTime -= 15
//    }
//
//    func changeSliderValue(_ setting :  String) { // current time and volume settings
//        if setting == "volume"{
//            action?.volume = Float(playValue)
//        }
//        if setting == "time" {
//            if playing {
//                pauseItem()
//                action?.currentTime = playValue
//            }
//            else {
//                action?.play()
//                playing = true
//            }}
//    }
    
//https://stackoverflow.com/questions/45270696/avaudioplayer-using-array-to-queue-audio-files-swift
}
