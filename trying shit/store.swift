//
//  store.swift
//  mp3_player
//
//  Created by Anna Bukreeva on 25.12.20.
//


import SwiftUI
import AVFoundation
import Combine
import MobileCoreServices

class MusicStore : ObservableObject {
    

    private var autosave : AnyCancellable?
    @Published var musicStore = [MusicItem]()
    
    
//        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
    var folderURL : URL?
    
    
    //    var musicStore = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
    
    var paths = Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: "")
    
    init(named name: String = "Music"){
        let defaultsKey = "mp3-player.\(name)"
        let data = UserDefaults.standard.data(forKey: defaultsKey)
        
        if data != nil, let newStoredItems = try? JSONDecoder().decode([MusicItem].self, from: data!) {
            musicStore = newStoredItems
        }
        else{
            for item in paths {
                musicStore.append(MusicItem(path: URL(fileURLWithPath : item)))
            }}
        
        
        do{
            self.folderURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )} catch(let error) {
               print(error.localizedDescription)
        }
        
        autosave = $musicStore.sink { items in // sink -> do this when the publisher changes. sink is a subscriber to the publisher. the publisher is any var with $ in front of it, timer's publish(every:), NotificationCenter's publisher(for:)...
            let jsonData = try! JSONEncoder().encode(items)
            UserDefaults.standard.set(jsonData, forKey: defaultsKey)
        }
    }
    
    func addItem(audioURL : URL) {
        print("Here's the last path component of the audio URL: \(audioURL.lastPathComponent)")
        let destinationURL = folderURL!.appendingPathComponent(audioURL.lastPathComponent)
            // you can use NSURLSession.sharedSession to download the data asynchronously
        URLSession.shared.downloadTask(with: audioURL) { location, response, error in
            guard let location = location, error == nil else { return }
            do {
                // after downloading your file you need to move it to your destination url
                try FileManager.default.moveItem(at: location, to: destinationURL)
                print("File moved to documents folder")
                print(destinationURL)
            } catch {
                print(error)
            }
        }.resume()
        musicStore.append(MusicItem(path: destinationURL))
    }
    
    
    func removeItem(item: MusicItem) {
        musicStore = musicStore.filter { $0 != item }
        do {
            try FileManager.default.removeItem(at : item.path)
            print("success") // this removes the actual song. but what if i have added artwork?
        }
        catch{
            print(error)
        }
    }
    
    func changeName(item : MusicItem, name : String){
        if let index = musicStore.firstIndex(where: {$0 == item}) {
            musicStore[index].name = name
        }
    }
    
    func changeArtwork(item : MusicItem, image : UIImage){
        if let index = musicStore.firstIndex(where: {$0 == item}) {
            musicStore[index].image = CodableImage(photo: image)
        }
    }
    
    func changeArtist(item : MusicItem, name : String){
        if let index = musicStore.firstIndex(where: {$0 == item}) {
            musicStore[index].artist = name
        }
    }
    
    
}


struct Playlist : Identifiable, Hashable{
    var playlist : [MusicItem]
    var name : String
    var id : UUID
    
    init(playlist : [MusicItem], name : String = "New Playlist"){
         self.playlist = playlist
         self.name = name
         self.id = UUID()
    }
    
    mutating func addItem(item : MusicItem, playlist : [MusicItem]){
        self.playlist.append(item)
    }
    
    mutating func removeItem(item : MusicItem, playlist : [MusicItem]){
        let index = playlist.firstIndex(of : item)!
        self.playlist.remove(at: index) //  maybe will delete the wrong item
    }
    
    
    
    
}

public struct CodableImage: Codable, Hashable, Identifiable {

    public let photo: Data
    public var id : UUID
    
    public init(photo: UIImage) {
        self.photo = photo.pngData()!
        self.id = UUID()
    }
}

struct MusicItem : Identifiable, Hashable, Codable {
//    var item : AVFileType
    var path : URL
    var name : String
    var id: UUID
//    var image : UIImage
    var image : CodableImage
    var artist : String
    
    
    init(path : URL, name: String? = nil, image : UIImage = UIImage(named: "blank-itunes-artwork")!, artist : String = ""){
        self.path = path
//        self.name = name ?? String(URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent)
        self.name = name ?? String(path.deletingPathExtension().lastPathComponent)
        self.image = CodableImage(photo: image)
        self.id = UUID()
        self.artist = artist
    }

//    var jsonToDo: Data? {
//        try? JSONEncoder().encode(self)
//
//    }
    
}
