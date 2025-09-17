//
//  SearchBoxComponent.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif on 16/09/25.
//

import SwiftUI

struct SearchBoxComponent: View {
    @Binding var text: String
    var placeholder: String = "Search..."
    var onCommit: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Image("search")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(ColorUtils.primary)
                .frame(width: 16, height: 16)
            
            TextField(placeholder, text: $text, onCommit: {
                onCommit?()
            })
            .font(FontUtils.body3)
            .frame(height: 16)
            .textFieldStyle(PlainTextFieldStyle())
            .disableAutocorrection(true)
            .autocapitalization(.none)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image("close")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(ColorUtils.primary)
                }
                .frame(width: 16, height: 16)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(ColorUtils.white)
        )
        .overlay(
            Group {
                if text.isEmpty {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(ColorUtils.grayscaleLight,
                                lineWidth: 1)
                        .shadow(color: ColorUtils.grayscaleMedium,
                                radius: 2, x: 2, y: 2)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 24)
                        )
                } else {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(ColorUtils.grayscaleLight, lineWidth: 0.5)
                        .shadow(color: ColorUtils.grayscaleMedium.opacity(1),
                                radius: 2, x: 0, y: 0)
                }
            }
        )
    }
}

struct SearchBox_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            SearchBoxComponent(text: .constant(""))
                .padding()
                .previewLayout(.sizeThatFits)
            
            SearchBoxComponent(text: .constant("Typing something..."))
                .padding()
                .previewLayout(.sizeThatFits)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
