//
//  PokemonCardComponent.swift
//  PokeAPI-SwiftUI
//
//  Created by alif rama on 10/08/25.
//

import NukeUI
import SwiftUI

struct PokemonCardComponent: View {
    
    let name: String
    let imageURL: String?
    let idTag: String
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 0) {
                Spacer()
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(ColorUtils.background)
                        .frame(height: 44, alignment: .bottom)
                        .cornerRadius(7, corners: [.topLeft, .topRight])
                    
                    Text(name)
                        .frame(alignment: .center)
                        .font(FontUtils.body3)
                        .foregroundColor(ColorUtils.grayscaleDark)
                        .padding(EdgeInsets(top: 0, leading: 8, bottom: 4, trailing: 8))
                }
            }
            
            LazyImage(url: URL(string: imageURL ?? "")) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if state.error != nil {
                    Image("silhouette")
                        .resizable()
                        .frame(width: 60, height: 60, alignment: .center)
                } else {
                    ProgressView()
                }
            }
            .pipeline(.cached)
            .frame(width: 60, height: 60)
            
            VStack {
                HStack {
                    Spacer()
                    HStack(spacing: 0) {
                        Image("tag")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 12, height: 12)
                            .foregroundColor(ColorUtils.grayscaleMedium)
                        Text(String(format: "%03d", Int(idTag) ?? 0))
                            .font(FontUtils.caption)
                            .frame(height: 12)
                            .foregroundColor(ColorUtils.grayscaleMedium)
                    }
                    .padding(EdgeInsets(top: 6, leading: 0, bottom: 0, trailing: 10))
                }
                Spacer()
            }
        }
        .frame(height: 108)
        .padding(0)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
        )
        .shadow(color: ColorUtils.grayscaleMedium,
                radius: 2, x: 0, y: 1)
    }
}

struct PokemonCardComponent_Previews: PreviewProvider {
    static var previews: some View {
        PokemonCardComponent(
            name: "Pokemon",
            imageURL: nil,
            idTag: "1"
        )
    }
}
