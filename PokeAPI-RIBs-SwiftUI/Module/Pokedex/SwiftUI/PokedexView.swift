//
//  PokedexView.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif Phincon on 16/09/25.
//

import SwiftUI

struct PokedexView: View {
    
    @ObservedObject private var observableObject: PokedexObservableObject
    
    @State private var buttonFrame: CGRect = .zero
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(observableObject: PokedexObservableObject) {
        self.observableObject = observableObject
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ColorUtils.primary
                .ignoresSafeArea(edges: .all)
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Image("pokeball")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 16)
                        .foregroundColor(ColorUtils.white)
                    Text("Pokedex")
                        .font(FontUtils.headerHeadline)
                        .foregroundColor(ColorUtils.white)
                    Spacer()
                }
                .padding(.leading, 16)
                
                HStack(spacing: 0) {
                    SearchBoxComponent(text: $observableObject.searchText)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                    
                    SortButtonComponent(isSorted: .constant(false), buttonFrame: $buttonFrame) {
                        observableObject.showSortMenu.toggle()
                    }
                    .padding(.trailing, 16)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ColorUtils.white)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(observableObject.filteredPokemons.indices, id: \.self) { index in
                                Button {
                                    observableObject.didSelect(index: index)
                                } label: {
                                    let item = observableObject.filteredPokemons[index]
                                    PokemonCardComponent(
                                        name: item.name,
                                        imageURL: item.imageURL,
                                        idTag: item.id ?? ""
                                    )
                                }
                            }
                        }
                        .padding()
                    }
                }
                .padding(8)
            }
        }
        .overlay(
            Group {
                if observableObject.showSortMenu {
                    VStack(alignment: .trailing, spacing: 0) {
                        Spacer().frame(height: buttonFrame.origin.y)
                        SortComponent(selectedOption: $observableObject.selectedOption)
                            .shadow(radius: 4)
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .transition(.opacity)
                    .animation(.easeInOut, value: observableObject.showSortMenu)
                }
            }
        )
    }
}

struct ButtonFrameKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexView(observableObject: MockPokedexObservableObject(delegate: MockPokedexView()))
    }
}
