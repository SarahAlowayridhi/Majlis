//
//  Map.swift
//  Majlis
//
//  Created by Ruba Arif on 17/08/1447 AH.
//

import SwiftUI

struct ContentView: View {

    // Swipe state
    @State private var selectedPage = 0

    var body: some View {
        ZStack {

            // Background
            Color(red: 0.99, green: 0.93, blue: 0.78)
                .ignoresSafeArea()

            VStack {

                // Top Controls
                HStack {

                    // Toggle (Fake / UI only)
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

                    // Icons
                    HStack(spacing: 12) {
                        CircleButton(system: "gearshape.fill")
                        CircleButton(system: "storefront.circle.fill")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                Spacer(minLength: 50)

                // Title + Map (Swipe)
                TabView(selection: $selectedPage) {

                    // Central
                    VStack(spacing: 30) {
                        Text("المنطقة الوسطى")
                            .font(.title3)
                            .foregroundColor(.black)

                        Image("MapCentral")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                    }
                    .tag(0)

                    // East
                    VStack(spacing: 30) {
                        Text("المنطقة الشرقية")
                            .font(.title3)
                            .foregroundColor(.black)

                        Image("MapEast")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                    }
                    .tag(1)

                    // South
                    VStack(spacing: 30) {
                        Text("المنطقة الجنوبية")
                            .font(.title3)
                            .foregroundColor(.black)

                        Image("MapSouth")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                    }
                    .tag(2)

                    // West
                    VStack(spacing: 30) {
                        Text("المنطقة الغربية")
                            .font(.title3)
                            .foregroundColor(.black)

                        Image("MapWest")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                    }
                    .tag(3)

                    // North
                    VStack(spacing: 30) {
                        Text("المنطقة الشمالية")
                            .font(.title3)
                            .foregroundColor(.black)

                        Image("MapNorth")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 300)
                    }
                    .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 380)

                // Swipe Indicator Dots ✅
                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self) { index in
                        Circle()
                            .fill(
                                selectedPage == index
                                ? Color.brown
                                : Color.brown.opacity(0.3)
                            )
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 8)

                Spacer()

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

// MARK: - SF Symbol Buttons
struct CircleButton: View {
    var system: String

    var body: some View {
        Button(action: {}) {
            Image(systemName: system)
                .foregroundColor(.white)
                .padding(10)
                .background(Circle().fill(Color.brown))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Triangle Shape
struct BottomTriangle: Shape {

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ContentView()
}
