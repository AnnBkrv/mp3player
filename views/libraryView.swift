//
//  libraryView.swift
//  mp3_player
//
//  Created by Anna Bukreeva on 10.01.21.
//

import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers


struct libraryView: View {
    
    @State var filePicker : DocumentPicker
    @EnvironmentObject var store : MusicStore
    
    
    @State var showPlayer = false
    @State var confirmBackgroundPaste = false
    @State var showPicker = false
    @State var showItemEditView = false
    @State var plusButtonTapped = false
    
    @State private var selectedItem : MusicItem?
    
    @State private var searchText = ""
    
    
    @State var editMode = EditMode.inactive

    init() {
        _filePicker = State(initialValue: DocumentPicker({urls in
                        print(urls)
        }))
        UIBarButtonItem.appearance().tintColor = .red
        }

    
    
    var body: some View {
//        searchBar(text : $searchText)
            NavigationView {
                Color(.lightGray).ignoresSafeArea().overlay(
                    List{
//                    List(store.musicStore.filter { searchText.isEmpty ||
//                                                            $0.name.localizedStandardContains(searchText)
//                                                            || $0.artist.localizedStandardContains(searchText)
//                                                        })
                        searchBar(text : $searchText)
                        ForEach(store.musicStore
                                    .filter {
//                                        searchBar.text.isEmpty || $0.name.localizedStandardContains(searchBar.text) || $0.artist.localizedStandardContains(searchBar.text)
                                        searchText.isEmpty ||
                                        $0.name.localizedStandardContains(searchText) ||
                                        $0.artist.localizedStandardContains(searchText)
                                    }
                                , id: \.self)
                    { currentSelection in
                            NavigationLink(destination:
                                            itemView(selection: currentSelection)) {
                                ItemNavView(item : currentSelection)
                            }.simultaneousGesture(LongPressGesture().onEnded{ _ in
                                    print("Got Long Press")
                                selectedItem = currentSelection
                                print(selectedItem!.name)
                                showItemEditView = true
                            })
                    }
                        .onDelete { indexSet in
                            indexSet.map { store.musicStore[$0] }.forEach { item in
                                store.removeItem(item: item)
                            }}                    }
                        .sheet(isPresented: $showItemEditView, onDismiss : {showItemEditView = false}) {
                            if selectedItem != nil {
                                itemEditView(showItemEditView : $showItemEditView, musicItem : selectedItem!)}
                            }.environmentObject(store)
                )
                .navigationBarTitle("Library")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                                VStack {
                                    Text(audioPlayer.sharedInstance.currentSelection.name)
                                }.onTapGesture { showPlayer = true }
                                .sheet(isPresented: $showPlayer) {
                                    playerView(selection: audioPlayer.sharedInstance.currentSelection)}
                                .onDisappear { showPlayer = false }
                            }
                }
//                .navigationBarSearch($searchText)
                .navigationBarItems(leading: EditButton()
                , trailing: Button(action: {
                    plusButtonTapped = true
                }, label: {
                    Image(systemName: "plus").imageScale(.large)
                }).sheet(isPresented: $showPicker) {
                    FolderPicker().environmentObject(store)
                }
                .alert(isPresented: $confirmBackgroundPaste) {
                                        Alert(title: Text("Paste Background"),
                                              message: (UIPasteboard.general.contains(pasteboardTypes: [".mp3", ".m4a"]) ? Text("Add \(UIPasteboard.general.url?.absoluteString ?? "nothing") to the library?") : Text("Copy the url of an .mp3 to add it to the library.")),
                                                     primaryButton: .default(Text("OK")) {
                                                        if UIPasteboard.general.url != nil {
                                                            store.addItem(audioURL: UIPasteboard.general.url!)}
                                                     },secondaryButton: .cancel()
                                        )}
                )
            }
            .alert(isPresented : $plusButtonTapped){
                Alert(title : Text("File Import"),
                      message: Text("Import file from a URL or from the document browser?"),
                      primaryButton: .default(Text("URL")) {
                        confirmBackgroundPaste = true
                      },
                      secondaryButton: .default(Text("Browser")) {
                        showPicker = true
                      })
            }
                .onDisappear{confirmBackgroundPaste = false}
                .environmentObject(store)
                .environment(\.editMode, $editMode)
                .onAppear{selectedItem = store.musicStore[0]}
//            .overlay(
//                    ViewControllerResolver() { viewController in
//                        viewController.navigationItem.searchController =
//                            searchControllerProvider.searchController
//                    }
//                        .frame(width: 0, height: 0)
//                )
//            .add(self.searchBar)
    }
}


struct ItemNavView : View {
    let item: MusicItem

    var body: some View {
        HStack{
            Image(uiImage: UIImage(data: item.image.photo)!).resizable()
//                .aspectRatio(contentMode: .fit)
                .frame(width:50, height: 50)
            VStack(alignment : .leading) {
            Text(item.name).font(.callout)
            Text(item.artist).font(.footnote).opacity(0.7)
        }}
//        .navigationTitle(item.name)
    }
}


//search bars using UIKit in SwiftUI: http://blog.eppz.eu/swiftui-search-bar-in-the-navigation-bar/
// we are trying to add the seach bar using a single line of code. that can be accomplished if we directly apply the search bar modifier
// to the view controller. so the challenge is figuring out how to access the view controller of the LIST, to which we want to add a search bar.
