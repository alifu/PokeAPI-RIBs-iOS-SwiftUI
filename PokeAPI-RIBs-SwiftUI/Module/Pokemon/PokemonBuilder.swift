//
//  PokemonBuilder.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif Phincon on 16/09/25.
//

import RIBs

protocol PokemonInteractorDependency {
    // TODO: Declare the set of dependencies required by this RIB
    var pokemonNavigator: PokemonNavigator { get }
}

protocol PokemonDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PokemonComponent: Component<PokemonDependency>, PokemonDependency, PokemonInteractorDependency {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    var pokemonNavigator: PokemonNavigator

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
    init(dependency: PokemonDependency, results: [Pokedex.Result], startIndex: Int) {
        self.pokemonNavigator = PokemonNavigator(results: results, startIndex: startIndex)
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol PokemonBuildable: Buildable {
    func build(
        withListener listener: PokemonListener,
        results: [Pokedex.Result],
        startIndex: Int,
        repository: PokedexRepository,
        apiService: PokemonAPI
    ) -> PokemonRouting
}

final class PokemonBuilder: Builder<PokemonDependency>, PokemonBuildable {

    override init(dependency: PokemonDependency) {
        super.init(dependency: dependency)
    }

    func build(
        withListener listener: PokemonListener,
        results: [Pokedex.Result],
        startIndex: Int,
        repository: PokedexRepository,
        apiService: PokemonAPI
    ) -> PokemonRouting {
        let component = PokemonComponent(dependency: dependency, results: results, startIndex: startIndex)
        let viewController = PokemonViewController()
        let interactor = PokemonInteractor(
            presenter: viewController,
            dependency: component,
            repository: repository,
            apiService: apiService
        )
        interactor.listener = listener
        return PokemonRouter(interactor: interactor, viewController: viewController)
    }
}
