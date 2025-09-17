//
//  PokemonInteractor.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif on 16/09/25.
//

import RIBs
import RxCocoa
import RxSwift

protocol PokemonRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol PokemonPresentable: Presentable {
    var listener: PokemonPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func updatePokemonInfo(_ data: PokemonInfoWrapper)
    func updatePokemonDescription(_ description: String)
}

protocol PokemonListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func goBackFromPokemon()
}

final class PokemonInteractor: PresentableInteractor<PokemonPresentable>, PokemonInteractable, PokemonPresentableListener {

    weak var router: PokemonRouting?
    weak var listener: PokemonListener?
    
    private let repository: PokedexRepository
    private let apiService: PokemonAPI
    
    private let dependency: PokemonInteractorDependency
    private let isLoading = PublishRelay<Bool>()

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: PokemonPresentable,
        dependency: PokemonInteractorDependency,
        repository: PokedexRepository,
        apiService: PokemonAPI
    ) {
        self.dependency = dependency
        self.repository = repository
        self.apiService = apiService
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchPokemon()
        self.fetchPokemonSpecies()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func fetchPokemon() {
        guard let `nameRequest` = dependency.pokemonNavigator.currentRelay.value?.name else { return }
        isLoading.accept(true)
        if let pokemon = repository.getPokemon(withName: `nameRequest`) {
            let rawAbilities = Array(pokemon.abilities.map {
                String($0.name)
            })
            let rawImageURL = pokemon.spritesOther?.officialArtwork ?? ""
            let rawStats = Array(pokemon.stats.map { result in
                Pokemon.Stats(
                    baseStat: result.baseStat,
                    effort: result.effort,
                    stat: Pokemon.StatsInfo(name: result.stat, url: "")
                )
            })
            let rawTypes = Array(pokemon.types.map { result in
                String(result.type)
            })
            let rawHeight = pokemon.height
            let rawWeight = pokemon.weight
            let idRaw = pokemon.idPokemon
            let rawName = pokemon.name
            
            let pokemonInfoWrapper = PokemonInfoWrapper(
                id: idRaw,
                banner: rawImageURL,
                name: rawName,
                abilities: rawAbilities,
                stats: rawStats,
                types: rawTypes,
                height: rawHeight,
                weight: rawWeight)
            self.presenter.updatePokemonInfo(pokemonInfoWrapper)
            isLoading.accept(false)
        } else {
            apiService.fetchPokemon(name: `nameRequest`)
                .subscribe(
                    onSuccess: { [weak self] response in
                        guard let `self` = self else { return }
                        defer { self.isLoading.accept(false) }
                        
                        let rawAbilities = response.abilities
                        let rawSprites = response.sprites
                        let rawStats = response.stats
                        let rawTypes = response.types
                        let rawHeight = response.height
                        let rawWeight = response.weight
                        let rawName = response.name
                        let rawId = response.id
                        
                        let abilitiesString = rawAbilities.map { $0.ability.name }
                        let rawTypesString = rawTypes.map { $0.type.name }
                        
                        let pokemonInfoWrapper = PokemonInfoWrapper(
                            id: rawId,
                            banner: rawSprites.other.officialArtwork.frontDefault,
                            name: rawName,
                            abilities: abilitiesString,
                            stats: rawStats,
                            types: rawTypesString,
                            height: Double(rawHeight),
                            weight: Double(rawWeight))
                        self.presenter.updatePokemonInfo(pokemonInfoWrapper)
                        
                        repository.storePokemon(
                            id: rawId,
                            name: rawName,
                            abilities: rawAbilities,
                            spritesOther: rawSprites,
                            types: rawTypes,
                            weight: rawWeight,
                            height: rawHeight,
                            stats: rawStats
                        )
                    },
                    onFailure: { [weak self] error in
                        guard let `self` = self else { return }
                        self.isLoading.accept(false)
                        print("❌ API Error:", error)
                    }
                )
                .disposeOnDeactivate(interactor: self)
        }
    }
    
    func fetchPokemonSpecies() {
        guard let `name` = dependency.pokemonNavigator.currentRelay.value?.name else { return }
        isLoading.accept(true)
        if let pokemon = repository.getPokemonSpecies(withName: name) {
            let rawAbout = pokemon.flavourTextEntries.first?.flavourText ?? ""
            isLoading.accept(false)
            self.presenter.updatePokemonDescription(rawAbout.replacingOccurrences(of: "\n", with: " "))
        } else {
            apiService.fetchPokemonSpecies(name: name)
                .subscribe(
                    onSuccess: { [weak self] response in
                        guard let `self` = self else { return }
                        defer { self.isLoading.accept(false) }
                        
                        let resultAbout = response.flavorTextEntries.first?.flavourText ?? ""
                        
                        let rawAbout = resultAbout.replacingOccurrences(of: "\n", with: " ")
                        self.presenter.updatePokemonDescription(rawAbout)
                        
                        repository.storePokemonSpecies(name: name, flavourTextEntries: response.flavorTextEntries)
                    },
                    onFailure: { [weak self] error in
                        guard let `self` = self else { return }
                        self.isLoading.accept(false)
                        print("❌ API Error:", error)
                    }
                )
                .disposeOnDeactivate(interactor: self)
        }
    }
    
    func navigateToPreviousPokemon() {
        dependency.pokemonNavigator.movePrevious()
        fetchPokemon()
        fetchPokemonSpecies()
    }
    
    func navigateToNextPokemon() {
        dependency.pokemonNavigator.moveNext()
        fetchPokemon()
        fetchPokemonSpecies()
    }
    
    func goBack() {
        self.listener?.goBackFromPokemon()
    }
}
