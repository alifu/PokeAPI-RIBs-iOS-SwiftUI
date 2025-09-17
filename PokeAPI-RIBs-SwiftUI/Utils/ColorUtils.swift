//
//  ColorUtils.swift
//  PokeAPI-RIBs-SwiftUI
//
//  Created by Alif on 03/09/25.
//

import SwiftUI

enum ColorUtils {
    static let primary: Color = Color(hex: "#DC0A2D")
    static let bug: Color = Color(hex: "#A7B723")
    static let dark: Color = Color(hex: "#75574C")
    static let dragon: Color = Color(hex: "#7037FF")
    static let electric: Color = Color(hex: "#F9CF30")
    static let fairy: Color = Color(hex: "#E69EAC")
    static let fighting: Color = Color(hex: "#C12239")
    static let fire: Color = Color(hex: "#F57D31")
    static let flying: Color = Color(hex: "#A891EC")
    static let ghost: Color = Color(hex: "#70559B")
    static let grass: Color = Color(hex: "#74CB48")
    static let ground: Color = Color(hex: "#DEC16B")
    static let ice: Color = Color(hex: "#9AD6DF")
    static let poison: Color = Color(hex: "#A43E9E")
    static let psychic: Color = Color(hex: "#FB5584")
    static let rock: Color = Color(hex: "#B69E31")
    static let steel: Color = Color(hex: "#B7B9D0")
    static let water: Color = Color(hex: "#6493EB")
    static let grayscaleDark: Color = Color(hex: "#212121")
    static let grayscaleMedium: Color = Color(hex: "#666666")
    static let grayscaleLight: Color = Color(hex: "#E0E0E0")
    static let background: Color = Color(hex: "#EFEFEF")
    static let white: Color = Color(hex: "#FFFFFF")
    static let wireframe: Color = Color(hex: "#B8B8B8")
}

enum ColorType: String {
    case bug
    case dark
    case dragon
    case electric
    case fairy
    case fighting
    case fire
    case flying
    case ghost
    case grass
    case ground
    case ice
    case poison
    case psychic
    case rock
    case steel
    case water
    case none
    
    var color: Color {
        switch self {
        case .bug:
            return ColorUtils.bug
        case .dark:
            return ColorUtils.dark
        case .dragon:
            return ColorUtils.dragon
        case .electric:
            return ColorUtils.electric
        case .fairy:
            return ColorUtils.fairy
        case .fighting:
            return ColorUtils.fighting
        case .fire:
            return ColorUtils.fire
        case .flying:
            return ColorUtils.flying
        case .ghost:
            return ColorUtils.ghost
        case .grass:
            return ColorUtils.grass
        case .ground:
            return ColorUtils.ground
        case .ice:
            return ColorUtils.ice
        case .poison:
            return ColorUtils.poison
        case .psychic:
            return ColorUtils.psychic
        case .rock:
            return ColorUtils.rock
        case .steel:
            return ColorUtils.steel
        case .water:
            return ColorUtils.water
        case .none:
            return ColorUtils.wireframe
        }
    }
}

func colorStringToType(_ colorString: String?) -> Color {
    guard let colorString else {
        return ColorType.none.color
    }
    return ColorType(rawValue: colorString.lowercased())?.color ?? ColorType.none.color
}
