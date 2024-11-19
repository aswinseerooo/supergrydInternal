//
//  CancelRideSheet.swift
//
//
//  Created by Aswin V Shaji on 30/10/24.
//

import SwiftUI

struct CancelRideSheet: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var locationViewModel: LocationSelectingViewModel
    @ObservedObject var viewModel: RideViewModel
    @State private var selectedCancelIndex: Int?
    @State private var showAlert = false
    @State private var isKeyboardVisible = false
    @State var otherReason: String = ""
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Display total distance covered
                HStack {
                    Image(systemName: "arrow.backward")
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            viewModel.isCancelClicked = false
                            viewModel.isShowingCancelReasons = false
                        }
                    Spacer()
                    Text("cancel_booking")
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: "arrow.backward")
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.clear)
                }
                .padding()
                Text("please_select_the_reason_for_cancellation".localized() + " :")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                ForEach(viewModel.cancelReasons.indices, id: \.self) { index in
                    CancelReasonItem(
                        title: viewModel.cancelReasons[index].reason ?? "",
                        isSelected: selectedCancelIndex == index
                    )
                    .onTapGesture {
                        selectedCancelIndex = index
                        viewModel.selectedCancelReason = viewModel.cancelReasons[index]
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color(hex: "#F1F5F9"))
                    .padding(.vertical,10)
                    .padding(.horizontal,20)
                Text("other")
                    .font(.body)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                ZStack(alignment: .topLeading) {
                    // TextEditor with background color and padding
                    TextEditor(text: $otherReason)
                        .frame(height: 200)
                        .padding(.horizontal, 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke( Color(hex: "#C4C4C4") , lineWidth: 1.5)
                        )
                        .padding(.horizontal, 25)
                    
                    // Placeholder text
                    if otherReason.isEmpty {
                        Text("enter_your_reason")
                            .foregroundColor(.gray)
                            .padding(.leading, 35)
                            .padding(.top, 8)
                    }
                }
                LargeButton(
                    title: "cancel_ride".localized(),
                    backgroundColor: Color.white,
                    foregroundColor: Color(hex: "#663A80")
                ) {
                    if selectedCancelIndex == nil && otherReason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        showAlert = true
                    } else {
                        viewModel.cancelRide { value in
                            if value {
                                locationViewModel.navigationPath = []
                            }
                        }
                    }
                }
                .padding(.bottom)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(""),
                        message: Text("please_select_or_provide_a_reason_for_cancellation"),
                        dismissButton: .default(Text("ok"))
                    )
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .padding(.bottom, 20)
        }
        .scrollDisabled(!isKeyboardVisible)
        .fixedSize(horizontal: false, vertical: !isKeyboardVisible)
        .onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
            )
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                isKeyboardVisible = true
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                isKeyboardVisible = false
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
    }
}

#Preview {
    CancelRideSheet(locationViewModel: LocationSelectingViewModel(), viewModel: RideViewModel())
}
