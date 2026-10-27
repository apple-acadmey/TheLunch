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
    static let accent   = i3Hex("#7C4AB2")
    static let chipBG   = i3Hex("#E4DCFB")
    static let chipText = i3Hex("#5B46C4")
    static let muted    = i3Hex("#3A3744")
    static let gray     = i3Hex("#6B6B73")
    static let shadow   = i3Hex("#5B2BB8")
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

struct Intro3View: View {
    var onSkip: () -> Void = {}
    @State private var navigatetonext = false

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    Button("Skip", action: onSkip)
                        .font(.system(size: 14))
                        .foregroundColor(I3.muted.opacity(0.6))
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Write freely.")
                        .foregroundColor(I3.ink)
                    Text("It won't stay.")
                        .foregroundColor(I3.accent)
                }
                .font(.system(size: 32, weight: .bold))
                .padding(.top, 50)

                I3Card()
                    .padding(.top, 46)
                    .padding(.horizontal, 22)

                Text("Start a temporary journal to say anything. It deletes itself automatically, no trace left.")
                    .font(.system(size: 15))
                    .foregroundColor(I3.gray)
                    .lineSpacing(2)
                    .padding(.top, 80)
                    .padding(.leading, 22)

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
                                .font(.system(size: 26, weight: .light))
                                .foregroundStyle(.white)
                                .frame(width: 60, height: 60)
                                .background(Color("primarycolor"))
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 6)
                    }
                }
                .padding(.bottom, 50)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
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
