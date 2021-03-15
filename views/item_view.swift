//
//  item_view.swift
//  mp3_player
//
//  Created by Anna Bukreeva on 20.01.21.
//

import SwiftUI

struct itemView : View {
    var currentSelection : MusicItem
    @State var showPlayer = false
    @EnvironmentObject var store : MusicStore
    
    
    init(selection : MusicItem){
        self.currentSelection = selection
    }
    
    var body : some View {
        NavigationView{
            VStack{
                Image(uiImage : UIImage(data: currentSelection.image.photo)!).resizable().frame(width : 200, height : 200)
                Text(currentSelection.name).frame(alignment : .center)
                        .onTapGesture {
                            showPlayer = true
                        }
                        .sheet(isPresented: $showPlayer) {
                            playerView(selection: currentSelection)
                        }
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                                    VStack {
                                        Text(audioPlayer.sharedInstance.currentSelection.name)
                                    }.onTapGesture { showPlayer = true }
                                    .sheet(isPresented: $showPlayer) {
                                        playerView(selection: audioPlayer.sharedInstance.currentSelection)}
                                    .onDisappear{ showPlayer = false }
                                }
                }}
        }}
    
    
    
    
}


