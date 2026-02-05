//
//  DallahShop.swift
//  Majlis
//
//  Created by Ruba Arif on 17/08/1447 AH.
//

import SwiftUI

struct DallahSelectionView: View {

    @State private var selectedPage = 0

    var body: some View {
        ZStack {

            // Background
            Color(red: 0.99, green: 0.93, blue: 0.78)
                .ignoresSafeArea()

            VStack {

                // Top 
                HStack {

                    // Fake toggle
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.brown, lineWidth: 2)
                            .frame(width: 80, height: 34)

                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.yellow)
                            .frame(width: 36, height: 26)
                            .padding(.leading, 4)
                    }

                    Spacer()

                    // Back button
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.brown)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                Spacer(minLength: 40)

                // Quote Card
                Text("دلّع نفسك بدله تطيب الخاطر..")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: 280)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(12)

                Spacer(minLength: 20)

                // Page Indicator (fake dots)
                HStack(spacing: 8) {
                    Circle()
                        .fill(selectedPage == 0 ? Color.brown : Color.brown.opacity(0.3))
                        .frame(width: 8, height: 8)

                    Circle()
                        .fill(selectedPage == 1 ? Color.brown : Color.brown.opacity(0.3))
                        .frame(width: 8, height: 8)
                }

                Spacer(minLength: 20)

                // Dallah Swipe
                TabView(selection: $selectedPage) {

                    // Golden Dallah
                    Image("dallah")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 220)
                        .tag(0)

                    // Silver Dallah
                    Image("silver")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 220)
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 280)

                Spacer()

                // Select Button
                Button(action: {}) {
                    Text("اختر")
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.brown)
                        .cornerRadius(20)
                }

                Spacer(minLength: 20)

                // Bottom Decoration
                HStack(spacing: 6) {
                    ForEach(0..<15, id: \.self) { _ in
                        BottomTriangle()
                            .fill(Color.brown)
                            .frame(width: 12, height: 8)
                    }
                }
                .padding(.bottom, 12)
            }
        }
    }
}



#Preview {
    DallahSelectionView()
}
