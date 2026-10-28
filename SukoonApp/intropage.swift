import SwiftUI

// 1. هيكل البيانات
struct OnboardingItem {
    let imageName: String
    let title: String
    let subtitle: String
}

// 2. كلاس الألوان الخاص بالصفحة الثالثة (كرت فاطمة)
private func i3Hex(_ hex: String) -> Color {
    let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var v: UInt64 = 0
    Scanner(string: s).scanHexInt64(&v)
    return Color(
        red: Double((v >> 16) & 0xFF) / 255,
        green: Double((v >> 8) & 0xFF) / 255,
        blue: Double(v & 0xFF) / 255
    )
}

private enum I3 {
    static let ink = i3Hex("#16131F")
    static let accent = i3Hex("#7C4AB2")
    static let chipBG = i3Hex("#E4DCFB")
    static let chipText = i3Hex("#5B46C4")
    static let muted = i3Hex("#3A3744")
    static let gray = i3Hex("#6B6B73")
    static let shadow = i3Hex("#5B2BB8")
}

private struct I3Card: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 16) {
                Text("TEMPORARY")
                    .font(.system(size: 12, weight: .semibold))
                    .tracking(0.5)
                    .foregroundColor(I3.chipText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(I3.chipBG))

                Text("I just need to get this out of my chest, no one will ever read it…")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(I3.ink)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 24)
            .padding(.top, 26)
            .padding(.bottom, 58)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: I3.shadow.opacity(0.16), radius: 18, x: 0, y: 10)
            )

            Image("Image1")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .offset(x: -4, y: 40)
        }
    }
}

// 3. الواجهة الرئيسية (View) المدمجة
struct onboarding: View {
    @State private var currentPage = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // زر التخطي (Skip) العلوي
            HStack {
                Spacer()
                Button(action: {
                    print("skip clicked")
                }) {
                    Text("skip")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // محتوى الصفحة المتغير حسب رقم currentPage
            VStack(spacing: 0) {
                if currentPage == 0 {
                    // --- الصفحة الأولى ---
                    VStack(spacing: 20) {
                        Spacer()
                        Image("moodgang")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                        
                        Text("Every feeling Deserve a page")
                            .font(.system(size: 32, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .padding(.horizontal, 30)

                        Text("Meet the gang, they will help you write about however you feel today.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        Spacer()
                    }
                    
                } else if currentPage == 1 {
                    // --- الصفحة الثانية (ببوكس البرومبت) ---
                    VStack(alignment: .leading, spacing: 0) {
                        Text("How are you feeling?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 24)
                            .padding(.top, 20)

                        Image("gangset")
                            .resizable()
                            .scaledToFit()
                            .padding(.horizontal, 24)
                            .padding(.top, 15)

                        ZStack(alignment: .topLeading) {
                            Image("prmptbox")
                                .resizable()
                                .scaledToFit()
                                .shadow(color: Color(red: 91/255, green: 43/255, blue: 184/255).opacity(0.16),
                                        radius: 18, x: 0, y: 10)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Today's Prompt")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Color("primarycolor"))

                                Text("What is weighing on your heart today?")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                                    .lineSpacing(3)
                            }
                            .padding(.horizontal, 28)
                            .padding(.top, 28)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 15)
                        
                        Spacer()
                    }
                    
                } else if currentPage == 2 {
                    // --- الصفحة الثالثة (كرت فاطمة) ---
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Write freely.")
                                .foregroundColor(I3.ink)
                            Text("It won't stay.")
                                .foregroundColor(I3.accent)
                        }
                        .font(.system(size: 32, weight: .bold))
                        .padding(.top, 30)

                        I3Card()
                            .padding(.top, 30)
                            .padding(.horizontal, 4)

                        Text("Start a temporary journal to say anything. It deletes itself automatically, no trace left.")
                            .font(.system(size: 15))
                            .foregroundColor(I3.gray)
                            .lineSpacing(2)
                            .padding(.top, 50)

                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    
                } else if currentPage == 3 {
                    // --- الصفحة الرابعة والأخيرة ---
                    VStack(spacing: 0) {
                        Spacer()
                        Image("gang4")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 230)
                        
                        VStack(spacing: 12) {
                            Text("Your safe little space is ready")
                                .font(.system(size: 28, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .padding(.horizontal, 24)

                            Text("Check in daily, track your mood, and be gentle to yourself")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 24)
                        }
                        .padding(.top, 25)
                        
                        Spacer()
                    }
                }
            }
            
            // الجزء السفلي الثابت: مؤشرات النقاط وزر التنقل أو البدء
            ZStack {
                // مؤشرات النقاط (الكبسولة المتحركة)
                HStack(spacing: 6) {
                    ForEach(0..<4, id: \.self) { index in
                        if currentPage == index {
                            Capsule()
                                .fill(Color("primarycolor").opacity(0.7))
                                .frame(width: 24, height: 8)
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                
                // أزرار التحكم بالسفل
                HStack {
                    Spacer()
                    
                    if currentPage < 3 {
                        // زر السهم للانتقال للخطوة التالية في نفس الصفحة
                        Button {
                            withAnimation {
                                currentPage += 1
                            }
                        } label: {
                            Image(systemName: "arrow.forward")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundStyle(.white.opacity(0.60))
                                .frame(width: 56, height: 56)
                                .background(Color("primarycolor"))
                                .clipShape(Circle())
                        }
                    } else {
                        // زر Start journaling باللون البنفسجي والستايل القديم
                        Button(action: {
                            print("start journaling clicked")
                        }) {
                            Text("Start journaling")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color("primarycolor"))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
        .padding(.vertical)
    }
}

// معاينة الواجهة
#Preview {
    onboarding()
}
