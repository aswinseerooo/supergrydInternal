//
//  LargeButton.swift
//
//
//  Created by Aswin V Shaji on 28/10/24.
//

import SwiftUI

struct LargeButtonStyle: ButtonStyle {
    
    let backgroundColor: Color
    let foregroundColor: Color
    let isDisabled: Bool
    let cornerRadius: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        let currentForegroundColor = isDisabled || configuration.isPressed ? foregroundColor.opacity(0.3) : foregroundColor
        return configuration.label
            .padding()
            .foregroundColor(currentForegroundColor)
            .background(isDisabled || configuration.isPressed ? backgroundColor.opacity(0.3) : backgroundColor)
            // This is the key part, we are using both an overlay as well as cornerRadius
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(currentForegroundColor, lineWidth: 1)
        )
            .padding([.top, .bottom], 10)
            .font(Font.system(size: 19, weight: .semibold))
    }
}

struct LargeButton: View {
    
    var backgroundColor: Color
    var foregroundColor: Color
    
    private let title: String
    private let action: () -> Void
    private let buttonHorizontalMargins: CGFloat
    private let cornerRadius: CGFloat
    private let font: Font
    private let fontWeight: Font.Weight
    
    // It would be nice to make this into a binding.
    private let disabled: Bool
    
    init(title: String,
         disabled: Bool = false,
         backgroundColor: Color = Color.green,
         foregroundColor: Color = Color.white,
         buttonHorizontalMargins: CGFloat = 20,
         cornerRadius: CGFloat = 50,
         font: Font = .body,
         fontWeight: Font.Weight = .regular,
         action: @escaping () -> Void) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.title = title
        self.action = action
        self.disabled = disabled
        self.buttonHorizontalMargins = buttonHorizontalMargins
        self.cornerRadius = cornerRadius
        self.font = font
        self.fontWeight = fontWeight
    }
    
    var body: some View {
        HStack {
            Spacer(minLength: buttonHorizontalMargins)
            Button(action:self.action) {
                Text(self.title)
                    .font(font)
                    .fontWeight(fontWeight)
                    .frame(maxWidth:.infinity)
            }
            .buttonStyle(LargeButtonStyle(backgroundColor: backgroundColor,
                                          foregroundColor: foregroundColor,
                                          isDisabled: disabled,cornerRadius: cornerRadius))
                .disabled(self.disabled)
            Spacer(minLength: buttonHorizontalMargins)
        }
        .frame(maxWidth:.infinity)
    }
}
