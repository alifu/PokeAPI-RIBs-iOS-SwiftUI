//
//  PokedexBuilder.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif on 15/09/25.
//

import RIBs

protocol PokedexDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class PokedexComponent: Component<PokedexDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol PokedexBuildable: Buildable {
    func build(withListener listener: PokedexListener) -> PokedexRouting
}

final class PokedexBuilder: Builder<PokedexDependency>, PokedexBuildable {

    override init(dependency: PokedexDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: PokedexListener) -> PokedexRouting {
        let component = PokedexComponent(dependency: dependency)
        let viewController = PokedexViewController()
        let interactor = PokedexInteractor(
            presenter: viewController,
            repository: RealmService.shared,
            apiService: APIManager.shared
        )
        let pokemonBuilder = PokemonBuilder(dependency: component)
        interactor.listener = listener
        return PokedexRouter(
            interactor: interactor,
            viewController: viewController,
            pokemonBuilder: pokemonBuilder
        )
    }
}
