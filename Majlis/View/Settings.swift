//
//  Settings.swift
//  Majlis
//
//  Created by aljawharah alowayridhi on 21/08/1447 AH.
//
import SwiftUI

struct SettingsView: View {
    
    // MARK: - Sheet Type
    enum ActiveSheet: Identifiable {
        case name
        case support
        var id: Int { hashValue }
    }
    
    // MARK: - States
    @State private var activeSheet: ActiveSheet?
    @AppStorage("userName") private var userName: String = "" // الاسم متاح في أي مكان
    @State private var isMuted = false
    
    // Support message
    @State private var supportMessage = ""
    @State private var showSentAlert = false
    
    // Name editing
    @State private var tempName: String = ""
    @State private var showEmptyNameAlert = false
    
    // MARK: - Colors
    let backgroundColor = Color(red: 0.99, green: 0.92, blue: 0.78)
    let buttonColor = Color(red: 0.46, green: 0.32, blue: 0.22)
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            VStack {
                
                // زر الرجوع
                HStack {
                    Spacer()
                    Button {
                        // back action
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .font(.system(size: 22, weight: .bold))
                            .frame(width: 56, height: 56)
                            .background(buttonColor.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
                
                // أزرار الإعدادات
                VStack(spacing: 20) {
                    
                    // 🔊 الصوت
                    SettingsButton(
                        title: "الصوت",
                        icon: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill",
                        color: buttonColor
                    ) {
                        isMuted.toggle()
                    }
                    
                    // ✏️ تغيير الاسم
                    SettingsButton(
                        title: "تغيير الاسم",
                        icon: "pencil",
                        color: buttonColor
                    ) {
                        // preload current stored name into temp buffer
                        tempName = userName
                        activeSheet = .name
                    }
                    
                    // 📧 الدعم
                    SettingsButton(
                        title: "الدعم",
                        icon: "envelope",
                        color: buttonColor,
                        showArrow: true
                    ) {
                        activeSheet = .support
                    }
                }
                
                Spacer()
                
                // المثلثات أسفل الصفحة
                ZigZagShape()
                    .fill(buttonColor.opacity(0.7))
                    .frame(height: 22)
            }
        }
        // Sheet واحد فقط
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .name:
                nameSheet
            case .support:
                supportSheet
            }
        }
        // Alert بعد الإرسال
        .alert("تم الإرسال", isPresented: $showSentAlert) {
            Button("حسناً", role: .cancel) { }
        } message: {
            Text("شكراً لتواصلك معنا! سيتم مراجعة رسالتك.")
        }
        // Alert للاسم الفارغ
        .alert("الاسم غير صالح", isPresented: $showEmptyNameAlert) {
            Button("حسناً", role: .cancel) { }
        } message: {
            Text("رجاءً اكتب اسمًا صحيحًا.")
        }
    }
    
    // MARK: - Sheet تغيير الاسم
    var nameSheet: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("تغيير الاسم")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(buttonColor)
                
                TextField("اكتب اسمك هنا", text: $tempName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .multilineTextAlignment(.trailing)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                
                HStack(spacing: 12) {
                    Button("إلغاء") {
                        // discard changes
                        tempName = userName
                        activeSheet = nil
                    }
                    .frame(maxWidth: .infinity, minHeight: 55)
                    .background(Color.gray.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    
                    Button("حفظ") {
                        saveName()
                    }
                    .frame(maxWidth: .infinity, minHeight: 55)
                    .background(isValidTempName ? buttonColor : buttonColor.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .disabled(!isValidTempName)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 40)
        }
    }
    
    private var isValidTempName: Bool {
        !tempName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveName() {
        let trimmed = tempName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            showEmptyNameAlert = true
            return
        }
        userName = trimmed
        activeSheet = nil
    }
    
    // MARK: - Sheet الدعم (نموذج رسائل)
    var supportSheet: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("الدعم")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(buttonColor)
                
                TextEditor(text: $supportMessage)
                    .frame(height: 200)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                
                Button("إرسال") {
                    sendSupportMessage()
                }
                .frame(maxWidth: .infinity, minHeight: 55)
                .background(buttonColor)
                .foregroundColor(.white)
                .cornerRadius(25)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 40)
        }
    }
    
    // MARK: - إرسال رسالة الدعم
    func sendSupportMessage() {
        guard !supportMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // هنا يمكن ربط الـ API لإرسال الرسالة فعلياً
        print("رسالة الدعم: \(supportMessage)")
        
        supportMessage = ""
        activeSheet = nil
        showSentAlert = true
    }
}

//////////////////////////////////////////////////

struct SettingsButton: View {
    var title: String
    var icon: String
    var color: Color
    var showArrow: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                if showArrow {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .medium))
                
                Spacer()
                
                Image(systemName: icon)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(height: 65)
            .background(color)
            .cornerRadius(30)
            .padding(.horizontal, 30)
        }
    }
}

//////////////////////////////////////////////////

struct ZigZagShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let height: CGFloat = 18
        let width: CGFloat = 24
        
        path.move(to: .zero)
        
        var x: CGFloat = 0
        while x < rect.width {
            path.addLine(to: CGPoint(x: x + width / 2, y: height))
            path.addLine(to: CGPoint(x: x + width, y: 0))
            x += width
        }
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

//////////////////////////////////////////////////

#Preview {
    SettingsView()
}
