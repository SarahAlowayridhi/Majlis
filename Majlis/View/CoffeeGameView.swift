//
//  dallh.swift
//  Majlis
//
//  Created by maha althwab on 13/08/1447 AH.
//

import SwiftUI

struct CoffeeGameView: View {
    @State private var fillAmount: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            // الخلفية
            Color(red: 0.98, green: 0.96, blue: 0.92)
                .ignoresSafeArea()
            
            VStack {
                
                // الأزرار الدائرية بالأعلى
                HStack(spacing: 20) {
                    ForEach(1...3, id: \.self) { _ in
                        Button(action: {}) {
                            Circle()
                                .fill(Color.brown.opacity(0.8))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "plus")
                                        .foregroundColor(.white)
                                )
                                .shadow(radius: 3)
                        }
                    }
                }
                .padding(.top, 40)
                
                Spacer()
                
                // ⭐ الفنجال + الدلة (متمركزين بالوسط)
                HStack(alignment: .bottom, spacing: 30) {
                    
                    Image("redcup")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90)
                        .offset(x: 60) // ← قربناه من الدلة
                    
                    Button {
                        withAnimation(.easeInOut) {
                            fillAmount = fillAmount >= 1.0 ? 0.0 : fillAmount + 0.1
                        }
                    } label: {
                        Image("dallah")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 240)
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
                
                // شريط التعبئة
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 300, height: 24)
                    
                    Capsule()
                        .fill(Color.brown)
                        .frame(width: 300 * fillAmount, height: 24)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct CoffeeGameView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeGameView()
    }
}

