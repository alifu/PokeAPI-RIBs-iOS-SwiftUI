//
//  PokedexInteractor.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif on 15/09/25.
//

import RIBs
import RxCocoa
import RxSwift

protocol PokedexRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func openPokemon(_ pokedex: [Pokedex.Result], withSelectedId id: Int, repository: PokedexRepository, apiService: PokemonAPI)
    func detachPokemon()
}

protocol PokedexPresentable: Presentable {
    var listener: PokedexPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func updatePokedex(_ pokedex: [Pokedex.Result])
}

protocol PokedexListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class PokedexInteractor: PresentableInteractor<PokedexPresentable>, PokedexInteractable, PokedexPresentableListener {
    
    weak var router: PokedexRouting?
    weak var listener: PokedexListener?
    
    private let repository: PokedexRepository
    private let apiService: PokemonAPI
    
    private let limit = 24
    private var offset = 0
    private var pokedex: [Pokedex.Result] = []
    private var filteredPokedex: [Pokedex.Result] = []
    private var isLoading = PublishRelay<Bool>()
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: PokedexPresentable,
        repository: PokedexRepository,
        apiService: PokemonAPI
    ) {
        self.repository = repository
        self.apiService = apiService
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        self.fetchPokedex()
        // TODO: Implement business logic here.
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}

extension PokedexInteractor {
    
    func fetchPokedex() {
        isLoading.accept(true)
        let pokedexData = repository.getPokedex(limit: limit, offset: offset)
        if pokedexData.isEmpty {
            apiService.fetchPokedex(limit: limit, offset: offset)
                .subscribe(
                    onSuccess: { [weak self] response in
                        guard let `self` = self else { return }
                        defer { self.isLoading.accept(false) }
                        
                        self.offset += self.limit
                        let pokemonEntities = response.results.map { result in
                            let entity = PokemonEntity()
                            entity.idPokemon = Int(result.id ?? "") ?? 0
                            entity.name = result.name
                            entity.url = result.url
                            return entity
                        }
                        self.repository.storePokedex(pokemonEntities)
                        self.pokedex.append(contentsOf: response.results)
                        self.presenter.updatePokedex(self.pokedex)
                    },
                    onFailure: { [weak self] error in
                        guard let `self` = self else { return }
                        self.isLoading.accept(false)
                        print("❌ API Error:", error)
                    }
                )
                .disposeOnDeactivate(interactor: self)
        } else {
            let localPokemon = pokedexData.map { result in
                let entity = Pokedex.Result(from: result)
                return entity
            }
            self.offset += self.limit
            pokedex.append(contentsOf: localPokemon)
            isLoading.accept(false)
            self.presenter.updatePokedex(pokedex)
        }
    }

    func routeToPokemon(with index: Int) {
        self.router?.openPokemon(
            pokedex,
            withSelectedId: index,
            repository: repository,
            apiService: apiService
        )
    }
    
    func goBackFromPokemon() {
        self.router?.detachPokemon()
    }
}
