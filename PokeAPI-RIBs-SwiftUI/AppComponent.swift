//
//  AppComponent.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif on 15/09/25.
//

import RIBs

class AppComponent: Component<EmptyDependency>, RootDependency {

    init() {
        super.init(dependency: EmptyComponent())
    }
}
