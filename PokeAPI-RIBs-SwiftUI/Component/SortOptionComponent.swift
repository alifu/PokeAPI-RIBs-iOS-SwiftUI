//
//  SortOptionComponent.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif Phincon on 16/09/25.
//

import SwiftUI

struct SortOptionComponent: View {
    @Binding var selectedOption: SortComponentType
    @Binding var contentType: SortComponentType
    
    var body: some View {
        Button {
            selectedOption = contentType
        } label: {
            HStack(alignment: .center) {
                Image((selectedOption == contentType) ? "select" : "un_select")
                    .resizable()
                    .frame(width: 12, height: 12)
                Text(contentType.rawValue.capitalized)
                    .font(FontUtils.body3)
                    .foregroundColor(ColorUtils.grayscaleDark)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }

    }
}

struct SortOptionComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SortOptionComponent(selectedOption: .constant(.number), contentType: .constant(.number))
            SortOptionComponent(selectedOption: .constant(.number), contentType: .constant(.name))
        }
    }
}
