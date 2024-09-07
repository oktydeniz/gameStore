//
//  GameStore.swift
//  lists
//
//  Created by oktay on 30.08.2024.
//

import UIKit

class GameStore: ObservableObject{
    
    @Published var games:[Game] = []
    
    init(){
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveChanges),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveChanges),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
        
        do {
             let data = try Data(contentsOf: gameFileUrl)
            let decoder = PropertyListDecoder()
            let prev = try decoder.decode([Game].self, from: data)
            self.games = prev
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    @discardableResult func createGame() -> Game {
        let game = Game(random: true)
        games.append(game)
        return game
    }
    
    func delete(at indexSet: IndexSet){
        games.remove(atOffsets: indexSet)
    }
    
    func move(indices: IndexSet, to newOfset: Int){
        games.move(fromOffsets: indices, toOffset: newOfset)
    }
    
    func indexSet(for game:Game) ->IndexSet? {
        if let firstIndex = games.firstIndex(of: game){
            return IndexSet(integer: firstIndex)
        }else {
            return nil
        }
    }
    
    func game(at indexSet:IndexSet) -> Game? {
        if let first = indexSet.first {
            return games[first]
        }
        return nil
    }
    
    func update(g:Game, new:Game) {
        if let index = games.firstIndex(of: g) {
            games[index]=new
        }
    }
    
    @objc func saveChanges(){
        let encoder = PropertyListEncoder()
        do {
           let data = try encoder.encode(games)
            try data.write(to: gameFileUrl)
            print(gameFileUrl)
        }catch{
            print(error.localizedDescription)
        }
        
    }
    let gameFileUrl: URL = {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirector = docs.first!
        return documentDirector.appendingPathComponent("games.plist")
        
    }()
}
