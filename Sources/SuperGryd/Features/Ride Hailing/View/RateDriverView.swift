//
//  RateDriverView.swift
//
//
//  Created by Aswin V Shaji on 04/11/24.
//

import SwiftUI

struct RateDriverView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var navigationPath: [String]
    @State private var rating: Int = 0
    @State private var additionalComments = ""
    private let maxRating = 5
    private let unselectedImage = Image("ratingUnselected", bundle: Bundle.module)
    private let selectedImage = Image("ratingSelected", bundle: Bundle.module)
    var body: some View {
        ZStack {
            Color(hex: "#003B95")
                .ignoresSafeArea()
            VStack{
                Button{
                    navigationPath.removeLast()
                }label: {
                    HStack{
                        Image("back", bundle: Bundle.module)
                        Text("rating")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.white)
                        Spacer()
                    }
                }
                .padding()
                Spacer()
                ZStack(alignment: .bottom){
                    VStack{
                        Spacer().frame(height: 50)
                        Text("Henry")
                            .font(.headline)
                        Text("how_was_your_trip")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding()
                        Text("your_feedback_will_help_improve_our_services")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        HStack(spacing: 8) {
                            ForEach(1...maxRating, id: \.self) { starIndex in
                                (starIndex <= rating ? selectedImage : unselectedImage)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(5)
                                    .onTapGesture {
                                        if rating == starIndex {
                                            rating = 0  
                                        } else {
                                            rating = starIndex
                                        }
                                    }
                            }
                        }
                        .padding()
                        ZStack(alignment: .topLeading) {
                            // TextEditor with background color and padding
                            TextEditor(text: $additionalComments)
                                .padding(8)
                                .scrollContentBackground(.hidden)
                                .background(Color(hex: "#EFEFF4").opacity(0.5))
                                .cornerRadius(8)
                                .frame(width: UIScreen.main.bounds.width - 80, height: 120)
                            
                            // Placeholder text
                            if additionalComments.isEmpty {
                                Text("additional_comments")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 16)
                                    .padding(.top, 16)
                            }
                        }
                        .padding()
                        LargeButton(title: "submit_review".localized(),
                                    backgroundColor: Color(hex: "#006CE3"),
                                    cornerRadius: 8)
                        {
                            navigationPath = []
                        }
                        .padding(.bottom)
                    }
                    .frame(width: UIScreen.main.bounds.width - 40, height: 540)
                    .background(colorScheme == .dark
                                ? Color.black
                                    
                                : Color.white
                                    )
                    .cornerRadius(10)
                    Image("profile",bundle: Bundle.module)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100,alignment: .bottom)
                        .offset(y:-490)
                }
                Spacer()
            }
        }
        .navigationBarTitle("")
        .toolbar(.hidden)
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    RateDriverView(navigationPath: .constant([]))
}
