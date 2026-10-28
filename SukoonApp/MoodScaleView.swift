import SwiftUI

enum Mood: String, CaseIterable { // تعريف المشاعر
    case upset = "Upset"
    case low = "Low"
    case unsure = "Unsure"
    case good = "Good"
    case great = "Great"

    var imageName: String {
        rawValue.lowercased()
    }
}

struct MoodScaleView: View {
    // اليوم اللي ضغط عليه اليوزر في الهوم
    var date: Date = .now

    @Environment(\.closeFlow) private var closeFlow
    @Environment(\.dismiss) private var dismiss

    @State private var selectedMood: Mood = .upset // لحفظ انبوت اليوزر
    @State private var showAlert = false
    @State private var goToTemporaryPage = false
    @State private var goToJournalPage = false

    var body: some View {
        VStack {

            Text("How do you feel today?")
                .font(.system(size: 32, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color("titleText"))
                .padding(.horizontal, 40)
                .padding(.top, 40)

            Spacer()

            // الوجه الكبير
            Image(selectedMood.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 145, height: 145)

            Text(selectedMood.rawValue)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(Color("titleText"))

            ZStack {
                // مراكز الوجوه
                let points: [CGPoint] = [
                    CGPoint(x: 40,  y: 40),    // upset
                    CGPoint(x: 95,  y: 120),   // low
                    CGPoint(x: 180, y: 165),   // unsure
                    CGPoint(x: 265, y: 120),   // good
                    CGPoint(x: 320, y: 40)     // great
                ]

                // الخط: يمر بكل النقاط
                Path { path in
                    path.move(to: points[0])
                    path.addQuadCurve(to: points[2], control: CGPoint(x: 70, y: 170))
                    path.addQuadCurve(to: points[4], control: CGPoint(x: 290, y: 170))
                }
                .stroke(Color("primarycolor").opacity(0.55),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round))

                // الوجوه
                ForEach(Array(Mood.allCases.enumerated()), id: \.element) { index, mood in
                    Button {
                        selectedMood = mood
                    } label: {
                        ZStack {
                            // البوردر بلون background
                            Image(mood.imageName)
                                .resizable()
                                .scaledToFit()
                                .brightness(1)
                                .colorMultiply(Color("background"))
                                .scaleEffect(1.13)

                            Image(mood.imageName)
                                .resizable()
                                .scaledToFit()
                                .opacity(selectedMood == mood ? 1.0 : 0.64)
                        }
                        .frame(width: 60, height: 60)
                    }
                    .buttonStyle(.plain)
                    .position(points[index])
                } // loop
            } // ZStack
            .frame(width: 360, height: 220)
            .padding(.vertical, 50)
            .frame(height: 150)

            Spacer()

            Button {
                showAlert = true
            } label: {
                Text("Continue")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(Color("primarycolor"))
                    .clipShape(RoundedRectangle(cornerRadius: 55))
            }
            .padding()
            .alert("Make it temporary", isPresented: $showAlert) {
                Button("Delete After Closing", role: .destructive) {
                    goToTemporaryPage = true
                }
                Button("Keep in Journal", role: .cancel) {
                    goToJournalPage = true
                }
            } message: {
                Text("Would you like to make this entry to disappear immediately after closing?")
            }
        } // VStack
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("background").ignoresSafeArea())
        .navigationDestination(isPresented: $goToTemporaryPage) {
            TemporaryView(selectedMood: selectedMood, selectedDate: date)
        }
        .navigationDestination(isPresented: $goToJournalPage) {
            ReflectionPageView(selectedMood: selectedMood)
        }
    } // body
}

#Preview {
    NavigationStack {
        MoodScaleView()
    }
}
