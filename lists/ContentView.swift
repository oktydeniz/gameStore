//
//  ContentView.swift
//  lists
//
//  Created by oktay on 30.08.2024.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var gameStore = GameStore()
    
    @State var gameToDelete: Game?
    @ObservedObject var imageStore = ImageStore()
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(gameStore.games) {(g) in
                    NavigationLink(destination: DetailView(game: g, store: gameStore,
                                                           imgStore: imageStore, name: g.name, price: g.priceInDollar, selectedPhoto: imageStore.image(forkey: g.itemKey))){
                        GameListItem(g: g)
                    }
                    
                }
                .onDelete(perform: { indexSet in
                    //gameStore.delete(at: indexSet)
                    let game = gameStore.game(at: indexSet)
                    self.gameToDelete = game
                    if let gameToDelete = gameToDelete {
                        self.imageStore.delete(forkey: gameToDelete.itemKey)
                    }
                    
                    
                })
                .onMove(perform:  { indices, newOfset in
                    gameStore.move(indices: indices, to: newOfset)
                })
            }.navigationBarItems(leading: EditButton(), trailing: Button(action: {gameStore.createGame()}, label: {
                Text("Add")
            })).navigationBarTitleDisplayMode(.large)
                .listStyle(PlainListStyle())
                .navigationTitle("Used Game")
                .animation(.easeIn).actionSheet(item: $gameToDelete, content: {(game) -> ActionSheet in
                    ActionSheet(title: Text("Are You Sure?"), message: Text("You will Delete \(game.name)"), buttons: [
                        
                        ActionSheet.Button.cancel(),
                        .destructive(Text("Delete"), action: {
                            if let indexSet = gameStore.indexSet(for: game){
                                gameStore.delete(at: indexSet)
                            }
                        })
                    ])
                })
        }.accentColor(.purple)
    }
}

#Preview {
    ContentView()
}

struct GameListItem: View {
    
    var g: Game
    var formatter = AppFormatter.dollarFormatter
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4.0){
                Text(g.name).font(.body)
                Text(g.serialName).font(.caption).foregroundStyle(Color(white: 0.64))
            }
            Spacer()
            Text(NSNumber(value: g.priceInDollar), formatter: formatter).font(.title2)
                .foregroundStyle(Color(g.priceInDollar > 30 ? .blue : .gray)).animation(nil)
        }.padding(.vertical, 4)
    }
}
