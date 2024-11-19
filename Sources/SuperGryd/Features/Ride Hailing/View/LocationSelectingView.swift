//
//  LocationSelectingView.swift
//
//
//  Created by Aswin V Shaji on 21/10/24.
//

import SwiftUI
import CoreLocation
import BottomSheet

struct LocationSelectingView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = LocationSelectingViewModel()
    var body: some View {
        if AppConstants.isAuthenticated {
            NavigationStack(path: $viewModel.navigationPath) {
                ZStack {
                    MapView(
                        onAddressUpdate: viewModel.handleAddressUpdate,
                        onCurrentLocationUpdate: viewModel.handleCurrentLocationUpdate
                    )
                    .edgesIgnoringSafeArea(.all)
                    
                    if viewModel.isConfirmLocationOnMapShowing {
                        Image("mapPin", bundle: Bundle.module)
                            .tint(Color.blue)
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                    }
                    
                    if viewModel.showBackButton {
                        BackButton(function: viewModel.handleBackAction)
                    }
                }
                .navigationDestination(for: String.self) { value in
                    if value == "RideSelectionView" {
                        RideSelectionView(
                            locationViewModel: viewModel,
                            startLocation: (
                                lat: viewModel.selectedFromLocation?.coordinate?.latitude ?? 0.0,
                                long: viewModel.selectedFromLocation?.coordinate?.longitude ?? 0.0
                            ),
                            endLocation: (
                                lat: viewModel.selectedToLocation?.coordinate?.latitude ?? 0.0,
                                long: viewModel.selectedToLocation?.coordinate?.longitude ?? 0.0
                            )
                        )

                    } else if value == "RideView" {
                        RideView(locationViewModel: viewModel)
                    } else if value == "RateDriverView" {
                        RateDriverView(navigationPath: $viewModel.navigationPath)
                    }
                }
            }
            .navigationBarTitle("")
            .toolbar(.hidden)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                print("UserId = ",AppConstants.userId)
                viewModel.dismissAction = {
                    if presentationMode.wrappedValue.isPresented {
                        presentationMode.wrappedValue.dismiss() // SwiftUI dismissal
                    } else {
                        let scenes = UIApplication.shared.connectedScenes
                        let windowScene = scenes.first as? UIWindowScene
                        if  let navController = windowScene?.windows.first?.rootViewController as? UINavigationController {
                            
                            navController.popViewController(animated: true) // UIKit fallback
                        }
                    }
                }
                viewModel.updateBackAction(viewModel.goBackToHostApp)
            }
            .onChange(of: viewModel.navigationPath) { newValue in
                if newValue.isEmpty {
                    viewModel.resetViewsForRideSelection()
                }
            }
            .bottomSheet(
                bottomSheetPosition: $viewModel.bottomSheetPosition,
                switchablePositions: viewModel.isLocationExpandedViewShowing ? [
                    .absolute(UIScreen.main.bounds.height * 0.35),
                    .absolute(UIScreen.main.bounds.height * 0.65),
                    .absolute(UIScreen.main.bounds.height)
                ] : [
                    .absolute(UIScreen.main.bounds.height * 0.32),
                    .dynamic
                ]) {
                    if !viewModel.isRideSelectionViewShowing {
                        sheetContentView()
                            .padding(.horizontal)
                    }
                }
                .customBackground(.clear)
                .dragIndicatorColor(.clear)
                .enableContentDrag()
                .onChange(of: viewModel.bottomSheetPosition) { newPosition in
                    viewModel.updateBottomSheetPosition(newPosition)
                }
                .onChange(of: viewModel.isLocationExpandedViewShowing) { newValue in
                    viewModel.showBackButton = !newValue
                    viewModel.bottomSheetPosition = .dynamic
                }
                .onChange(of: viewModel.isConfirmLocationOnMapShowing) { newValue in
                    viewModel.bottomSheetPosition = newValue ? .absolute(UIScreen.main.bounds.height * 0.35) : .dynamic
                }
                .onChange(of: viewModel.isRideSelectionViewShowing) { isShowing in
                    if isShowing {
                        viewModel.navigationPath.append("RideSelectionView")
                    }
                }
        } else {
            ZStack {
                VStack {
                    Image(systemName: "x.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.red)
                        .padding()
                    Text("Authentication Failed!")
                        .font(.title)
                        .bold()
                }
            }
            .onAppear {
                viewModel.goBackToHostApp()
            }
        }
    }
    
    @ViewBuilder
    private func sheetContentView() -> some View {
        if viewModel.isConfirmLocationOnMapShowing {
            ConfirmLocationInMapSheet(viewModel: viewModel)
        } else if viewModel.isLocationExpandedViewShowing {
            LocationSelectionExpandedSheet(viewModel: viewModel)
        } else {
            LocationSelectionSheet(viewModel: viewModel)
        }
    }
}


#Preview {
    LocationSelectingView()
}

