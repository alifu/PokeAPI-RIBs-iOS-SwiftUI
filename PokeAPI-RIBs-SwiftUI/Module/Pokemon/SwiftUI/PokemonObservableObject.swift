//
//  PokemonObservableObject.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif Phincon on 16/09/25.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftUI

protocol PokemonDelegate: AnyObject {
    func goBack()
    func previousPokemon()
    func nextPokemon()
}

class PokemonObservableObject: ObservableObject {
    
    private weak var delegate: PokemonDelegate?
    @Published var errorMessage: String?
    @Published var id: Int = 0
    @Published var name: String?
    @Published var abilities: [String] = []
    @Published var height: Double?
    @Published var weight: Double?
    @Published var stats: [Pokemon.Stats] = []
    @Published var imageURL: String = ""
    @Published var types: [String] = []
    @Published var about: String = ""
    
    init(delegate: PokemonDelegate?) {
        self.delegate = delegate
    }
    
    func goBack() {
        self.delegate?.goBack()
    }
    
    func previous() {
        self.delegate?.previousPokemon()
    }
    
    func next() {
        self.delegate?.nextPokemon()
    }
    
    func updatePokemonInfox(_ data: PokemonInfoWrapper) {
        self.id = data.id
        self.name = data.name
        self.abilities = data.abilities
        self.height = data.height
        self.weight = data.weight
        self.stats = data.stats
        self.imageURL = data.banner
        self.types = data.types
    }
    
    func updateDescription(_ description: String) {
        self.about = description
    }
}
