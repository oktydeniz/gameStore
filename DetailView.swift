//
//  DetailView.swift
//  lists
//
//  Created by oktay on 5.09.2024.
//

import SwiftUI
import Combine

struct DetailView: View {
    
    var game : Game
    var store: GameStore
    var imgStore:ImageStore
    @State var name: String = ""
    @State var price : Double = 0.0
    @State var enableActionSave : Bool = true
    @State var isPhotoPickerPresenting: Bool = false
    @State var isPhotoPickerActionSheetPresenting: Bool = false
    @State var selectedPhoto: UIImage?
    @State var sourceType :UIImagePickerController.SourceType = .photoLibrary
    
    func validate(){
        let isPhotoUpdated = imgStore.image(forkey: game.itemKey) == selectedPhoto
        
        enableActionSave = game.name != self.name || game.priceInDollar != self.price || isPhotoUpdated
    }
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 6.0) {
                    Text("Name")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onReceive(Just(name), perform: { _ in
                            validate()
                        })
                }.padding(.vertical, 4.0)
                
                VStack(alignment: .leading, spacing: 6.0) {
                    Text("Price in Dollar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Price", value: $price, formatter: AppFormatter.dollarFormatter)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .onReceive(Just(price), perform: { _ in
                            validate()
                        })
                }.padding(.vertical, 4.0)
            }
            
            if let selectedPhoto = selectedPhoto {
                Section(header: Text("Image")) {
                    Image(uiImage: selectedPhoto)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.vertical)
                        .overlay(Button(action: {
                            self.selectedPhoto = nil
                            imgStore.delete(forkey: game.itemKey)
                        }, label: {
                            
                            Color.white
                                .frame(width: 40, height: 40)
                            overlay(Image(systemName: "trash"))
                        }), alignment: .topTrailing)
                }
            }
            Section {
                Button(action: {
                    let newGame = Game(name: name, serialName: game.serialName, priceInDollar: price)
                    store.update(g: game, new: newGame)
                    if let selectedPhoto = selectedPhoto {
                        imgStore.setImage(selectedPhoto, forKey: game.itemKey)
                    }else {
                        imgStore.delete(forkey: game.itemKey)
                    }
                }, label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50.0)
                }).disabled(!enableActionSave)
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        isPhotoPickerActionSheetPresenting = true
                    }else {
                        isPhotoPickerPresenting = true
                    }
                    
                }, label: {
                    Image(systemName: "camera")
                })
            }
        }
        .accentColor(.blue)
        .actionSheet(isPresented: $isPhotoPickerActionSheetPresenting, content: {
            createActionSheet()
        })
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isPhotoPickerPresenting) {
            PhotoPicker(sourceType:sourceType, selectedPhoto: $selectedPhoto, game: game, imageStore: imgStore).onReceive(Just(selectedPhoto)){ newValue in
                validate()
            }
        }
    }
    
    func createActionSheet() -> ActionSheet {
        
        var buttons:[ActionSheet.Button] = [
            .cancel()
        ]
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            buttons.append(.default(Text("Camera"), action: {
                sourceType = .camera
                isPhotoPickerPresenting = true
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            buttons.append(.default(Text("Photo Library"), action: {
                sourceType = .photoLibrary
                isPhotoPickerPresenting = true
            }))
        }
        return ActionSheet(title: Text("Please select a source"), message: nil, buttons: buttons)
    }
}
