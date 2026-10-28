import SwiftUI
import SwiftData

enum CalMood: String, CaseIterable {
    case good, great, low, unsure, upset
    var image: some View { Image(rawValue).resizable().scaledToFit() }
}

func calDay(_ d: Int) -> Date {
    Calendar.current.date(from: DateComponents(year: 2026, month: 10, day: d))!
}

let calColumns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 5)

// MARK: - Button
struct CalButton: View {
    let icon: String
    var big = false
    var disabled = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: big ? 28 : 18))
                .foregroundColor(big ? .white : Color("titleText"))
                .frame(width: big ? 84 : 44, height: big ? 84 : 44)
                .background(big ? Color("primarycolor") : Color("entrybox"))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .opacity(disabled ? 0.4 : 1)
    }
}

// MARK: - Header
struct CalHeader: View {
    @Binding var month: Date
    private let cal = Calendar.current

    // الشهر المعروض هو الحالي (أو بعده) ← نعطّل السهم
    private var isCurrentMonth: Bool {
        cal.compare(month, to: Date(), toGranularity: .month) != .orderedAscending
    }

    private func shift(_ value: Int) {
        month = cal.date(byAdding: .month, value: value, to: month) ?? month
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
                    .disabled(isCurrentMonth)
                    .opacity(isCurrentMonth ? 0.3 : 1)
            }
            .font(.system(size: 22))
            .buttonStyle(.plain)
        }
        .foregroundColor(Color("titleText"))
    }
}

// MARK: - Cal Page
struct CalPage<Content: View>: View {
    @Binding var month: Date
    var plusIcon: String = "plus"
    var onPlus: (() -> Void)? = nil
    var plusDisabled: Bool = false
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
            VStack(spacing: 0) {
                CalHeader(month: $month).padding(.top, 20)

                LazyVGrid(columns: calColumns, spacing: 8) { content }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)

                Spacer()

                if let onPlus {
                    CalButton(icon: plusIcon, big: true, disabled: plusDisabled, action: onPlus)
                        .padding(.bottom, 24)
                }
            }
        }
    }
}

// MARK: - Calendar Screen (الـ NavigationStack والتول بار هنا فقط)
struct CalendarHomeScreen: View {
    @State private var month = Date()
    @State private var showFavorites = false

    var body: some View {
        NavigationStack {
            ZStack {
                CalendarHomeView(month: $month)
                if showFavorites {
                    CalFavoritesPage(month: $month)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation { showFavorites.toggle() }
                    } label: {
                        Image(systemName: showFavorites ? "star.fill" : "star")
                            .foregroundStyle(Color("titleText").opacity(0.6))
                    }
                }
            }
        }
    }
}

// MARK: - Home Page
struct CalendarHomeView: View {
    @Binding var month: Date
    @Environment(\.modelContext) private var context
    @Query(sort: \JournalEntryData.date)
    private var allEntries: [JournalEntryData]

    @State private var selected: Date? = Calendar.current.startOfDay(for: Date())
    @State private var showAdd = false
    @State private var entryToEdit: JournalEntryData?
    @State private var dayToDelete: Date?
    private let cal = Calendar.current
    private var today: Date { cal.startOfDay(for: Date()) }

    private var currentMonthStart: Date {
        cal.date(from: cal.dateComponents([.year, .month], from: today))!
    }

    private var entryByDay: [Date: JournalEntryData] {
        var dict: [Date: JournalEntryData] = [:]
        for e in allEntries {
            dict[cal.startOfDay(for: e.date)] = e
        }
        return dict
    }

    private var days: [Date] {
        let start = cal.date(from: cal.dateComponents([.year, .month], from: month))!
        let count = cal.range(of: .day, in: .month, for: start)!.count
        return (0..<count)
            .compactMap { cal.date(byAdding: .day, value: $0, to: start) }
            .filter { $0 <= today }
    }

    private var selectedHasMood: Bool {
        guard let selected else { return false }
        return entryByDay[selected] != nil
    }

    private var selectedEditableEntry: JournalEntryData? {
        guard let selected, let e = entryByDay[selected], !e.isTemporary else { return nil }
        return e
    }

    private var plusDisabled: Bool {
        selectedHasMood && selectedEditableEntry == nil
    }

    private var plusAction: (() -> Void)? {
        guard selected != nil else { return nil }
        if let entry = selectedEditableEntry {
            return { entryToEdit = entry }
        } else if selectedHasMood {
            return { }
        } else {
            return { showAdd = true }
        }
    }

    var body: some View {
        CalPage(month: $month,
                plusIcon: selectedEditableEntry != nil ? "pencil" : "plus",
                onPlus: plusAction,
                plusDisabled: plusDisabled) {
            ForEach(days, id: \.self) { date in
                cell(date)
            }
        }
        .navigationDestination(isPresented: $showAdd) {
            MoodScaleView(date: selected ?? today)
                .environment(\.entryDate, selected ?? today)
                .environment(\.closeFlow, { showAdd = false })
        }
        .navigationDestination(item: $entryToEdit) { entry in
            ReflectionPageView(selectedMood: entry.mood, existingEntry: entry)
                .environment(\.closeFlow, { entryToEdit = nil })
        }
        .onChange(of: month) { _, newValue in
            if cal.compare(newValue, to: currentMonthStart, toGranularity: .month) == .orderedDescending {
                month = currentMonthStart
            }
            selected = cal.isDate(month, equalTo: today, toGranularity: .month) ? today : nil
        }
        .onChange(of: allEntries.count) { showAdd = false }
        .alert("Delete this entry?",
               isPresented: Binding(get: { dayToDelete != nil },
                                    set: { if !$0 { dayToDelete = nil } })) {
            Button("Delete", role: .destructive) { deleteSelectedDay() }
            Button("Cancel", role: .cancel) { dayToDelete = nil }
        } message: {
            Text("Are you sure? This can't be undone.")
        }
    }

    // MARK: - Functions

    private func tap(_ date: Date) {
        selected = date
    }

    private func deleteSelectedDay() {
        guard let day = dayToDelete else { return }
        for e in allEntries where cal.isDate(e.date, inSameDayAs: day) {
            context.delete(e)
        }
        try? context.save()
        dayToDelete = nil
    }

    // الضغط العادي = تحديد، الضغط المطوّل = حذف فقط (بدون فيفرت)
    private func cell(_ date: Date) -> some View {
        let isSelected = selected == date
        return Button { tap(date) } label: {
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay(cellContent(date, isSelected: isSelected))
        }
                .buttonStyle(.plain)
                .contextMenu {
                    // أيقونة تراش حمراء فقط
                    if entryByDay[date] != nil {
                        Button(role: .destructive) {
                            dayToDelete = date
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }

    @ViewBuilder
    private func cellContent(_ date: Date, isSelected: Bool) -> some View {
        if let entry = entryByDay[date] {
            Image(entry.mood.imageName)
                .resizable()
                .scaledToFit()
                .outline(color: Color("bordercal"), width: isSelected ? 3 : 0)
        } else if cal.isDateInToday(date) {
            ZStack {
                Circle().fill(Color("primarycolor"))
                Text("TODAY").font(.system(size: 14, weight: .bold)).foregroundColor(.white)
            }
            .overlay(selectionRing(isSelected))
        } else {
            ZStack {
                Circle().fill(Color("dayCircle"))
                Text("\(cal.component(.day, from: date))")
                    .font(.system(size: 26))
                    .foregroundColor(Color("datescolorcel"))   // ← اللون الجديد
            }
            .overlay(selectionRing(isSelected))
        }
    }

    @ViewBuilder
    private func selectionRing(_ isSelected: Bool) -> some View {
        if isSelected {
            Circle()
                .stroke(Color("bordercal"), lineWidth: 3)
                .padding(-3)
        }
    }
}

// MARK: - Favourites
struct CalFavoritesPage: View {
    @Binding var month: Date
    @Environment(\.modelContext) private var context
    private let cal = Calendar.current

    @State private var selectedEntry: JournalEntryData?
    @State private var entryToEdit: JournalEntryData?
    @State private var entryToDelete: JournalEntryData?
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
                plusIcon: "pencil",
                onPlus: {
                    if let entry = selectedEntry { entryToEdit = entry }
                },
                plusDisabled: selectedEntry == nil) {
            ForEach(shown) { entry in
                let isSelected = selectedEntry == entry

                Button {
                    selectedEntry = entry
                } label: {
                    Color.clear
                        .aspectRatio(1, contentMode: .fit)
                        .overlay(
                            Image(entry.mood.imageName)
                                .resizable()
                                .scaledToFit()
                                .outline(color: Color("bordercal"),
                                         width: isSelected ? 3 : 0)
                                .padding(4)
                        )
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .contextMenu {
                    Button {
                        if selectedEntry == entry { selectedEntry = nil }
                        entry.isFavourite = false
                        try? context.save()
                    } label: {
                        Label("Remove from favorites", systemImage: "star.slash")
                    }

                }
            }
        }
        .navigationDestination(item: $entryToEdit) { entry in
            ReflectionPageView(selectedMood: entry.mood, existingEntry: entry)
                .environment(\.closeFlow, { entryToEdit = nil })
        }
        .onChange(of: month) { selectedEntry = nil }
    }
}

// MARK: - Mood View
struct CalAddMoodView: View {
    let onPick: (CalMood) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("How are you feeling?")
                .font(.title3.weight(.semibold))
                .foregroundColor(Color("titleText"))
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
        .background(Color("background").ignoresSafeArea())
    }
}

// MARK: - Border
extension View {
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
        .modelContainer(for: JournalEntryData.self, inMemory: true)
}
