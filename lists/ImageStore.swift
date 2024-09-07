//
//  ImageStore.swift
//  lists
//
//  Created by oktay on 6.09.2024.
//

import Foundation
import UIKit

class ImageStore : ObservableObject{
    
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key:String){
        cache.setObject(image, forKey: key as NSString)
        let data = image.jpegData(compressionQuality: 0.8)
        try? data?.write(to: gameImageUrl(forkey: key))
        
        objectWillChange.send()
    }
    
    func image(forkey:String) -> UIImage? {
        
        if let cachedObj =  cache.object(forKey: forkey as NSString){
            return cachedObj
        }
        do {
            let imageData = try Data(contentsOf: gameImageUrl(forkey: forkey))
            let image = UIImage(data: imageData)
            return image
        }catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func delete(forkey:String){
        cache.removeObject(forKey: forkey as NSString)
        try? FileManager.default.removeItem(at: gameImageUrl(forkey: forkey))
        objectWillChange.send()
    }
    
    func gameImageUrl(forkey key:String) -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirector = docs.first!
        return documentDirector.appendingPathComponent(key)
    }
}
