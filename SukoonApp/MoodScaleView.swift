import SwiftUI

enum Mood: String, CaseIterable {//تعريف المشاعر
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
    @State private var selectedMood: Mood = .upset//لحفظ انبوت اليوزر

    var body: some View {
        VStack {
            HStack {
                Button {
                    // هنا يرجع لصفحة الكالندر
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.black.opacity(0.60))
                        .frame(width: 56, height: 56)
                        .background(Color("primarycolor").opacity(0.09))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                Spacer()
            }//HStack

            Text("How do you feel today?")
                .font(.system(size: 32, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
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
                .foregroundStyle(.black.opacity(0.70))
        

            // الوجوه الصغيرة
            HStack(spacing: 14) {
                ForEach(Array(Mood.allCases.enumerated()), id: \.element) { index, mood in
                    Button {
                        selectedMood = mood
                    } label: {
                        Image(mood.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60).opacity(selectedMood == mood ? 1.0 : 0.64)//يضلل المو محدده
                    }
                    .offset(y: arcOffset(for: index))
                }
                
            }//HStack
            
            Spacer()
            
            Button{
                //ينتقل الى صفحة الجورنال
            }label: {
                Text("Continue")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(Color("primarycolor"))
                        .clipShape(RoundedRectangle(cornerRadius: 55))
            }
            Spacer()
        }//VStack
        .padding(.horizontal, 20)
        .padding(.top, 10)
        
    }//body

    func arcOffset(for index: Int) -> CGFloat {
        let offsets: [CGFloat] = [-20, 10, 30, 10, -20]
        return offsets[index]
    }
}

#Preview {
    MoodScaleView()
}
