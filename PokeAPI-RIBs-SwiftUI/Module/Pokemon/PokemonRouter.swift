//
//  PokemonRouter.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif Phincon on 16/09/25.
//

import RIBs

protocol PokemonInteractable: Interactable {
    var router: PokemonRouting? { get set }
    var listener: PokemonListener? { get set }
}

protocol PokemonViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class PokemonRouter: ViewableRouter<PokemonInteractable, PokemonViewControllable>, PokemonRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: PokemonInteractable, viewController: PokemonViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
