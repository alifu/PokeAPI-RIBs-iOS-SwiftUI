//
//  PokemonViewController.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif on 16/09/25.
//

import RIBs
import RxSwift
import SwiftUI
import UIKit

protocol PokemonPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func navigateToNextPokemon()
    func navigateToPreviousPokemon()
    func goBack()
}

final class PokemonViewController: UIViewController, PokemonPresentable, PokemonViewControllable {
    
    weak var listener: PokemonPresentableListener?
    private let disposeBag = DisposeBag()
    private var observableObject: PokemonObservableObject!

    init() {
        super.init(nibName: nil, bundle: nil)
        self.observableObject = PokemonObservableObject(delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setupView(view: PokemonView(observableObject: observableObject))
    }
    
    private func setupView<Content>(view: Content) where Content : View {
        let contentVC = UIHostingController<Content>(rootView: view)
        
        self.addChild(contentVC)
        contentVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(contentVC.view)
        contentVC.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            contentVC.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            contentVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            contentVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    func updatePokemonInfo(_ data: PokemonInfoWrapper) {
        observableObject.updatePokemonInfox(data)
    }
    
    func updatePokemonDescription(_ description: String) {
        observableObject.updateDescription(description)
    }
}

extension PokemonViewController: PokemonDelegate {
    
    func previousPokemon() {
        self.listener?.navigateToPreviousPokemon()
    }
    
    func nextPokemon() {
        self.listener?.navigateToNextPokemon()
    }
    
    func goBack() {
        self.navigationController?.popViewController(animated: true)
        self.listener?.goBack()
    }
}
