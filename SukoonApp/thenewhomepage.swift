import SwiftUI

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

struct CalPage<Content: View>: View {
    @Binding var month: Date
    var leftIcon: String? = nil
    var onLeft: () -> Void = {}
    let rightIcon: String
    var onRight: () -> Void = {}
    let onPlus: () -> Void
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
                CalButton(icon: "plus", big: true, action: onPlus).padding(.bottom, 24)
            }
        }
    }
}

struct CalendarHomeScreen: View {
    private let today = calDay(17)
    @State private var month = calDay(17)
    @State private var showFavorites = false
    @State private var entries: [Date: CalMood] = [
        calDay(6): .good, calDay(7): .great, calDay(9): .upset, calDay(10): .good,
        calDay(12): .low, calDay(14): .good, calDay(15): .unsure
    ]
    @State private var favorites: [Date] = [calDay(9), calDay(10), calDay(15), calDay(7)]

    var body: some View {
        ZStack {
            CalendarHomeView(entries: $entries, favorites: $favorites, month: $month, today: today) {
                withAnimation { showFavorites = true }
            }
            if showFavorites {
                CalFavoritesPage(entries: $entries, favorites: $favorites, month: $month, today: today) {
                    withAnimation { showFavorites = false }
                }
                .transition(.move(edge: .trailing))
            }
        }
    }
}

struct CalendarHomeView: View {
    @Binding var entries: [Date: CalMood]
    @Binding var favorites: [Date]
    @Binding var month: Date
    let today: Date
    let onFavorites: () -> Void
    @State private var selected: Date? = calDay(1)
    @State private var showAdd = false
    private let cal = Calendar.current

    private var days: [Date] {
        let start = cal.date(from: cal.dateComponents([.year, .month], from: month))!
        let count = cal.range(of: .day, in: .month, for: start)!.count
        return (0..<count)
            .compactMap { cal.date(byAdding: .day, value: $0, to: start) }
            .filter { $0 <= cal.startOfDay(for: today) }
    }

    var body: some View {
        CalPage(month: $month, rightIcon: "star", onRight: onFavorites, onPlus: { showAdd = true }) {
            ForEach(days, id: \.self) { date in cell(date) }
        }
        // ✅ التعديل هنا: الزر + يفتح MoodScaleView، و closeFlow يقفل الـ sheet ويرجع للهوم
        .sheet(isPresented: $showAdd) {
            MoodScaleView()
                .environment(\.closeFlow, { showAdd = false })
        }
    }

    private func cell(_ date: Date) -> some View {
        Button { selected = date } label: {
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay(cellContent(date))
                .overlay(
                    Circle()
                        .stroke(CalColors.primary, lineWidth: selected == date ? 3 : 0)
                        .padding(-4)
                )
        }
        .buttonStyle(.plain)
        .contextMenu {
            if entries[date] != nil {
                Button(favorites.contains(date) ? "Remove from favorites" : "Add to favorites") {
                    if favorites.contains(date) {
                        favorites.removeAll { $0 == date }
                    } else {
                        favorites.append(date)
                    }
                }
                Button(role: .destructive) {
                    entries[date] = nil
                    favorites.removeAll { $0 == date }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }

    @ViewBuilder
    private func cellContent(_ date: Date) -> some View {
        if cal.isDate(date, inSameDayAs: today) {
            ZStack {
                Circle().fill(CalColors.primary)
                Text("TODAY").font(.system(size: 14, weight: .bold)).foregroundColor(.white)
            }
        } else if let mood = entries[date] {
            mood.image
        } else {
            ZStack {
                Circle().fill(CalColors.dayCircle)
                Text("\(cal.component(.day, from: date))")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
            }
        }
    }
}

struct CalFavoritesPage: View {
    @Binding var entries: [Date: CalMood]
    @Binding var favorites: [Date]
    @Binding var month: Date
    let today: Date
    let onBack: () -> Void
    @State private var showAdd = false
    private let cal = Calendar.current

    private var shown: [Date] {
        favorites.filter { cal.isDate($0, equalTo: month, toGranularity: .month) && entries[$0] != nil }
    }

    var body: some View {
        CalPage(month: $month, leftIcon: "chevron.left", onLeft: onBack, rightIcon: "star.fill", onPlus: { showAdd = true }) {
            ForEach(shown, id: \.self) { date in
                if let mood = entries[date] {
                    Color.clear
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(mood.image)
                        .contentShape(Rectangle())
                        .contextMenu {
                            Button(role: .destructive) {
                                favorites.removeAll { $0 == date }
                            } label: {
                                Label("Remove from favorites", systemImage: "star.slash")
                            }
                        }
                }
            }
        }
        .sheet(isPresented: $showAdd) {
            CalAddMoodView { mood in
                let day = cal.startOfDay(for: today)
                entries[day] = mood
                if !favorites.contains(day) { favorites.append(day) }
                showAdd = false
            }
        }
    }
}

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
}

#Preview {
    CalendarHomeScreen()
}




/* import SwiftUI

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

struct CalPage<Content: View>: View {
    @Binding var month: Date
    var leftIcon: String? = nil
    var onLeft: () -> Void = {}
    let rightIcon: String
    var onRight: () -> Void = {}
    let onPlus: () -> Void
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
                CalButton(icon: "plus", big: true, action: onPlus).padding(.bottom, 24)
            }
        }
    }
}

struct CalendarHomeScreen: View {
    private let today = calDay(17)
    @State private var month = calDay(17)
    @State private var showFavorites = false
    @State private var entries: [Date: CalMood] = [
        calDay(6): .good, calDay(7): .great, calDay(9): .upset, calDay(10): .good,
        calDay(12): .low, calDay(14): .good, calDay(15): .unsure
    ]
    @State private var favorites: [Date] = [calDay(9), calDay(10), calDay(15), calDay(7)]

    var body: some View {
        ZStack {
            CalendarHomeView(entries: $entries, favorites: $favorites, month: $month, today: today) {
                withAnimation { showFavorites = true }
            }
            if showFavorites {
                CalFavoritesPage(entries: $entries, favorites: $favorites, month: $month, today: today) {
                    withAnimation { showFavorites = false }
                }
                .transition(.move(edge: .trailing))
            }
        }
    }
}

struct CalendarHomeView: View {
    @Binding var entries: [Date: CalMood]
    @Binding var favorites: [Date]
    @Binding var month: Date
    let today: Date
    let onFavorites: () -> Void
    @State private var selected: Date? = calDay(1)
    @State private var showAdd = false
    private let cal = Calendar.current

    private var days: [Date] {
        let start = cal.date(from: cal.dateComponents([.year, .month], from: month))!
        let count = cal.range(of: .day, in: .month, for: start)!.count
        return (0..<count)
            .compactMap { cal.date(byAdding: .day, value: $0, to: start) }
            .filter { $0 <= cal.startOfDay(for: today) }
    }

    var body: some View {
        CalPage(month: $month, rightIcon: "star", onRight: onFavorites, onPlus: { showAdd = true }) {
            ForEach(days, id: \.self) { date in cell(date) }
        }
        .sheet(isPresented: $showAdd) {
            CalAddMoodView { mood in
                entries[cal.startOfDay(for: selected ?? today)] = mood
                showAdd = false
            }
        }
    }

    private func cell(_ date: Date) -> some View {
        Button { selected = date } label: {
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay(cellContent(date))
                .overlay(
                    Circle()
                        .stroke(CalColors.primary, lineWidth: selected == date ? 3 : 0)
                        .padding(-4)
                )
        }
        .buttonStyle(.plain)
        .contextMenu {
            if entries[date] != nil {
                Button(favorites.contains(date) ? "Remove from favorites" : "Add to favorites") {
                    if favorites.contains(date) {
                        favorites.removeAll { $0 == date }
                    } else {
                        favorites.append(date)
                    }
                }
                Button(role: .destructive) {
                    entries[date] = nil
                    favorites.removeAll { $0 == date }
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }

    @ViewBuilder
    private func cellContent(_ date: Date) -> some View {
        if cal.isDate(date, inSameDayAs: today) {
            ZStack {
                Circle().fill(CalColors.primary)
                Text("TODAY").font(.system(size: 14, weight: .bold)).foregroundColor(.white)
            }
        } else if let mood = entries[date] {
            mood.image
        } else {
            ZStack {
                Circle().fill(CalColors.dayCircle)
                Text("\(cal.component(.day, from: date))")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
            }
        }
    }
}

struct CalFavoritesPage: View {
    @Binding var entries: [Date: CalMood]
    @Binding var favorites: [Date]
    @Binding var month: Date
    let today: Date
    let onBack: () -> Void
    @State private var showAdd = false
    private let cal = Calendar.current

    private var shown: [Date] {
        favorites.filter { cal.isDate($0, equalTo: month, toGranularity: .month) && entries[$0] != nil }
    }

    var body: some View {
        CalPage(month: $month, leftIcon: "chevron.left", onLeft: onBack, rightIcon: "star.fill", onPlus: { showAdd = true }) {
            ForEach(shown, id: \.self) { date in
                if let mood = entries[date] {
                    Color.clear
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(mood.image)
                        .contentShape(Rectangle())
                        .contextMenu {
                            Button(role: .destructive) {
                                favorites.removeAll { $0 == date }
                            } label: {
                                Label("Remove from favorites", systemImage: "star.slash")
                            }
                        }
                }
            }
        }
        .sheet(isPresented: $showAdd) {
            CalAddMoodView { mood in
                let day = cal.startOfDay(for: today)
                entries[day] = mood
                if !favorites.contains(day) { favorites.append(day) }
                showAdd = false
            }
        }
    }
}

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
}

#Preview {
    CalendarHomeScreen()
}
 */
