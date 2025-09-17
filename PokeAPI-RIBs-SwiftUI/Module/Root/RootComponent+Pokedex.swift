//
//  RootComponent+Pokedex.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif on 15/09/25.
//

import RIBs

/// The dependencies needed from the parent scope of Root to provide for the Pokedex scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol RootDependencyPokedex: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Root to provide dependencies
    // for the Pokedex scope.
}

extension RootComponent: PokedexDependency {

    // TODO: Implement properties to provide for Pokedex scope.
}
