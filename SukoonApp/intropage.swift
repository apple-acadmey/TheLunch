import SwiftUI

// 1. هيكل البيانات الأساسي
struct OnboardingItem {
    let imageName: String
    let title: String
    let subtitle: String
}

private struct I3Card: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 16) {
                Text("TEMPORARY")
                    .font(.system(size: 12, weight: .semibold))
                    .tracking(0.5)
                    .foregroundColor(Color("primarycolor"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color("primarycolor").opacity(0.2)))

                Text("I just need to get this out of my chest, no one will ever read it…")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("titleText"))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 24)
            .padding(.top, 26)
            .padding(.bottom, 58)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color("entrybox"))
                    .shadow(color: Color("primarycolor").opacity(0.16), radius: 18, x: 0, y: 10)
            )

            Image("Image1")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .offset(x: -4, y: 40)
        }
    }
}

// 3. الواجهة الرئيسية
struct onboarding: View {
    @Binding var HasSeenOnbording : Bool
    @State private var page = 0
    @State private var showHome = false // متغير لتفعيل الانتقال للهوم
    let pagesCount = 4

    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                
                // زر التخطي (Skip) العلوي - يختفي في الصفحة الأخيرة
                HStack {
                    Spacer()
                    if page < 3 {
                        Button(action: {
                            HasSeenOnbording = true // الانتقال للهوم عند الضغط على skip
                        }) {
                            Text("Skip")
                                .font(.subheadline)
                                .foregroundColor(Color("titleText").opacity(0.6))
                        }
                    }
                }
                .frame(height: 30)
                .padding(.horizontal)
                .padding(.top, 10)

                // الـ TabView الخاص بالسحب بين الصفحات (Swipe)
                TabView(selection: $page) {
                    
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
                            .foregroundColor(Color("titleText"))
                            .padding(.horizontal, 30)

                        Text("Meet the gang, they will help you write about however you feel today.")
                            .font(.body)
                            .foregroundColor(Color("titleText").opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        Spacer()
                    }
                    .tag(0)

                    // --- الصفحة الثانية (بوكس البرومبت) ---
                    VStack(alignment: .leading, spacing: 0) {
                        Text("How are you feeling?")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color("titleText"))
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
                                .shadow(color: Color("primarycolor").opacity(0.16),
                                        radius: 18, x: 0, y: 10)

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Today's Prompt")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(Color("primarycolor"))

                                Text("What is weighing on your heart today?")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("titleText"))
                                    .lineSpacing(3)
                            }
                            .padding(.horizontal, 28)
                            .padding(.top, 28)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 15)
                        
                        Spacer()
                    }
                    .tag(1)

                    // --- الصفحة الثالثة (كرت فاطمة) ---
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Write freely.")
                                .foregroundColor(Color("titleText"))
                            Text("It won't stay.")
                                .foregroundColor(Color("primarycolor"))
                        }
                        .font(.system(size: 32, weight: .bold))
                        .padding(.top, 30)

                        I3Card()
                            .padding(.top, 30)
                            .padding(.horizontal, 4)

                        Text("Start a temporary journal to say anything. It deletes itself automatically, no trace left.")
                            .font(.system(size: 15))
                            .foregroundColor(Color("titleText").opacity(0.6))
                            .lineSpacing(2)
                            .padding(.top, 50)

                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .tag(2)

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
                                .foregroundColor(Color("titleText"))
                                .padding(.horizontal, 24)

                            Text("Check in daily, track your mood, and be gentle to yourself")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color("titleText").opacity(0.6))
                                .padding(.horizontal, 24)
                        }
                        .padding(.top, 25)
                        
                        Spacer()
                    }
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                // الجزء السفلي: مؤشرات النقاط وزر Start Journaling
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pagesCount, id: \.self) { i in
                            Capsule()
                                .fill(i == page ? Color("primarycolor") : Color("primarycolor").opacity(0.25))
                                .frame(width: i == page ? 24 : 8, height: 8)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .animation(.easeInOut, value: page)

                    if page == 3 {
                        Button(action: {
                            HasSeenOnbording = true// الانتقال للهوم عند الضغط على Start journaling
                        }) {
                            Text("Start journaling")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color("primarycolor"))
                                .clipShape(Capsule())
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
            .padding(.vertical)
        }
        // هذا الجزء هو المسؤول عن فتح واجهة الهوم عندما تصبح showHome = true
        .fullScreenCover(isPresented: $showHome) {
            CalendarHomeScreen()
        
        }
    }
}

// معاينة الواجهة
#Preview {
    onboarding(HasSeenOnbording: .constant(false))
}
