//
//  DocumentPicker.swift
//  mp3_player
//
//  Created by Anna Bukreeva on 24.02.21.
//

import Foundation
import SwiftUI
import MobileCoreServices
import AVFoundation

/// A wrapper for a UIDocumentPickerViewController that acts as a delegate and passes the selected file to a callback
///
/// DocumentPicker also sets allowsMultipleSelection to `false`.
final class DocumentPicker: NSObject, ObservableObject {
    
    @EnvironmentObject var store : MusicStore

    /// The types of documents to show in the picker
    let types: [String]
    @State var picked = false
    @State var audioFile : Data? = nil

    /// The callback to call with the selected document URLs
    let callback: ([URL]) -> ()
    
    var audioURLs : URL? = nil

    /// Should the user be allowed to select more than one item?
    let allowsMultipleSelection: Bool

    /// Creates a DocumentPicker, defaulting to selecting folders and allowing only one selection
    init(for types: [String] = [String(kUTTypeFolder), String(kUTTypeMP3)],
         allowsMultipleSelection: Bool = false,
         _ callback: @escaping ([URL]) -> () = { _ in }) {
        self.types = types
        self.allowsMultipleSelection = allowsMultipleSelection
        self.callback = callback
    }

    /// Returns the view controller that must be presented to display the picker
    lazy var viewController: UIDocumentPickerViewController = {
        let vc = UIDocumentPickerViewController(documentTypes: types, in: .import)
        vc.delegate = self
        vc.allowsMultipleSelection = self.allowsMultipleSelection
        return vc
    }()
}

extension DocumentPicker: UIDocumentPickerDelegate {
    /// Delegate method that's called when the user selects one or more documents or folders
    ///
    /// This method calls the provided callback with the URLs of the selected documents or folders.
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // here you need to import the selected file into the app. only if it's an mp3
        callback(urls)
        if let url = urls.first{
//            urls.first?.lastPathComponent
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            do{
                let filePath = try FileManager.default.contentsOfDirectory(at: url.deletingLastPathComponent(), includingPropertiesForKeys: nil, options: [])[0]
                print("Here are all the files: \(filePath)")
                audioFile = try Data(contentsOf: filePath)
//                let destinationURL = store.folderURL!.appendingPathComponent(filePath.lastPathComponent)
//                try FileManager.default.moveItem(at: filePath, to: destinationURL)
//                print("File moved to documents folder")
            }
            catch {
                print(error)
            }
            print("This is the path: \(path)")
//            print(audioURLs)
//            do {
//                // after downloading your file you need to move it to your destination url
////                let file = try FileManager.default.contents(atPath: url.path)
//                let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            } catch {
//                print(error)
//            }
        }
        picked = true
    }

    /// Delegate method that's called when the user cancels or otherwise dismisses the picker
    ///
    /// Does nothing but close the picker.
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
        print("cancelled")
    }
}
