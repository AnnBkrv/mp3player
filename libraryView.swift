//
//  libraryView.swift
//  mp3_player
//
//  Created by Anna Bukreeva on 10.01.21.
//

import SwiftUI

struct libraryView: View {
    
    var musicStore = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")
    @EnvironmentObject var store : MusicStore
    
    init() {
        UIBarButtonItem.appearance().tintColor = .red
//        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: UIFont.familyNames[1], size: 18)!]
//        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Hiragino Maru Gothic ProN", size: 18)!]
//            UITableView.appearance().separatorStyle = .none
//            UITableViewCell.appearance().backgroundColor = .green
//            UITableView.appearance().backgroundColor = .green
//        print(UIFont.familyNames)
        }
    
//    var body: some View {
//
//        NavigationView {
//            Color(.lightGray).ignoresSafeArea().overlay(
//                List{
//                    ForEach(store.musicStore, id: \.self) { currentSelection in
//                        let indexLib = store.musicStore.firstIndex(of: currentSelection)
//                        let sel = String(URL(fileURLWithPath: currentSelection.name).deletingPathExtension().lastPathComponent)
//                        NavigationLink(destination:
//                                        itemView(selection: sel, index: indexLib ?? 0) //currentSelection instead of sel
//                        ){
//                            Text(URL(fileURLWithPath: currentSelection.name).deletingPathExtension().lastPathComponent)}
//                    }
//                }).navigationBarTitle("Library")
//        }
//    }
    
    var body: some View {
        
        NavigationView {
            Color(.lightGray).ignoresSafeArea().overlay(
                List{
                    ForEach(musicStore, id: \.self) { currentSelection in
                        let indexLib = musicStore.firstIndex(of: currentSelection)
                        let sel = String(URL(fileURLWithPath: currentSelection).deletingPathExtension().lastPathComponent)
                        NavigationLink(destination:
                                        itemView(selection: sel, index: indexLib ?? 0) //currentSelection instead of sel
                        ){
                            Text(URL(fileURLWithPath: currentSelection).deletingPathExtension().lastPathComponent)}
                    }
                }).navigationBarTitle("Library")
        }
    }

    
}

// add edit mode and delete mode
