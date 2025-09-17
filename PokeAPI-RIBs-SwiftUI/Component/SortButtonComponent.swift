//
//  SortButtonComponent.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif on 16/09/25.
//

import SwiftUI

struct SortButtonComponent: View {
    
    @Binding var isSorted: Bool
    @Binding var buttonFrame: CGRect
    var action: (() -> Void)? = nil
    
    var body: some View {
        let label = ZStack {
            Image("sort")
                .renderingMode(.template)
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(ColorUtils.primary)
        }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(ColorUtils.white)
            )
            .overlay(
                Group {
                    if isSorted {
                        Circle()
                            .stroke(ColorUtils.grayscaleLight, lineWidth: 0.5)
                            .shadow(color: ColorUtils.grayscaleMedium.opacity(1),
                                    radius: 2, x: 0, y: 0)
                    } else {
                        Circle()
                            .stroke(ColorUtils.grayscaleLight,
                                    lineWidth: 1)
                            .shadow(color: ColorUtils.grayscaleMedium,
                                    radius: 2, x: 2, y: 2)
                            .clipShape(
                                Circle()
                            )
                    }
                }
            )
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            buttonFrame = geo.frame(in: .global)
                        }
                        .onChange(of: geo.frame(in: .global)) { newValue in
                            buttonFrame = newValue
                        }
                }
            )
        
        if let action = action {
            Button(action: action) {
                label
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            label
        }
    }
}

struct SortButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            SortButtonComponent(isSorted: .constant(false), buttonFrame: .constant(.zero))
            SortButtonComponent(isSorted: .constant(true), buttonFrame: .constant(.zero))
        }
    }
}
