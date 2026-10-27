import SwiftUI

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
    static let ink      = i3Hex("#16131F")
    static let accent   = i3Hex("#4B3AA8")
    static let btn      = i3Hex("#5B2BB8")
    static let chipBG   = i3Hex("#E4DCFB")
    static let chipText = i3Hex("#5B46C4")
    static let muted    = i3Hex("#3A3744")
    static let dotGray  = i3Hex("#C9C6D3")
}

private struct I3Card: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 18) {
                Text("TEMPORARY")
                    .font(.system(size: 13, weight: .semibold))
                    .tracking(0.6)
                    .foregroundColor(I3.chipText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(I3.chipBG))

                Text("I just need to get this out of my chest, no one will ever read it…")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(I3.ink)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 26)
            .padding(.top, 26)
            .padding(.bottom, 80)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.white.opacity(0.65))
                    .shadow(color: I3.btn.opacity(0.25), radius: 20, x: 0, y: 12)
            )

            Image("Image1")
                .resizable()
                .scaledToFit()
                .frame(width: 96, height: 100)
                .offset(x: -26, y: 34)
        }
    }
}

struct Intro3View: View {
    var onSkip: () -> Void = {}
    @State private var navigatetonext = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [i3Hex("#EAF3E6"), i3Hex("#F1EEFA"), i3Hex("#F7F6FB")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    Button("Skip", action: onSkip)
                        .font(.system(size: 15))
                        .foregroundColor(I3.muted.opacity(0.8))
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Write freely.")
                        .foregroundColor(I3.ink)
                    Text("It won't stay.")
                        .foregroundColor(I3.accent)
                }
                .font(.system(size: 38, weight: .heavy))
                .padding(.top, 70)

                I3Card()
                    .padding(.top, 64)
                    .padding(.leading, 14)
                    .padding(.trailing, 6)

                Text("Start a temporary journal to say anything. It deletes itself automatically, no trace left.")
                    .font(.system(size: 18))
                    .foregroundColor(I3.muted)
                    .lineSpacing(3)
                    .padding(.top, 70)
                    .padding(.leading, 4)

                Spacer()

                ZStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                        Capsule()
                            .fill(Color("primarycolor").opacity(0.7))
                            .frame(width: 24, height: 8)
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }

                    HStack {
                        Spacer()
                        Button {
                            navigatetonext = true
                        } label: {
                            Image(systemName: "arrow.forward")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundStyle(.white.opacity(0.60))
                                .frame(width: 56, height: 56)
                                .background(Color("primarycolor"))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 28)
            .padding(.top, 12)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigatetonext) {
            Text("الصفحة التالية")
        }
    }
}

#Preview {
    Intro3View()
}
