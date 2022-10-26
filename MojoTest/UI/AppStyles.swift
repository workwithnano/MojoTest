//
//  AppStyles.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/25/22.
//

import Foundation
import SwiftUI

//struct TitleStyle: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .font(.title)
//            .lineSpacing(8)
//            .foregroundColor(.primary)
//    }
//}
//
//struct ContentStyle: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .font(.body)
//            .lineSpacing(4)
//            .foregroundColor(.secondary)
//    }
//}
//
//extension Text {
//    func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
//        ModifiedContent(content: self, modifier: style)
//    }
//}

// From: https://stackoverflow.com/a/58971579
extension View {
    func customFont(_ textStyle: UIFont.TextStyle) -> ModifiedContent<Self, CustomFont> {
        return modifier(CustomFont(textStyle: textStyle))
    }
}

struct CustomFont: ViewModifier {
    let textStyle: UIFont.TextStyle

    /// Will trigger the refresh of the view when the ContentSizeCategory changes.
    /// > Note: also used to trigger UINavigationBarAppearance refresh
    @Environment(\.dynamicTypeSize) var dynamicTypeSize: DynamicTypeSize

    func body(content: Content) -> some View {

        guard let fontDescription = fontDescriptions[textStyle] else {

            print("textStyle does not exist: \(textStyle)")

            return content.font(.system(.body));
        }

        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        let fontSize = fontMetrics.scaledValue(for: fontDescription.1)

        return content.font(.custom(fontDescription.0, size: fontSize))
    }
}

/// Define the custom fonts to use, depending on the TextStyle.
typealias CustomFontDescription = (String, CGFloat)
private var fontDescriptions: [UIFont.TextStyle: CustomFontDescription] = [
    .largeTitle: ("RubikRoman-Black", 34.0),
    .title1: ("RubikRoman-ExtraBold", 28.0),
    .title2: ("RubikRoman-Bold", 22.0),
    .title3: ("RubikRoman-SemiBold", 20.0),
    .headline: ("RubikRoman-Bold", 17.0),
    .subheadline: ("RubikRoman-Regular", 15.0),
    .body: ("RubikRoman-Regular", 17.0),
    .callout: ("RubikRoman-Regular", 16.0),
    .footnote: ("RubikRoman-Regular", 13.0),
    .caption1: ("RubikRoman-Regular", 12.0),
    .caption2: ("RubikRoman-Regular", 11.0)
]

// Mark: - Navigation Bar Appearance
class NavigationBarStyles {
    static func navigationBarFontSetAppearance(){
        
        let navigationAppearance = UINavigationBarAppearance()
        
        let fontTitleText = UIFontMetrics(forTextStyle: .title1).scaledFont(for: UIFont(name: fontDescriptions[.title1]!.0, size: fontDescriptions[.title1]!.1)!)
        navigationAppearance.titleTextAttributes = [.font: fontTitleText]
        
        let fontLargeTitleText = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont(name: fontDescriptions[.largeTitle]!.0, size: fontDescriptions[.largeTitle]!.1)!)
        navigationAppearance.largeTitleTextAttributes = [.font: fontLargeTitleText]
       
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
    }
}

// Mark: - Colors
extension Color {
    static var negativeColor: Color {
        get {
            return Color("NegativeColor")
        }
    }
    static var positiveColor: Color {
        get {
            return Color("PositiveColor")
        }
    }
    static var foregroundLightGray: Color {
        get {
            return Color("ForegroundLightGray")
        }
    }
    static var backgroundLightGray: Color {
        get {
            return Color("BackgroundLightGray")
        }
    }
}
