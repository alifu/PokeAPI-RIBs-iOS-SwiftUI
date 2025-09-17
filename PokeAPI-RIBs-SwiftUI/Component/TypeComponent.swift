//
//  TypeComponent.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif on 16/09/25.
//

import SwiftUI


struct TypeComponent: View {
    let text: String
    var systemImage: String? = nil       // optional SF Symbol
    var font: Font = FontUtils.headerSubtitle3
    var textColor: Color = ColorUtils.white
    var backgroundColor: Color = ColorUtils.grayscaleMedium
    var paddingV: CGFloat = 6
    var paddingH: CGFloat = 12
    var cornerRadius: CGFloat = 16
    var borderColor: Color? = nil
    var borderWidth: CGFloat = 1
    var shadow: Bool = false
    var action: (() -> Void)? = nil      // optional tap action

    var body: some View {
        let label = HStack(spacing: 8) {
            if let systemImage = systemImage {
                Image(systemName: systemImage)
                    .font(font)
                    .accessibility(hidden: true)
            }
            Text(text)
                .font(font)
                .lineLimit(1)
        }
        .foregroundColor(textColor)
        .padding(.vertical, paddingV)
        .padding(.horizontal, paddingH)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(backgroundColor)
        )
        .overlay(
            Group {
                if let stroke = borderColor {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(stroke, lineWidth: borderWidth)
                }
            }
        )
        .fixedSize()
        .modifier(ShadowIfNeeded(enabled: shadow))

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

// MARK: - Preview and examples
struct TypeComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            TypeComponent(text: "Default")
            TypeComponent(text: "With icon", systemImage: "star.fill", textColor: .white, backgroundColor: ColorUtils.primary)
            TypeComponent(text: "Tag", textColor: .white, backgroundColor: .green, cornerRadius: 10)
            TypeComponent(text: "Outlined", textColor: ColorUtils.primary, backgroundColor: .clear, borderColor: ColorUtils.primary)
            TypeComponentSelectableExample()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }

    struct TypeComponentSelectableExample: View {
        @State private var selected = false
        var body: some View {
            TypeComponent(
                text: selected ? "Selected" : "Tap me",
                systemImage: selected ? "checkmark" : nil,
                font: .callout.bold(),
                textColor: selected ? .white : .primary,
                backgroundColor: selected ? .accentColor : Color(.systemGray5),
                cornerRadius: 12,
                shadow: true
            ) {
                withAnimation(.easeInOut) { selected.toggle() }
            }
        }
    }
}
