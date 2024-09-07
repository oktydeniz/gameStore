//
//  Game.swift
//  lists
//
//  Created by oktay on 30.08.2024.
//

import Foundation

class Game: NSObject, Identifiable, Codable {
    var name:String
    var serialName:String
    var priceInDollar: Double
    var date:Date
    var itemKey: String = UUID().uuidString
    
    init(name: String, serialName: String, priceInDollar: Double) {
        self.name = name
        self.serialName = serialName
        self.priceInDollar = priceInDollar
        self.date = Date()
    }
    
    convenience init(random:Bool = false) {
        if random {
            let conditions = ["New", "Hint", "Used"]
            var idx = Int.random(in: 0..<conditions.count)
            let random = conditions[idx]
            
            let names = ["Resident Evil", "Gears of War", "Halo", "God of War"]
            idx = Int.random(in: 0..<names.count)
            let randomName = names[idx]
            
            idx = Int.random(in: 0..<6)
            let randomTitle = "\(random) \(randomName) \(idx)"
            
            let serial = UUID().uuidString.components(separatedBy: "-").first!
            
            let price = Double.random(in: 0...70)
            self.init(name: randomTitle, serialName:serial , priceInDollar: price)
        }else {
            self.init(name: "", serialName:"" , priceInDollar: 0)
        }
    }
}
