//
//  PickupDropoffStepperView.swift
//
//
//  Created by Aswin V Shaji on 31/10/24.
//

import SwiftUI

struct PickupDropoffStepperView: View {
    @Binding var fromLocation: String
    @Binding var toLocation: String
    var body: some View {
        HStack {
            Image("stepper",bundle: Bundle.module)
                .padding(.leading,20)
                .padding(.trailing,10)
                .padding(.vertical)
            VStack(alignment: .leading,spacing: 12) {
                Text("pick_up")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(fromLocation)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                Divider()
                
                Text("drop_off")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(toLocation)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity,alignment: .leading)
            }
            .padding(.trailing,20)
        }
    }
}

#Preview {
    PickupDropoffStepperView(fromLocation: .constant(""), toLocation: .constant(""))
}
