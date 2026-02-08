//
//  StartScreen.swift
//  Majlis
//
//  Created by Teif May on 14/08/1447 AH.
//

import SwiftUI

struct StartScreen: View {
    var body: some View {
        ZStack {
            Image("SplashBG")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 333, height: 188)
                    .accessibilityHidden(true)

                VStack(spacing: 6) {
                    Text("مجلس الأجاويد")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(Color(red: 0.28, green: 0.16, blue: 0.10))
                        .multilineTextAlignment(.center)

                    Text("ضيافة عربية أصيلة")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color(red: 0.45, green: 0.30, blue: 0.22))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    StartScreen()
}
