//
//  PhotoPicker.swift
//  lists
//
//  Created by oktay on 5.09.2024.
//

import Foundation
import SwiftUI
import UIKit

struct PhotoPicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedPhoto: UIImage?
    var game:Game
    var imageStore:ImageStore
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoPicker>) -> some UIViewController {
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = true
        pickerController.delegate = context.coordinator
        pickerController.sourceType = sourceType
        return pickerController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var photoPicker: PhotoPicker
        
        init(_ picker: PhotoPicker) {
            self.photoPicker = picker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let selected = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                photoPicker.selectedPhoto = selected
               // photoPicker.imageStore.setImage(selected, forKey: photoPicker.game.itemKey)
                if picker.sourceType == .camera {
                    UIImageWriteToSavedPhotosAlbum(selected, self, #selector(img), nil)
                }
                
            }else {
                photoPicker.selectedPhoto = nil
            }
            picker.dismiss(animated: true, completion: nil)
        }
        
        @objc func img(_ image: UIImage?, error:Error?, contextInfo:UnsafeRawPointer){
            
        }
    }
    
}
