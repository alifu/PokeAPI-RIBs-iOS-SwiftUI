//
//  PokedexRouter.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif on 15/09/25.
//

import RIBs

protocol PokedexInteractable: Interactable, PokemonListener {
    var router: PokedexRouting? { get set }
    var listener: PokedexListener? { get set }
}

protocol PokedexViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func openPokemonPage(viewController: ViewControllable?)
}

final class PokedexRouter: ViewableRouter<PokedexInteractable, PokedexViewControllable>, PokedexRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(
        interactor: PokedexInteractable,
        viewController: PokedexViewControllable,
        pokemonBuilder: PokemonBuildable
    ) {
        self.pokemonBuilder = pokemonBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func openPokemon(_ pokedex: [Pokedex.Result], withSelectedId id: Int, repository: PokedexRepository, apiService: PokemonAPI) {
        let pokemonRouter = pokemonBuilder.build(
            withListener: interactor,
            results: pokedex,
            startIndex: id,
            repository: repository,
            apiService: apiService
        )
        self.pokemon = pokemonRouter
        attachChild(pokemonRouter)
        viewController.openPokemonPage(viewController: pokemon?.viewControllable)
    }
    
    func detachPokemon() {
        if let detach = pokemon {
            detachChild(detach)
            pokemon = nil
        }
    }
    
    // MARK: - Private
    
    private let pokemonBuilder: PokemonBuildable
    private var pokemon: PokemonRouting?
}
