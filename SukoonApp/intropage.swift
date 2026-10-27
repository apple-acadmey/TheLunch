


//
import SwiftUI
struct Intropage: View {
    // متغير للانتقال للصفحة الثالثة
    @State private var navigatetonext = false
    
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 0) {
                
                
                
                //الجزء العلوي
                
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
                    .padding(.top,10)
            
                    
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
                                navigatetonext = true
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
                }
                // وجهة الانتقال عند الضغط على السهم
                .navigationDestination (isPresented: $navigatetonext) {
                    IntroPagetwo()
                }
                .padding(.vertical)
            }
        }
    }
//  الشاشة الثانية
struct IntroPagetwo: View {
    // عشان ننتقل للصفحة اللي بعدها
    //الغي السهم اللي فوق
    @State private var navigatetonext = false
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 0) {
                
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
                .padding(.top,30)

                
                // العنوان الرئيسي
                Text("How are you feeling?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal,24)
                    .padding(.top,20)
                    
                // هنا الصورة حقت القانق
                Image(.gangset)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal,24)
                    .padding(.top,20)
                   
                // بوكس البرومبت
                ZStack(alignment: .topLeading){
                    Image("prmptbox")
                        .resizable()
                                                .scaledToFit()
                                                .shadow(color: Color(red: 91/255, green: 43/255, blue: 184/255).opacity(0.16),
                                                        radius: 18, x: 0, y: 10)
                                            
                    
                    VStack(alignment: .leading, spacing:6) {
                        Text("Today's Prompt")
                            .font(.system(size:11, weight: .bold))
                            .foregroundColor(Color("primarycolor"))
                        
                        Text("What is weighing on your heart today?")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .lineSpacing(3)
                        
                    }
                    .padding(.horizontal, 28)
                    .padding(.top,28)
                    
                }
                .padding(.horizontal,24)
                .padding(.top,20)
                Spacer()
                
                ZStack{
                    HStack(spacing:6) {
                        
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                        
                        Capsule()
                            .fill(Color("primarycolor").opacity(0.7))
                            .frame(width: 24, height: 8)
                        
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
                            navigatetonext = true
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
                
            }
            .navigationDestination (isPresented: $navigatetonext) {
                IntroPagethree()
            }
            .toolbar(.hidden, for: .navigationBar)
           
        }
    }
}


// هنا كود فاطمة
struct IntroPagethree: View {
    // عشان ننتقل للصفحة اللي بعدها
    var body: some View {
    }
}

#Preview {
    Intropage()
}
//
//  Created by Norah Bindokhi on 13/05/1448 AH.
//


