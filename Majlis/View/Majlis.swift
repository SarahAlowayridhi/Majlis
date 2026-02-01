//
//  Majlis.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 13/08/1447 AH.
//


import SwiftUI

struct Majlis: View {

    @Environment(\.dismiss) private var dismiss

    let triangleColors: [Color] = [
        Color("Color 1"),
        Color("Color3"),
        Color("Color"),
        Color("Color 2")
    ]

    var body: some View {
        ZStack(alignment: .topLeading) {

            Color("background")
                .ignoresSafeArea()

            VStack(spacing: 0) {

                GeometryReader { geo in
                    let triangleHeight: CGFloat = 28
                    let triangleWidth: CGFloat = 28
                    let spacing: CGFloat = 1
                    let count = Int((geo.size.width + spacing) / (triangleWidth + spacing)) + 1

                    HStack(spacing: spacing) {
                        ForEach(0..<count, id: \.self) { i in
                            Triangle()
                                .fill(triangleColors[i % triangleColors.count])
                                .frame(width: triangleWidth, height: triangleHeight)
                        }
                    }
                }
                .frame(height: 28)

                Rectangle()
                    .fill(Color("Color 2"))
                    .frame(height: 5)

                Spacer().frame(height: 150)

                Text("يا محلى الفنجان مع سيحة البال في مجلس ما فيه نفس ثقيله..")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white.opacity(0.85))
                    )
                    .padding(.horizontal, 40)
                    .padding(.top, 10)

                Spacer().frame(height: 70)

                Image("FemalMajlis")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 320)
                    .padding(.bottom, 14)

                Rectangle()
                    .fill(Color.black.opacity(0.65))
                    .frame(height: 2)
                    .padding(.horizontal, 16)

                HStack(spacing: 22) {
                    ZStack {
                        Circle()
                            .fill(Color("Color 2").opacity(0.55))
                            .frame(width: 96, height: 96)

                        Image("mabkhara")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 58, height: 58)
                    }

                    ZStack {
                        Circle()
                            .fill(Color("Color 2").opacity(0.55))
                            .frame(width: 96, height: 96)

                        Image("tamersukkari")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 62, height: 62)
                    }

                    ZStack {
                        Circle()
                            .fill(Color("Color 2").opacity(0.55))
                            .frame(width: 96, height: 96)

                        Image("dallah")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 58, height: 58)
                    }
                }
                .padding(.vertical, 18)

                Spacer().frame(height: 10)

                GeometryReader { geo in
                    let triangleHeight: CGFloat = 18
                    let triangleWidth: CGFloat = 18
                    let spacing: CGFloat = 1
                    let count = Int((geo.size.width + spacing) / (triangleWidth + spacing)) + 1

                    HStack(spacing: spacing) {
                        ForEach(0..<count, id: \.self) { _ in
                            Triangle()
                                .fill(Color("Color 2").opacity(0.85))
                                .frame(width: triangleWidth, height: triangleHeight)
                                .rotationEffect(.degrees(180)) // عشان تكون “سنون” لتحت
                        }
                    }
                }
                .frame(height: 18)
                .padding(.bottom, 6)
            }
            .padding(.top, -62)

            HStack {
                Button { dismiss() } label: {
                    ZStack {
                        Circle()
                            .fill(Color("background b"))
                            .frame(width: 51, height: 51)

                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .semibold))
                    }
                }
                .buttonStyle(.plain)
                .padding(.leading, 20)
                .padding(.top, 2)

                Spacer()

                Image("finjal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.black, lineWidth: 3)
                        )
                        .frame(width: 90, height: 20)

                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.yellow)
                        .frame(width: 70, height: 18)

                    Text("٣")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 16)
                }
                .padding(.trailing, 20)
                .padding(.top, 2)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    Majlis()
}
