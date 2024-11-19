//
//  BackButton.swift
//
//
//  Created by Aswin V Shaji on 29/10/24.
//

import SwiftUI

struct BackButton: View {
    var function: () -> Void
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack() {
            HStack {
                ZStack {
                    Circle()
                        .frame(width: 40,height: 40)
                        .foregroundStyle(colorScheme == .dark
                                         ? Color.black
                                         : Color.white)
                    Button{
                        function()
                    }label: {
                        Image(systemName: "arrow.backward")
                            .foregroundStyle(colorScheme == .dark
                                             ? Color.white
                                             : Color.black)
                    }
                    .frame(width: 50,height: 50)
                }
                .padding(.leading)
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    BackButton(function: {})
}
