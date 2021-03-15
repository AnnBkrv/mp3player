//
//  FolderPicker.swift
//  mp3_player
//
//  Created by Anna Bukreeva on 28.02.21.
//

import SwiftUI
import CoreServices


struct FolderPicker: UIViewControllerRepresentable {
    
//    @Binding var folderURL: String?
    @EnvironmentObject var store : MusicStore
    
    func makeCoordinator() -> Coordinator {
        return FolderPicker.Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<FolderPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.mp3, .folder])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<FolderPicker>) {}
    
    
    
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        var parent: FolderPicker
        
        init(parent: FolderPicker) {
            self.parent = parent
        }
        
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else {
                return
            }
            do{
                let destinationURL = parent.store.folderURL!.appendingPathComponent(url.lastPathComponent)
                url.startAccessingSecurityScopedResource()
                try FileManager.default.copyItem(at: url, to: destinationURL)
                url.stopAccessingSecurityScopedResource()
                parent.store.musicStore.append(MusicItem(path: destinationURL))
                print("File moved to the documents folder")
            }
            catch {
                print(error)
            }
            
            print(url)
        }
    }
}
