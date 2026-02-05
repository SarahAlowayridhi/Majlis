//
//  dallh.swift
//  Majlis
//
//  Created by maha althwab on 13/08/1447 AH.
//

import SwiftUI

struct CoffeeGameView: View {

    // نسبة التعبئة
    @State private var fillAmount: CGFloat = 0.0
    
    // تايمر التعبئة
    @State private var fillTimer: Timer?
    
    // ثلث الخط
    let threshold: CGFloat = 0.33
    
    // ⭐ أسماء صور الخيارات من Assets
    let coffeeOptions = ["choose", "chosse right", "choose wrong"]

    var body: some View {
        ZStack {
            
            // الخلفية
            Color(red: 0.98, green: 0.96, blue: 0.92)
                .ignoresSafeArea()
            
            VStack {
                
                // MARK: - خيارات الصور بالأعلى
                HStack(spacing: 28) {
                    
                    ForEach(coffeeOptions, id: \.self) { imageName in
                        
                        Button(action: {
                            print("\(imageName) tapped")
                        }) {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70) // 👈 كبرناها
                                .shadow(radius: 2)
                        }
                    }
                }
                .padding(.top, 40)
                
                Spacer()
                
                // MARK: - الفنجال + الدلة
                HStack(alignment: .bottom, spacing: 30) {
                    
                    Image("redcup")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90)
                        .offset(x: 60)
                    
                    Image("dallah")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    startFilling()
                                }
                                .onEnded { _ in
                                    stopFilling()
                                }
                        )
                }
                
                Spacer()
                
                // MARK: - شريط التعبئة
                ZStack(alignment: .leading) {
                    
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 300, height: 24)
                    
                    Capsule()
                        .fill(progressColor)
                        .frame(width: 300 * fillAmount, height: 24)
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    // MARK: - Logic
    
    func startFilling() {
        guard fillTimer == nil else { return }
        
        fillTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            withAnimation(.linear(duration: 0.05)) {
                if fillAmount < 1.0 {
                    fillAmount += 0.01
                } else {
                    fillAmount = 0.0
                }
            }
        }
    }
    
    func stopFilling() {
        fillTimer?.invalidate()
        fillTimer = nil
    }
    
    // MARK: - لون الشريط
    
    var progressColor: Color {
        if fillAmount >= threshold && fillAmount <= threshold + 0.02 {
            return .green
        } else if fillAmount > threshold {
            return .red
        } else {
            return .brown
        }
    }
}

// MARK: - Preview

struct CoffeeGameView_Previews: PreviewProvider {
    static var previews: some View {
        CoffeeGameView()
    }
}

