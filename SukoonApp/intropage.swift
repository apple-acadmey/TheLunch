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
// الشاشة الثانية
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
Intro3View()
}
.toolbar(.hidden, for: .navigationBar)

}
}
}


// هنا كود فاطمة


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
startpage ()
}
}
}


// الصفحة الاخيرة


struct startpage: View{
var body: some View{

VStack(spacing:0) {
// الصورة الاولى
Image("gang4")
.resizable()
.scaledToFit()
.frame(height:250)
.padding(.top,50)
// النص الفرعي
VStack(spacing:12) {
Text("Your safe little space is ready")
.font(.system(size: 28, weight: .bold))
.multilineTextAlignment(.center)
.foregroundColor(.black)
.padding(.horizontal,24)

Text("Check in daily, track your mood, and be gentle to yourself")
.font(.body)
.multilineTextAlignment(.center)
.foregroundColor(.gray)
.padding(.horizontal,24)
}
.padding(.top,30)
// الجزء السفلي رح نستخدم spacer عشان يدفه لنا تحت
Spacer()
HStack(spacing:6) {

Circle()
.fill(Color.gray.opacity(0.3))
.frame(width: 8, height: 8)

Circle()
.fill(Color.gray.opacity(0.3))
.frame(width: 8, height: 8)
Circle()
.fill(Color.gray.opacity(0.3))
.frame(width: 8, height: 8)
Capsule()
.fill(Color("primarycolor").opacity(0.7))
.frame(width: 24, height: 8)

}
.padding(.bottom,20)
// الزر الاخير
Button(action: {
print("start journaling clicked")
}){
ZStack{
Image("Rectangle4")
.resizable()
.scaledToFit()

Text("Start Journaling")
.font(.system(size: 26, weight: .semibold))
.foregroundColor(.white)
.padding(.bottom,18)
}
}
}
.padding(.horizontal,24)
.padding(.bottom,30)
}
}












#Preview {
Intropage()
}


// Created by Norah Bindokhi on 16/05/1448 AH.
//





//
// Created by Norah Bindokhi on 13/05/1448 AH.
