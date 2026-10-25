



//
import SwiftUI
struct Intropage: View {
    var body: some View {
        //الجزء العلوي
        VStack{
            HStack{
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
            Spacer()
            
            
            
            
            // الوسط الورة والنصوص
            // اقتراح ممكن نخليها تتحرك
            VStack(spacing:20){
                // الصورة
                Image("moodgang")
                    .resizable()
                    .scaledToFit()
                    .frame(height:250)
                
                
                // العنوان الرئيسي
                Text("Every feeling Deserve a page")
                    .font(.system(size:32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal,50)
                
                //النص الفرعي
                Text("Meet the gang, they will help you write about however you feel today.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,20)
                Spacer()
                
            }
                
                // مؤشرات التصفح اللي تحت
            ZStack{
                HStack(spacing:6) {
                    Capsule()
                        .fill(Color("primarycolor").opacity(0.7))
                        .frame(width: 24, height: 8)
                    
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                    
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                    
                }
                
                // زر السهم البنفسجي
                HStack{
                    Spacer()
                    
                    
                    Button {
                        // الزر البنفسجي
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
                .padding(.horizontal,24)
                .padding(.bottom,20)
            
            .padding(.vertical)
        }
    }
}
#Preview {
    Intropage()
}
//
//  Created by Norah Bindokhi on 13/05/1448 AH.
//


