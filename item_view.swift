//
//  item_view.swift
//  mp3_player
//
//  Created by Anna Bukreeva on 20.01.21.
//

import SwiftUI

struct itemView : View {
    var currentSelection : String
//    var currentSelection : MusicItem
    var index : Int // maybe not necessary
    @State var showPlayer = false
    @EnvironmentObject var store : MusicStore
    
    
//    init(selection : MusicItem, index : Int){
//        self.currentSelection = selection
//        self.index = index
//    }
    
    init(selection : String, index : Int){
        self.currentSelection = selection
        self.index = index
    }
    
    var body : some View {
        Text(currentSelection)
            .onTapGesture {
                showPlayer = true
            }
            .sheet(isPresented: $showPlayer) {
                playerView(index: index, selection: currentSelection)
            }
    }
    
}
