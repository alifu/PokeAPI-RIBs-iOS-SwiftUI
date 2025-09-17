//
//  PokemonView.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif Phincon on 16/09/25.
//

import NukeUI
import SwiftUI

struct PokemonView: View {
    
    @ObservedObject private var observableObject: PokemonObservableObject
    
    @State private var buttonFrame: CGRect = .zero
    
    init(observableObject: PokemonObservableObject) {
        self.observableObject = observableObject
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            colorStringToType(observableObject.types.first ?? "")
                .ignoresSafeArea()
            
            backgroundView(observableObject: observableObject)
            
            headerView
        }
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
    }
    
    var headerView: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Button {
                    observableObject.goBack()
                } label: {
                    Image("arrow_back")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(ColorUtils.white)
                        .frame(width: 32, height: 32)
                }
                
                Text(observableObject.name?.capitalized ?? "")
                    .font(FontUtils.headerHeadline)
                    .foregroundColor(ColorUtils.white)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                
                Spacer()
                
                VStack {
                    HStack(spacing: 0) {
                        Image("tag")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 12, height: 12)
                            .foregroundColor(ColorUtils.white)
                        Text(String(format: "%03d", observableObject.id))
                            .font(FontUtils.caption)
                            .frame(height: 12)
                            .foregroundColor(ColorUtils.white)
                    }
                }
            }
            .frame(height: 76)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
            bannerView
        }
    }
    
    var bannerView: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            
            Button {
                observableObject.previous()
            } label: {
                Image("chevron_left")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorUtils.white)
            }
            .frame(width: 24, height: 24)
            .padding(.trailing, 40)
            
            LazyImage(url: URL(string: observableObject.imageURL)) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if state.error != nil {
                    Image("silhouette")
                        .resizable()
                        .frame(width: 200, alignment: .center)
                } else {
                    ProgressView()
                }
            }
            .pipeline(.cached)
            .frame(width: 200)
            
            Button {
                observableObject.next()
            } label: {
                Image("chevron_right")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(ColorUtils.white)
            }
            .frame(width: 24, height: 24)
            .padding(.leading, 40)
            
            Spacer()
        }
        .frame(height: 200)
        .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
    }
    
}

fileprivate func backgroundView(observableObject: PokemonObservableObject) -> some View {
    return VStack(alignment: .leading, spacing: 0) {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            Image("pokeball")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(ColorUtils.white.opacity(0.1))
                .frame(width: 208, height: 208, alignment: .trailing)
        }
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 8)
                .fill(ColorUtils.white)
            
            contentView(observableObject: observableObject)
                .padding(.top, 72)
        }
        .padding(8)
    }
}

fileprivate func contentView(observableObject: PokemonObservableObject) -> some View {
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 0, alignment: .bottom),
        GridItem(.fixed(2), spacing: 0),
        GridItem(.flexible(), spacing: 0, alignment: .bottom),
        GridItem(.fixed(2), spacing: 0),
        GridItem(.flexible(), alignment: .bottom)
    ]
    return ZStack(alignment: .top) {
        VStack {
            HStack(spacing: 8) {
                ForEach(observableObject.types, id: \.self) { type in
                    TypeComponent(text: type.capitalized, backgroundColor: colorStringToType(type))
                }
            }
            .padding(.bottom, 16)
            
            Text("About")
                .font(FontUtils.headerSubtitle1)
                .foregroundColor(colorStringToType(observableObject.types.first ?? ""))
                .padding(.bottom, 16)
            
            HStack(alignment: .bottom, spacing: 0) {
                LazyVGrid(columns: columns) {
                    VStack(alignment: .center) {
                        HStack(spacing: 0) {
                            Image("weight")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(ColorUtils.grayscaleDark)
                                .frame(width: 16)
                                .padding(.trailing, 4)
                            Text((observableObject.weight ?? 0).toKg)
                                .font(FontUtils.body3)
                                .foregroundColor(ColorUtils.grayscaleDark)
                        }
                        .frame(height: 16)
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        
                        Text("Weight")
                            .font(FontUtils.caption)
                            .foregroundColor(ColorUtils.grayscaleMedium)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Rectangle()
                        .frame(width: 2)
                        .foregroundColor(ColorUtils.grayscaleLight)
                    
                    VStack {
                        HStack(spacing: 0) {
                            Image("straighten")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(ColorUtils.grayscaleDark)
                                .frame(width: 16)
                                .padding(.trailing, 4)
                            Text((observableObject.height ?? 0).toMeters)
                                .font(FontUtils.body3)
                                .foregroundColor(ColorUtils.grayscaleDark)
                        }
                        .frame(height: 16)
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        
                        Text("Height")
                            .font(FontUtils.caption)
                            .foregroundColor(ColorUtils.grayscaleMedium)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Rectangle()
                        .frame(width: 2)
                        .foregroundColor(ColorUtils.grayscaleLight)
                    
                    VStack(alignment: .center) {
                        VStack {
                            ForEach(observableObject.abilities, id: \.self) { ability in
                                Text(ability.capitalized)
                                    .font(FontUtils.body3)
                                    .foregroundColor(ColorUtils.grayscaleDark)
                            }
                        }
                        .padding(.bottom, 8)
                        
                        Text("Moves")
                            .font(FontUtils.caption)
                            .foregroundColor(ColorUtils.grayscaleMedium)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 16)
            
            Text(observableObject.about)
                .font(FontUtils.body3)
                .foregroundColor(ColorUtils.grayscaleDark)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
                .padding(.leading, 8)
                .padding(.trailing, 8)
            
            Text("Base Stat")
                .font(FontUtils.headerSubtitle1)
                .foregroundColor(colorStringToType(observableObject.types.first ?? ""))
                .padding(.bottom, 16)
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(observableObject.stats, id: \.stat.name) { stat in
                    ProgressComponent(title: stat.stat.displayName(), stat: stat.baseStat, typeColor: colorStringToType(observableObject.types.first ?? ""))
                }
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)
        }
        .padding(8)
    }
}

struct PokemonView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonView(observableObject: MockPokemonObservableObject(delegate: MockPokemonView()))
    }
}
