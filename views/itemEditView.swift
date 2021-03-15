//
//  itemEditView.swift
//  mp3_player
//
//  Created by Anna Bukreeva on 01.03.21.
//

import SwiftUI
import UIKit

enum ActiveAlert {
    case first, second
}

struct itemEditView : View {
    
    
    @Binding var showItemEditView : Bool
    @State var musicItem : MusicItem
    @State var songName = ""
    @EnvironmentObject var store : MusicStore
    @State var artistName = ""
    
    @State var musicItemsArtwork = UIImage()
    
    @State private var image = UIImage() // image from the library
    
    @State var artworkAddButtonTapped = false
    
    @State var showPhotoLib = false
    
    @State private var activeAlert: ActiveAlert = .first

    
    var body: some View {
        
        
//        GeometryReader { geometry in
            TextField(musicItem.name, text : $songName, onEditingChanged: { began in
                if !began{
                    store.changeName(item : musicItem, name : songName)
                }
            }
            ).autocapitalization(.none)
            .disableAutocorrection(true)
            
            TextField("Artist Name", text : $artistName, onEditingChanged: { began in
                if !began{
                    store.changeArtist(item : musicItem, name : artistName)
                }
            }).autocapitalization(.none)
            .disableAutocorrection(true)
            Image(uiImage : musicItemsArtwork).resizable().frame(width : 150, height : 150) // should update upon change.
    //        replacing with state doesn't help
                Button(action: {    //print(UIPasteboard.general.types)
                    artworkAddButtonTapped = true
                            }, label : {
                                Image(systemName: "doc.on.clipboard").imageScale(.large)
                                    .alert(isPresented: $artworkAddButtonTapped) {
    //                                    activeAlert = .first
                                        switch activeAlert {
                                            case .first :

                                                return Alert(title : Text("Artwork Import"),
                                                      message: Text("Import the artwork from a URL or from your photo library?"),
                                                      primaryButton: .default(Text("URL")) {
                                                        DispatchQueue.main.async { //.MARK: THIS MAKES EVERYTHING WORK; THIS IS CRUCIAL
                                                            showAlert(.second)
                                                        }
                                                      },
                                                      secondaryButton: .default(Text("Photo Library")) {
                                                        showPhotoLib = true
                                                      })
                                            case .second:
                                                return Alert(title: Text("Paste Background"),
                                                      message: (UIPasteboard.general.contains(pasteboardTypes: ["public.jpeg", "public.png"]) ? Text("Add \(UIPasteboard.general.url?.absoluteString ?? "nothing") as artwork?") : Text("Copy the url of an image file to add it as artwork.")),
                                                             primaryButton: .default(Text("OK")) {
                                                                if UIPasteboard.general.url != nil{
                                                                    DispatchQueue.global().async { [self] in
                                                                                if let data = try? Data(contentsOf: UIPasteboard.general.url!) {
                                                                                    if let image = UIImage(data: data) {
                                                                                        DispatchQueue.main.async {
                                                                                            store.changeArtwork(item : musicItem, image : image)
                                                                                        }}}
                                                                        
                                                                        musicItemsArtwork = UIImage(data: musicItem.image.photo)!
                                                                        activeAlert = .first
                                                                    }
                                                                     }
                                                             },secondaryButton: .cancel() {activeAlert = .first}
                                                )
                                        }
                                    }
                            }).sheet(isPresented: $showPhotoLib) {
                                ImagePicker(selectedImage : self.$image, item : musicItem, sourceType: .photoLibrary).environmentObject(store)
                            }
            .onAppear() {
                songName = musicItem.name
                artistName = musicItem.artist
                musicItemsArtwork = UIImage(data: musicItem.image.photo)!
            } //}
    }
    
    func showAlert(_ active: ActiveAlert) -> Void {
            DispatchQueue.global().async {
                activeAlert = active
                artworkAddButtonTapped = true
            }
        }
    
    
    
}



