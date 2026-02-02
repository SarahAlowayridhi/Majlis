//
//  dallh.swift
//  Majlis
//
//  Created by maha althwab on 13/08/1447 AH.
//

import SwiftUI

struct CoffeeGameView: View {
    // متغير لتخزين نسبة التعبئة
    @State private var fillAmount: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            // خلفية فاتحة
            Color(red: 0.98, green: 0.96, blue: 0.92)
                .ignoresSafeArea()
            
            VStack {
                // صف الأزرار الدائرية في الأعلى
                HStack(spacing: 20) {
                    ForEach(1...3, id: \.self) { index in
                        Button(action: { }) {
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
                .padding(.top, 50)
                
                Spacer()
                
                // مجموعة الدلة والفنجال
                HStack(alignment: .bottom, spacing: 30) {
                    // صورة الفنجال
                    Image("redcup")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                    
                    // صورة الدلة قابلة للضغط
                    Button(action: {
                        withAnimation(.easeInOut) {
                            if fillAmount >= 1.0 {
                                // إذا وصل للنهاية، يرجع للصفر
                                fillAmount = 0.0
                            } else {
                                // يزيد التعبئة بنسبة 10%
                                fillAmount += 0.1
                            }
                        }
                    }) {
                        Image("dallah")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 300)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // --- الخط العريض (شريط التعبئة) ---
                ZStack(alignment: .leading) {
                    // الخلفية
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 300, height: 24) // كبّرنا السمك قليلاً ليظهر كـ "خط عريض"
                    
                    // الجزء الملون
                    Capsule()
                        .fill(Color.brown)
                        .frame(width: 300 * fillAmount, height: 24)
                }
                .padding(.top, 40)
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

