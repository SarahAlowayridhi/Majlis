//
//  Majlis.swift
//  Majlis
//
//  Created by Sarah Alowayridhi on 13/08/1447 AH.
//

import SwiftUI

struct Majlis: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: MajlisViewModel

    var body: some View {
        ZStack {

            // MARK: - Background
            Color(red: 0.98, green: 0.91, blue: 0.78)
                .ignoresSafeArea()

            VStack(spacing: 24) {

                // MARK: - Header
                HStack {

                    Toggle("", isOn: .constant(true))
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .yellow))
                        .scaleEffect(0.9)

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.brown)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                Spacer(minLength: 10)

                // MARK: - Text Card
                Text("زانت بكم وبطيبكم..\nبعد العود.. ما من قعود")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(16)
                    .padding(.horizontal)

                Spacer(minLength: 20)

                // MARK: - Sofa + Character (Male/Female)
                ZStack(alignment: .bottom) {

                    Image("sofa")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400)


                    if !viewModel.characterImageName.isEmpty {
                        Image(viewModel.characterImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180)
                            .offset(y: -20)
                    } else {
                        Text("ما تم اختيار شخصية")
                            .foregroundStyle(.red)
                            .padding(.bottom, 40)
                    }
                }

                Spacer(minLength: 20)

                // MARK: - Bottom Items
                HStack(spacing: 24) {
                    CircleItem(image: "cup")
                    CircleItem(image: "dates")
                    CircleItem(image: "dallah")
                }

                Spacer(minLength: 10)

                // ✅ مثلثات تحت
                TrianglePatternView(color: .brown, height: 30, triangleWidth: 20)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Reusable Circle Item
struct CircleItem: View {

    let image: String

    var body: some View {
        ZStack {

            Circle()
                .fill(Color.brown.opacity(0.8))
                .frame(width: 80, height: 80)

            Circle()
                .fill(Color(red: 0.86, green: 0.75, blue: 0.63))
                .frame(width: 65, height: 65)

            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 40)
        }
    }
}

// MARK: - Triangle Pattern Bottom View
struct TrianglePatternView: View {

    let color: Color
    let height: CGFloat
    let triangleWidth: CGFloat

    var body: some View {
        GeometryReader { geo in
            Path { path in
                let width = geo.size.width
                var x: CGFloat = 0

                while x < width {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x + triangleWidth / 2, y: height))
                    path.addLine(to: CGPoint(x: x + triangleWidth, y: 0))
                    path.closeSubpath()

                    x += triangleWidth
                }
            }
            .fill(color)
        }
        .frame(height: height)
    }
}

#Preview {
    let vm = MajlisViewModel()
    vm.selectedCharacter = .female
    return Majlis(viewModel: vm)
}

