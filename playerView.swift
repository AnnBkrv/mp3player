//
//  ContentView.swift
//  mp3_player
//
//  Created by Anna Bukreeva on 01.12.20.
//

import SwiftUI
import AVFoundation
import UIKit
import MediaPlayer
import Sliders

struct playerView: View {
    var libraryName = ""
//    var libraryName : MusicItem // if this works, refactor later into current selection
//    var displayName : String
    @ObservedObject var player = audioPlayer.sharedInstance
    var index : Int
    var musicStore = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")
    @State private var playButton: Image = Image(systemName: "play.fill")
    
    @EnvironmentObject var store : MusicStore
    
//    init(index : Int = 0, selection : MusicItem) {
////        self._index = State(initialValue: index)
//        self.index = index
////        player.playAudioFile(self.index)
////        currentSelection = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")[self.index]
//        self.libraryName = selection
//        displayName = libraryName.name
//
//    }
    
    
    init(index : Int = 0, selection : String) {
        self.index = index
//        player.playAudioFile(self.index)
//        currentSelection = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")[self.index]
        self.libraryName = selection
//        displayName = libraryName.name

    }
    
//    mutating func playNext(){
//        let currentIndex = store.musicStore.firstIndex(of : libraryName)!
//        var nextIndex = currentIndex + 1
//        nextIndex = store.musicStore.indices.contains(nextIndex) ? nextIndex : 0
//        libraryName = store.musicStore[nextIndex]
//
//        displayName = prettifyName(name : libraryName.name)
//        player.playNext()
//        // doesn't freaking work. self is immutable. what. what. what.
//    }
    
    mutating func playPrevious(){
        // change the library name?
//        libraryName = prettifyName(name : musicStore[index - 1])
//        index -= 1
//        player.playPrevious()
    }
    
    
    
    func prettifyName(name  : String) -> String {
        return String(URL(fileURLWithPath: name).deletingPathExtension().lastPathComponent)
    }
  
    
    
    
    var body: some View {
        Color(.lightGray).ignoresSafeArea().overlay(
            VStack{
                Spacer().frame(minHeight: 50, maxHeight: 100)
                Image(uiImage : (UIImage(named: "blank-itunes-artwork")!)).resizable().aspectRatio(contentMode: .fit)
                Text(URL(fileURLWithPath: player.playing ? libraryName : player.currentSelection ?? libraryName).deletingPathExtension().lastPathComponent)
    //                this should actually be in the panel below the views. this text should show the name of the song
//                    we navigated from. and if play has been pressed, then it should show player.currentSelection
                    .padding()
                HStack{
                    Spacer()
                    Button(action: {
                        player.playPrevious()
                        print("play the previous song")
                    }, label: {
                        Image(systemName: "backward.fill").imageScale(.large).foregroundColor(Color(.black))
                    }).padding(.leading)
                    Button(action: {
                        player.skipBack()
                    }, label: {
                        Image(systemName: "gobackward.15").imageScale(.large).foregroundColor(Color(.black))
                    }).padding(.leading).padding(.trailing)
                    HStack{
                        Spacer()
                        Button(action: {
                            if (player.playing == false) {
                                    playButton = Image(systemName: "pause.fill")
                                    player.playAudioFile(index)
                                    player.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                                    
                                } else {
                                    player.pauseItem()
                                    playButton = Image(systemName: "play.fill")
                                }
                        }) {
                                playButton
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 44))
                        }//.padding(.trailing)
                        Button(action: {
                                        player.stopSound()
                                        playButton = Image(systemName: "play.fill")
                                        player.playValue = 0.0
                                        
                        }) {
                                        Image(systemName: "stop.fill")
                                            .foregroundColor(Color.white)
                                            .font(.system(size: 44))
                        }//.padding(6)
                        Spacer()
                        
                    }
                    Button(action: {
                        player.skipForward()
                    }, label: {
                        Image(systemName: "goforward.15").imageScale(.large).foregroundColor(Color(.black))
                    }).padding(.leading).padding(.trailing)
                    Button(action: {
                        player.playNext()
                        // find a way to initialize the index variable. it needs to be a state variable
                        // change the current selection variable. text showing the name of the current
//                        selection should change automatically
                        print("play the next song")
//                    change name
                    }, label: {
                        Image(systemName: "forward.fill").imageScale(.large).foregroundColor(Color(.black))
                    }).padding(.trailing)
                    Spacer()
                }    // buttons
                VStack{
                    // if currentSelection == player.currentSelection, then this. otherwise the slider shouldn't be active
//                    otherwise display duration
                    ValueSlider(value: $player.playValue, in: TimeInterval(0.0)...player.playerDuration, onEditingChanged: { _ in
                                player.changeSliderValue("time")
                    })
                    .valueSliderStyle(
                        HorizontalValueSliderStyle(track:
                                                    HorizontalRangeTrack(
                                                        view: Capsule().foregroundColor(.red)
                                                    ).frame(height : 8)
                                                    .background(Capsule().foregroundColor(Color.red.opacity(0.25)))
                                                   , thumbSize: CGSize(width: 16, height: 32)))
                    .padding(.leading).padding(.trailing)
                    .isHidden(libraryName != prettifyName(name: player.currentSelection ?? libraryName), remove: libraryName != prettifyName(name: player.currentSelection ?? libraryName))
                        .onReceive(player.timer) { _ in
                            if player.playing {
                                if let currentTime = player.action?.currentTime {
                                    player.playValue = currentTime
                                    if currentTime == TimeInterval(0.0) {
                                        player.playing = false
                                    }
                                }
                            }
                            else {
                                player.playing = false
                                player.timer.upstream.connect().cancel()
                            }
                        }
                        HStack{
                            Text((player.action?.currentTime ?? 0).stringFromTimeInterval()).padding(.leading).font(.system(size: 13))
                            Spacer()
                            Text((player.playerDuration - (player.action?.currentTime ?? 0)).stringFromTimeInterval()).padding().font(.system(size: 13))
                        }.isHidden(libraryName != prettifyName(name: player.currentSelection ?? libraryName), remove: libraryName != prettifyName(name: player.currentSelection ?? libraryName))
                            
                    
                    // the volume slider
//                    ValueSlider(value: $player.action.volume, in: 0.0 ... 1.0, onEditingChanged: { _ in
//                                player.changeSliderValue("volume")
//                    })
//                        .onReceive(player.timer) { _ in
//                            if player.playing {
//                                if let currentVolume = player.action?.volume {
//                                    player.action?.volume = currentVolume
//                                }
//                            }
//                            else {
//                                player.playing = false
//                                player.timer.upstream.connect().cancel() // what does this do?
//                            }}
                }
                
            }
            // slider and time
            
            
        )}
    
    
    
    
    }
//make the pause button change to play button and vice versa automatically
//https://stackoverflow.com/questions/63324235/updating-slider-value-in-real-time-avaudioplayer-swiftui


