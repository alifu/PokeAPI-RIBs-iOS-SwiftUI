//
//  PokedexViewController.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif on 15/09/25.
//

import RIBs
import RxSwift
import SwiftUI
import UIKit

protocol PokedexPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func routeToPokemon(with index: Int)
}

final class PokedexViewController: UIViewController, PokedexPresentable, PokedexViewControllable {

    weak var listener: PokedexPresentableListener?
    private var observableObject: PokedexObservableObject!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.observableObject = PokedexObservableObject(delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Method is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setupView(view: PokedexView(observableObject: observableObject))
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
}

extension PokedexViewController {
    
    func updatePokedex(_ pokedex: [Pokedex.Result]) {
        observableObject.updatePokedex(with: pokedex)
    }
    
    func openPokemonPage(viewController: (any ViewControllable)?) {
        if let viewController {
            self.navigationController?.pushViewController(viewController.uiviewController, animated: true)
        }
    }
}

extension PokedexViewController: PokedexDelegate {
    
    func selectedPokemon(with index: Int) {
        self.listener?.routeToPokemon(with: index)
    }
}
