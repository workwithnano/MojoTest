//
//  AppStyles.swift
//  MojoTest
//
//  Created by Nano Anderson on 10/25/22.
//

import Foundation
import SwiftUI
import SegmentedPicker

// MARK: - Custom font overrides

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

// MARK: - Navigation Bar Appearance
class NavigationBarStyles {
    
    @Environment(\.colorScheme) static private var colorScheme
    
    static func navigationBarFontSetAppearance(){
        
        let navigationAppearance = UINavigationBarAppearance()
        
        // Kind of hacky way to get an opaque background, but without any shadow/divider line
        navigationAppearance.configureWithTransparentBackground()
        navigationAppearance.backgroundColor = UIColor.systemBackground
        
        let fontTitleText = UIFontMetrics(forTextStyle: .title1).scaledFont(for: UIFont(name: fontDescriptions[.title1]!.0, size: fontDescriptions[.title1]!.1)!)
        navigationAppearance.titleTextAttributes = [.font: fontTitleText]
        
        let fontLargeTitleText = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont(name: fontDescriptions[.largeTitle]!.0, size: fontDescriptions[.largeTitle]!.1)!)
        navigationAppearance.largeTitleTextAttributes = [.font: fontLargeTitleText]
       
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
    }
}

// MARK: - Colors
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
    static var dimYellow: Color {
        get {
            return Color("DimYellow")
        }
    }
}

// MARK: - Menus & Buttons
struct DropdownMenu: MenuStyle {
    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .tint(Color.backgroundLightGray)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .customFont(.subheadline) // TODO: standardize font sizes around items that don't match UIFont.TextStyle names
            .fontWeight(.medium)
            .foregroundColor(.primary)
    }
}

struct GenericNavigationLabel: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            Spacer()
            configuration.icon
        }
        .customFont(.body)
        .foregroundStyle(.foreground)
    }
}

struct SegmentedMojoPicker: View {
    let titles: [String]
    @Binding var selectedIndex: Int?

    var body: some View {
        SegmentedPicker(
            titles,
            selectedIndex: Binding(
                get: { selectedIndex },
                set: { selectedIndex = $0 }),
            spacing: 10,
            content: { item, isSelected in
                Text(item.uppercased())
                    .customFont(.caption1)
                    .fontWeight(isSelected ? .medium : .regular)
                    .foregroundColor(isSelected ? Color.white : Color.accentColor )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.accentColor, lineWidth: (isSelected ? 0 : 1))
                    }
            },
            selection: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.accentColor)
            })
    }
}

struct MojoButtonRoundedRectModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 12))
    }
}
extension View {
    func mojoButtonRoundedRect() -> some View {
        modifier(MojoButtonRoundedRectModifier())
    }
}

// MARK: - Text formatting
struct FormattedAmountText: View {
    
    let formattedAmount: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "\(formattedAmount.starts(with: "-") ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill")")
                .scaleEffect(x: 0.75, y: 0.75, anchor: .center) // Make the arrow 75% the size of the rest of the label, per design spec
                .foregroundStyle(formattedAmount.starts(with: "-") ? Color.negativeColor : Color.positiveColor)
            Text(formattedAmount)
                .foregroundStyle(formattedAmount.starts(with: "-") ? Color.negativeColor : Color.positiveColor)
        }
    }
    
}
