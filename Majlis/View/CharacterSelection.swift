//
//  CharacterSelection.swift
//  Majlis
//
//  Created by Teif May on 14/08/1447 AH.
//

import SwiftUI

struct CharacterSelection: View {
    @State private var name: String = ""

    var body: some View {
        ZStack {
            Image("backgroundIM")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 1) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)

                    TextField("اكتب اسمك هنا", text: $name)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                }
                .frame(height: 50)
                .padding(.horizontal, 40)
                .padding(.top, 333)

                Spacer()

                HStack(spacing: 2) {
                    characterOption(imageName: "Man")
                    characterOption(imageName: "Woman")
                }
                .padding(.bottom, 300)
            }
        }
    }

    @ViewBuilder
    private func characterOption(imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 177, height: 177)
            .contentShape(Rectangle())
    }
}

#Preview {
    CharacterSelection()
}
