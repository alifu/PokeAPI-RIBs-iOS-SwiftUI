//
//  SortComponent.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif on 16/09/25.
//

import SwiftUI

enum SortComponentType: String {
    case number
    case name
    case none
}

struct SortComponent: View {
    
    @Binding var selectedOption: SortComponentType
    
    var body: some View {
        ZStack(alignment: .top) {
            ColorUtils.primary
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Sort by:")
                    .font(FontUtils.headerSubtitle2)
                    .foregroundColor(ColorUtils.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 44)
                    .padding(.horizontal, 16)
                
                ZStack(alignment: .center) {
                    Rectangle()
                        .foregroundColor(ColorUtils.white)
                        .cornerRadius(8)
                    VStack(alignment: .leading, spacing: 16) {
                        SortOptionComponent(selectedOption: $selectedOption, contentType: .constant(.number))
                        SortOptionComponent(selectedOption: $selectedOption, contentType: .constant(.name))
                    }
                    .padding(.horizontal, 16)
                }
                .padding(4)
            }
        }
        .cornerRadius(12)
        .frame(width: 113, height: 132)
    }
}

struct SortComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SortComponent(selectedOption: .constant(.name))
            SortComponent(selectedOption: .constant(.number))
        }
    }
}
