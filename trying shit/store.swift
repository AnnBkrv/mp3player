//
//  store.swift
//  mp3_player
//
//  Created by Anna Bukreeva on 25.12.20.
//

//
//  todo_model.swift
//  to-do-list-again
//
//  Created by Anna Bukreeva on 23.10.20.
//

import SwiftUI
import Combine

class MusicStore : ObservableObject {
    
    private var autosave : AnyCancellable?
    @Published var musicStore = [MusicItem]()
    var paths = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")
    
    init(){
        for item in paths {
            musicStore.append(MusicItem(path: item))
        }
    }
    
    func addItemToStore(item : MusicItem){
        musicStore.append(item)
    }
    
    func createPlaylist(){}
    
    }

struct MusicItem : Identifiable, Hashable {
    var path : String
    var name : String
    var id: UUID
    var image : UIImage
    
    init(path : String, name: String? = nil, image : UIImage = UIImage(named: "blank-itunes-artwork")!){
        self.path = path
        self.name = name ?? String(URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent)
        self.image = image
        self.id = UUID()
    }
    
    mutating func changeName(newName : String){
        self.name = newName
        
    }
    
//    var jsonToDo: Data? {
//        try? JSONEncoder().encode(self)
//
//    }
    
}
