import SwiftUI
import SwiftData

enum CalColors {
    static let background = Color(calHex: "F2F3F9")
    static let dayCircle = Color(calHex: "C9C3D9")
    static let primary = Color(calHex: "7C4AB2")
    static let titleText = Color(calHex: "0C0C0D")
    static let buttonBg = Color(calHex: "F2F2F7")
}

extension Color {
    init(calHex hex: String) {
        var v: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&v)
        self.init(red: Double((v >> 16) & 0xFF) / 255,
                  green: Double((v >> 8) & 0xFF) / 255,
                  blue: Double(v & 0xFF) / 255)
    }
}

enum CalMood: String, CaseIterable {
    case good, great, low, unsure, upset
    var image: some View { Image(rawValue).resizable().scaledToFit() }
}

func calDay(_ d: Int) -> Date {
    Calendar.current.date(from: DateComponents(year: 2026, month: 10, day: d))!
}

let calColumns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 5)

struct CalButton: View {
    let icon: String
    var big = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: big ? 28 : 18))
                .foregroundColor(big ? .white : CalColors.titleText)
                .frame(width: big ? 84 : 44, height: big ? 84 : 44)
                .background(big ? CalColors.primary : CalColors.buttonBg)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

struct CalHeader: View {
    @Binding var month: Date

    private func shift(_ value: Int) {
        month = Calendar.current.date(byAdding: .month, value: value, to: month) ?? month
    }

    var body: some View {
        VStack(spacing: 2) {
            Text(month.formatted(.dateTime.year()))
                .font(.system(size: 18, weight: .medium))
            HStack(spacing: 40) {
                Button { shift(-1) } label: { Image(systemName: "arrow.left") }
                Text(month.formatted(.dateTime.month(.wide)))
                    .font(.system(size: 32, weight: .medium))
                    .frame(minWidth: 140)
                Button { shift(1) } label: { Image(systemName: "arrow.right") }
            }
            .font(.system(size: 22))
            .buttonStyle(.plain)
        }
        .foregroundColor(CalColors.titleText)
    }
}
// -----------------------------cal page-----------------------------
struct CalPage<Content: View>: View {
    @Binding var month: Date
    var leftIcon: String? = nil
    var onLeft: () -> Void = {}
    let rightIcon: String
    var onRight: () -> Void = {}
    var plusIcon: String = "plus"            // جديد
    var onPlus: (() -> Void)? = nil          // صار اختياري
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            CalColors.background.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    if let leftIcon { CalButton(icon: leftIcon, action: onLeft) }
                    Spacer()
                    CalButton(icon: rightIcon, action: onRight)
                }
                .padding(.horizontal, 20)

                CalHeader(month: $month).padding(.top, 20)

                LazyVGrid(columns: calColumns, spacing: 8) { content }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)

                Spacer()

                // الزر الكبير يظهر بس إذا فيه أكشن
                if let onPlus {
                    CalButton(icon: plusIcon, big: true, action: onPlus)
                        .padding(.bottom, 24)
                }
            }
        }
    }
}

// --------------------------Calender screen ----------------------

struct CalendarHomeScreen: View {
    @State private var month = Date()          // الشهر الحالي الحقيقي
    @State private var showFavorites = false

    var body: some View {
        ZStack {
            CalendarHomeView(month: $month) {
                withAnimation { showFavorites = true }
            }
            if showFavorites {
                CalFavoritesPage(month: $month, onBack: {
                    showFavorites = false
                })
            }
        }
    }
}

// ------------------------------Home Page-----------------------------

struct CalendarHomeView: View {
    @Binding var month: Date   // الشهر المعروض (مشترك مع صفحة المفضلة)
    let onFavorites: () -> Void // وش يصير لما تضغط النجمة
    @Environment(\.modelContext) private var context//  للحذف والحفظ في الستورج
    @Query(sort: \JournalEntryData.date)   // يجيب كل المدخلات من التخزين
    private var allEntries: [JournalEntryData]
    
    @State private var selected: Date? = Calendar.current.startOfDay(for: Date())
    @State private var showAdd = false                  // يفتح شيت الإضافة
    @State private var entryToEdit: JournalEntryData?   // لو فيه قيمة يفتح شيت التعديل
    @State private var dayToDelete: Date?               // لو فيه قيمة يطلع alert تأكيد الحذف
    private let cal = Calendar.current
    private var today: Date { cal.startOfDay(for: Date())} // اليوم الحقيقي (بداية اليوم بدون ساعة)}

    private var currentMonthStart: Date {
        cal.date(from: cal.dateComponents([.year, .month], from: today))!
    } // أول يوم في الشهر الحالي الحقيقي عشان نمنع الشهر الجاي)


    // مصفوفة: كل يوم ← مدخلته (المؤقتة ما تظهر)
    private var entryByDay: [Date: JournalEntryData] {
        var dict: [Date: JournalEntryData] = [:]
        for e in allEntries where !e.isTemporary {
            dict[cal.startOfDay(for: e.date)] = e
        }
        return dict
    }

    // أيام الشهر المعروض، من أول يوم إلى اليوم الحقيقي فقط
    // (كل يوم يمر يزيد مربع، والأيام اللي ما جت ما تظهر)
    private var days: [Date] {
        let start = cal.date(from: cal.dateComponents([.year, .month], from: month))!
        let count = cal.range(of: .day, in: .month, for: start)!.count
        return (0..<count)
            .compactMap { cal.date(byAdding: .day, value: $0, to: start) }
            .filter { $0 <= today }
    }

    // هل اليوم المحدد له مزاج؟ (يحدد الزر اللي تحت: قلم أو بلس)
    private var selectedHasMood: Bool {
        guard let selected else { return false }
        return entryByDay[selected] != nil
    }

    // MARK: - الواجهة
    var body: some View {
        CalPage(month: $month,
                rightIcon: "star",
                onRight: onFavorites,
                plusIcon: selectedHasMood ? "pencil" : "plus",   // قلم لو له مزاج، بلس لو لا
                onPlus: handlePlus) {
            ForEach(days, id: \.self) { date in cell(date) }
        }

        // لما يتغير الشهر: نمنع الشهر الجاي، ونحدد اليوم لو رجع للشهر الحالي
        .onChange(of: month) { _, newValue in
            if cal.compare(newValue, to: currentMonthStart, toGranularity: .month) == .orderedDescending {
                month = currentMonthStart
            }
            selected = cal.isDate(month, equalTo: today, toGranularity: .month) ? today : nil
        }

        // 1. بديل شيت الإضافة: ينتقل لصفحة MoodScaleView كصفحة جديدة
        .navigationDestination(isPresented: $showAdd) {
            MoodScaleView(date: $selectedMood ?? today)
        }

        // 2. بديل شيت التعديل: ينتقل لصفحة ReflectionPageView كصفحة جديدة
        .navigationDestination(item: $entryToEdit) { entry in
            ReflectionPageView(selectedMood: entry.mood, entry: entry)
        }
        

        // يقفل شيت الإضافة بعد ما تنحفظ المدخلة (لأن عدد المدخلات يتغير)
        .onChange(of: allEntries.count) { showAdd = false }

        // alert تأكيد الحذف
        .alert("Delete this entry?",
               isPresented: Binding(get: { dayToDelete != nil },
                                    set: { if !$0 { dayToDelete = nil } })) {
            Button("Delete", role: .destructive) { deleteSelectedDay() }
            Button("Cancel", role: .cancel) { dayToDelete = nil }
        } message: {
            Text("Are you sure? This can't be undone.")
        }
    }   // ← نهاية body

    // MARK: - الدوال

    // الزر اللي تحت: قلم يعدّل، بلس يضيف
    private func handlePlus() {
        guard let date = selected else { return }
        if let entry = entryByDay[date] {
            entryToEdit = entry     // له مزاج ← تعديل
        } else {
            showAdd = true          // ما له مزاج ← إضافة
        }
    }

    // ينفذ الحذف بعد ما المستخدم يوافق في الـ alert
    private func deleteSelectedDay() {
        guard let day = dayToDelete else { return }
        for e in allEntries where cal.isDate(e.date, inSameDayAs: day) {
            context.delete(e)
        }
        dayToDelete = nil
    }

    // المربع الواحد في الشبكة
    private func cell(_ date: Date) -> some View {
        let isSelected = selected == date
        return Button { selected = date } label: {
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    cellContent(date)
                        // البوردر اللي يتبع شكل الشخصية (من View+Outline.swift)
                        .outline(color: Color("selectionBorder"), width: isSelected ? 3 : 0)
                )
        }
        .buttonStyle(.plain)
        // ضغطة مطولة على شخصية: مفضلة أو حذف (الحذف يطلع له تأكيد)
        .contextMenu {
            if let entry = entryByDay[date] {
                Button {
                    entry.isFavourite.toggle()
                } label: {
                    Label(entry.isFavourite ? "Remove from favorites" : "Add to favorites",
                          systemImage: entry.isFavourite ? "star.slash" : "star")
                }
                Button(role: .destructive) {
                    dayToDelete = date
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }

    // وش يظهر داخل المربع حسب حالة اليوم
    @ViewBuilder
    private func cellContent(_ date: Date) -> some View {
        if let entry = entryByDay[date] {
            // 1) فيه مدخلة محفوظة ← صورة المزاج
            Image(entry.mood.imageName)
                .resizable()
                .scaledToFit()
        } else if cal.isDateInToday(date) {
            // 2) اليوم الحالي بدون مدخلة ← دائرة مكتوب فيها TODAY
            ZStack {
                Circle().fill(CalColors.primary)
                Text("TODAY").font(.system(size: 14, weight: .bold)).foregroundColor(.white)
            }
        } else {
            // 3) يوم قديم بدون مدخلة ← دائرة فيها الرقم
            ZStack {
                Circle().fill(CalColors.dayCircle)
                Text("\(cal.component(.day, from: date))")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
            }
        }
    }
}   // ← نهاية struct، وما يجي بعدها شي في الملف
//------------------FAVOURITE VIEW-------------------------

struct CalFavoritesPage: View {
    @Binding var month: Date
    let onBack: () -> Void

    private let cal = Calendar.current

    @Query(
        filter: #Predicate<JournalEntryData> { $0.isFavourite == true },
        sort: \JournalEntryData.date
    )
    private var favourites: [JournalEntryData]

    // مفضلة الشهر المعروض فقط
    private var shown: [JournalEntryData] {
        favourites.filter {
            cal.isDate($0.date, equalTo: month, toGranularity: .month)
        }
    }

    var body: some View {
        CalPage(month: $month,
                rightIcon: "star.fill",
                onRight: onBack,
                onPlus: { }) {

            ForEach(shown) { entry in
                // الشرط اللي يحدد مين له بوردر (غيّره حسب حاجتك)
                let isSelected = cal.isDateInToday(entry.date)

                Color.clear
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Image(entry.mood.imageName)
                            .resizable()
                            .scaledToFit()
                            .outline(color: Color("selectionBorder"),
                                     width: isSelected ? 3 : 0)
                            .padding(4)   // مسافة عشان البوردر ما ينقص
                    )
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button(role: .destructive) {
                            entry.isFavourite = false   // يتحفظ تلقائياً
                        } label: {
                            Label("Remove from favorites", systemImage: "star.slash")
                        }
                    }
            }
        }
    }
}//favourite

//------------------MOOD VIEW-------------------------

struct CalAddMoodView: View {
    let onPick: (CalMood) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("How are you feeling?")
                .font(.title3.weight(.semibold))
                .foregroundColor(CalColors.titleText)
            HStack(spacing: 12) {
                ForEach(CalMood.allCases, id: \.self) { mood in
                    Button { onPick(mood) } label: { mood.image.frame(maxWidth: .infinity) }
                        .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 30)
        .frame(minWidth: 400, minHeight: 240, alignment: .top)
        .background(CalColors.background.ignoresSafeArea())
    }
}//mood
//------- BORDER --------
import SwiftUI

extension View {
    /// بوردر يتبع شكل الصورة الشفافة
    func outline(color: Color, width: CGFloat = 3) -> some View {
        self
            .shadow(color: color, radius: 0, x:  width, y: 0)
            .shadow(color: color, radius: 0, x: -width, y: 0)
            .shadow(color: color, radius: 0, x: 0, y:  width)
            .shadow(color: color, radius: 0, x: 0, y: -width)
    }
}

#Preview {
    CalendarHomeScreen()
}
