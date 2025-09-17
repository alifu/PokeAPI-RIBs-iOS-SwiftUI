//
//  MockPokedexObservableObject.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif on 16/09/25.
//

final class MockPokedexObservableObject: PokedexObservableObject {
    private weak var delegate: PokedexDelegate?
    override init(delegate: PokedexDelegate?) {
        self.delegate = delegate
        super.init(delegate: delegate)
        let data =  [
            Pokedex.Result(url: "", name: "Bulbasaur"),
            Pokedex.Result(url: "", name: "ivysaur")
        ]
        self.updatePokedex(with: data)
    }
}

final class MockPokedexView: PokedexDelegate {
    func selectedPokemon(with index: Int) { }
}
