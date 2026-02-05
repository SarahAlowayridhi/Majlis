//
//  Map.swift
//  Majlis
//
//  Created by Ruba Arif on 17/08/1447 AH.
//

import SwiftUI

struct ContentView: View {

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

                // Title
                Text("المنطقة الوسطى")
                    .font(.title3)
                    .foregroundColor(.black)

                Spacer(minLength: 30)

                // Map
                Image("MapCentral")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300)

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

//  SF Symbol - icons
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

// triangle shape for decoration
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
