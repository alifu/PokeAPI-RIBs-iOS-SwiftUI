//
//  PokedexObservableObject.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif Phincon on 16/09/25.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftUI

protocol PokedexDelegate: AnyObject {
    func selectedPokemon(with index: Int)
}

class PokedexObservableObject: ObservableObject {
    
    @Published var errorMessage: String = ""
    @Published var showSortMenu: Bool = false
    @Published var searchText: String = "" {
        didSet { searchTextRelay.accept(searchText) }
    }
    @Published var selectedOption: SortComponentType = .none {
        didSet { selectedOptionRelay.accept(selectedOption) }
    }
    @Published fileprivate(set) var filteredPokemons: [Pokedex.Result] = []
    
    private let delegate: PokedexDelegate?
    private let limit = 24
    private var offset = 0
    private let disposeBag = DisposeBag()
    private var searchTextRelay = BehaviorRelay<String>(value: "")
    private var selectedOptionRelay = BehaviorRelay<SortComponentType>(value: .none)
    private var pokemonsRelay = BehaviorRelay<[Pokedex.Result]>(value: [])
    
    init(delegate: PokedexDelegate?) {
        self.delegate = delegate
        self.bindingSearchTextAndData()
    }
    
    private func bindingSearchTextAndData() {
        Observable
            .combineLatest(searchTextRelay, selectedOptionRelay, pokemonsRelay)
            .map { (search, sortOption, pokemons) -> [Pokedex.Result] in
                var result = pokemons
                if !search.isEmpty {
                    result = result.filter { $0.name.localizedCaseInsensitiveContains(search) }
                }
                switch sortOption {
                case .name:
                    result.sort { $0.name < $1.name }
                case .number:
                    result.sort { (Int($0.id ?? "0") ?? 0) < (Int($1.id ?? "0") ?? 0) }
                case .none:
                    break
                }
                return result
            }
            .do(onNext: { [weak self] _ in
                guard let self else { return }
                if self.showSortMenu {
                    self.showSortMenu.toggle()
                }
            })
            .bind(to: rx.filteredPokemons)
            .disposed(by: disposeBag)
    }
    
    func updatePokedex(with data: [Pokedex.Result]) {
        pokemonsRelay.accept(data)
    }
    
    func didSelect(index: Int) {
        delegate?.selectedPokemon(with: index)
    }
}

extension PokedexObservableObject: ReactiveCompatible {}

extension Reactive where Base: PokedexObservableObject {
    var filteredPokemons: Binder<[Pokedex.Result]> {
        Binder(base) { object, value in
            object.filteredPokemons = value
        }
    }
}
