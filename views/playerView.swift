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
    var currentSelection : MusicItem
    @EnvironmentObject var store : MusicStore
    @ObservedObject var player = audioPlayer.sharedInstance
    @State private var playButton: Image = Image(systemName: "pause.fill")
  
    init(selection : MusicItem) {
        self.currentSelection = selection
        player.playAudioFile(self.currentSelection)
    }
    
    var body: some View {
        
        Color(.lightGray).ignoresSafeArea().overlay(
            VStack{
                Spacer().frame(minHeight: 50, maxHeight: 100)
                Image(uiImage : UIImage(data: player.currentSelection.image.photo)!).resizable().aspectRatio(contentMode: .fit)
                Text(player.currentSelection.name)
                    .padding()
                HStack{
                    Spacer()
                    Button(action: {
                        player.playPrevious()
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
                                player.playAudioFile(player.currentSelection)
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
                        
                    } // play/ pause and stop buttons
                    Button(action: {
                        player.skipForward()
                    }, label: {
                        Image(systemName: "goforward.15").imageScale(.large).foregroundColor(Color(.black))
                    }).padding(.leading).padding(.trailing)
                    Button(action: {
                        player.playNext()
                    }, label: {
                        Image(systemName: "forward.fill").imageScale(.large).foregroundColor(Color(.black))
                    }).padding(.trailing)
                    Spacer()
                } // buttons
                Spacer().frame(minHeight: 20, maxHeight: 50)
                VStack(spacing : 50){
                    // playback slider
                    VStack(spacing : 15){
                        Slider(value: $player.playValue, in: TimeInterval(0.0)...player.playerDuration, onEditingChanged: { _ in
                                    player.changeSliderValue("time")
                        }).accentColor(.red)
//                        .valueSliderStyle(
//                            HorizontalValueSliderStyle(track:
//                                                        HorizontalRangeTrack(
//                                                            view: Capsule().foregroundColor(.red)
//                                                        ).frame(height : 8)
//                                                        .background(Capsule().foregroundColor(Color.red.opacity(0.25)))
//                                                       , thumbSize: CGSize(width: 16, height: 32)))
                        .padding(.leading).padding(.trailing)
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
                            Text((player.action?.currentTime ?? 0).stringFromTimeInterval()).font(.system(size: 13))
                            Spacer()
                            Text((player.playerDuration - (player.action?.currentTime ?? 0)).stringFromTimeInterval()).font(.system(size: 13))
                        }.padding(.leading).padding(.trailing)
                    }
                    // volume slider
                    VStack(spacing : 15){
                        Slider(value: $player.volumeValue, in: 0.0 ... 1.0, onEditingChanged: { _ in
                                    player.changeSliderValue("volume")
                        }).padding(.leading).padding(.trailing).accentColor(.red)
                            .onReceive(player.timer) { _ in
                                if player.playing {
                                    if let currentVolume = player.action?.volume {
                                        player.action?.volume = currentVolume
                                    }
                                }
                                else {
                                    player.playing = false
                                    player.timer.upstream.connect().cancel() // what does this do?
                                }}
                        HStack {
                            Image(systemName: "speaker.fill")
                            Spacer()
                            Image(systemName: "speaker.2.fill")
                            Spacer()
                            Image(systemName: "speaker.3.fill")
                        }.padding(.leading).padding(.trailing).padding(.bottom)
                          .foregroundColor(.black)
                    }
                }} // sliders
        ).onAppear{ player.store = self.store }}
    }
//make the pause button change to play button and vice versa automatically
//https://stackoverflow.com/questions/63324235/updating-slider-value-in-real-time-avaudioplayer-swiftui

