import UIKit
import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {
 
    @Binding var selectedImage: UIImage
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var store : MusicStore
    var item : MusicItem
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
 
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
 
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
 
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
 
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    final class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
       var parent: ImagePicker
    
       init(_ parent: ImagePicker) {
           self.parent = parent
       }
    
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
           if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               parent.selectedImage = image
               parent.store.changeArtwork(item: parent.item, image: image)
           }
    
           parent.presentationMode.wrappedValue.dismiss() // this dismisses the photo library view upon selection of an item
       }
   }
}



//https://www.appcoda.com/swiftui-camera-photo-library/
//just some people doing God's work. God bless you guys
