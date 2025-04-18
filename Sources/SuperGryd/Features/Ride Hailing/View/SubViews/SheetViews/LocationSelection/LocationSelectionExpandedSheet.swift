//
//  LocationSelectionExpandedSheet.swift
//
//
//  Created by Aswin V Shaji on 26/10/24.
//

import SwiftUI
import SVGView

struct LocationSelectionExpandedSheet: View {

    @ObservedObject var viewModel: LocationSelectingViewModel
    @FocusState private var focusedField: FocusField?

    enum FocusField: Hashable {
        case fromLocation
        case toLocation
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "arrow.backward")
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        viewModel.isLocationExpandedViewShowing = false
                    }
                Spacer()
                Text("plan_your_ride")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "arrow.backward")
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.clear)
            }
            .padding(.horizontal)
            .padding(.top)

            HStack {
                Image("stepper", bundle: Bundle.module)
                    .padding()
                VStack(alignment: .leading, spacing: 10) {
                    Text("pick_up")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ZStack(alignment: .leading) {
                        if viewModel.fromLocation.isEmpty {
                            Text("where_from")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            TextField("", text: $viewModel.fromLocation)
                                .font(.headline.weight(.semibold))
                                .focused($focusedField, equals: .fromLocation)
                                .onTapGesture {
                                    viewModel.forDestinationLocation = false
                                }
                                .onChange(of: viewModel.fromLocation) { newText in
                                    if newText.count >= 2 {
                                        viewModel.fetchAutocompleteSuggestions(for: newText)
                                    } else {
                                        viewModel.suggestions.removeAll()
                                    }
                                }
                            
                            // Clear Button
                            if !viewModel.fromLocation.isEmpty {
                                Button(action: {
                                    viewModel.fromLocation = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }

                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.secondary)

                    Text("drop_off")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ZStack(alignment: .leading) {
                        if viewModel.toLocation.isEmpty {
                            Text("where_to")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        HStack {
                            TextField("", text: $viewModel.toLocation)
                                .font(.headline.weight(.semibold))
                                .focused($focusedField, equals: .toLocation)
                                .onTapGesture {
                                    viewModel.forDestinationLocation = true
                                }
                                .onChange(of: viewModel.toLocation) { newText in
                                    if newText.count >= 2 {
                                        viewModel.fetchAutocompleteSuggestions(for: newText)
                                    } else {
                                        viewModel.suggestions.removeAll()
                                    }
                                }
                            
                            // Clear Button
                            if !viewModel.toLocation.isEmpty {
                                Button(action: {
                                    viewModel.toLocation = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.trailing)

            Spacer().frame(height: 10)

            VStack(alignment: .leading, spacing: 10) {
                // Display suggestions dynamically
                if !viewModel.suggestions.isEmpty {
                    ForEach(viewModel.suggestions, id: \.title) { suggestion in
                        RecentPlacesTile(
                           viewModel: viewModel,
                           location: suggestion
                        )
                    }
                } else {
                    ForEach(viewModel.locations, id: \.title) { location in
                        RecentPlacesTile(
                            viewModel: viewModel,
                            location: location
                        )
                    }
                }
            }
            .padding(.trailing)
            .padding(.bottom, 20)

            SetLocationInMapButton()
                .padding(.bottom, 80)
                .onTapGesture {
                    viewModel.isConfirmLocationOnMapShowing = true
                }
            Spacer()
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .onAppear {
            // Set the initial focus based on forDestinationLocation
            focusedField = viewModel.forDestinationLocation ? .toLocation : .fromLocation
        }
    }
}


#Preview {
    LocationSelectionExpandedSheet(viewModel: LocationSelectingViewModel())
}
