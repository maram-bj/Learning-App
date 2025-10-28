//
//  CalendarFullView.swift
//  Learning Challeng App
//
//  Created by Maram on 28/04/1447 AH.

import SwiftUI
import Combine

struct CalendarFullView: View {
    @EnvironmentObject private var goalManager: GoalManager
    @ObservedObject var viewModel: CalendarViewModel
    @State private var refreshID = UUID()

    private let calendar = Calendar.current

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 32) {
                    ForEach(months(), id: \.self) { month in
                        VStack(alignment: .leading, spacing: 10) {

                            // MARK: - Month Title
                            HStack(spacing: 6) {
                                Text(monthName(for: month))
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                Text("\(year(for: month))")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)

                            // MARK: - Days Grid
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                                ForEach(days(for: month), id: \.self) { day in
                                    let color = circleColor(for: day)
                                    let text = textColor(for: day)
                                    let fontWeight = fontWeight(for: day)
                                    let fontSize = fontSize(for: day)

                                    Text("\(calendar.component(.day, from: day))")
                                        .font(.system(size: fontSize, weight: fontWeight))
                                        .frame(width: 45, height: 45)
                                        .background(Circle().fill(color))
                                        .foregroundColor(text)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(12)
                        .id(month)
                    }
                }
                .padding(.vertical, 20)
            }
            .id(refreshID)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("All Activities")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.updateToSelectedMonthYear()
                scrollToCurrentMonth(proxy: proxy)
            }
            .onReceive(goalManager.objectWillChange) { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    refreshID = UUID()
                }
            }
        }
    }

    private func scrollToCurrentMonth(proxy: ScrollViewProxy) {
        let currentMonth = calendar.date(from:
            calendar.dateComponents([.year, .month], from: Date())
        )
        if let currentMonth = currentMonth {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    proxy.scrollTo(currentMonth, anchor: .top)
                }
            }
        }
    }

    private func months() -> [Date] {
        let current = Date()
        let year = calendar.component(.year, from: current)
        return (1...12).compactMap { month -> Date? in
            calendar.date(from: DateComponents(year: year, month: month))
        }
    }

    private func days(for month: Date) -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: month) else { return [] }
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: month)
        }
    }

    private func monthName(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }

    private func year(for date: Date) -> Int {
        calendar.component(.year, from: date)
    }


    private func circleColor(for date: Date) -> Color {
        let cal = Calendar.current
        guard let goal = goalManager.currentGoal else { return .clear }

        let isLearned = goal.learnedDates.contains { cal.isDate($0, inSameDayAs: date) }
        let isFreezed = goal.freezedDates.contains { cal.isDate($0, inSameDayAs: date) }
        let isToday   = cal.isDateInToday(date)

        if isLearned {
            return Color("Color").opacity(0.27)
        } else if isFreezed {
            return Color("Freez").opacity(0.27)
        } else if isToday {
            return .orange
        } else {
            return .clear
        }
    }

    private func textColor(for date: Date) -> Color {
        let cal = Calendar.current
        guard let goal = goalManager.currentGoal else { return .white.opacity(0.8) }

        let isLearned = goal.learnedDates.contains { cal.isDate($0, inSameDayAs: date) }
        let isFreezed = goal.freezedDates.contains { cal.isDate($0, inSameDayAs: date) }
        let isToday   = cal.isDateInToday(date)

        if isLearned {
            return .orange
        } else if isFreezed {
            return Color("Date", bundle: .main) ?? .gray
        } else if isToday {
            return .white
        } else {
            return .white.opacity(0.8)
        }
    }

    private func fontWeight(for date: Date) -> Font.Weight {
        let cal = Calendar.current
        guard let goal = goalManager.currentGoal else { return .regular }

        let isLearned = goal.learnedDates.contains { cal.isDate($0, inSameDayAs: date) }
        let isFreezed = goal.freezedDates.contains { cal.isDate($0, inSameDayAs: date) }
        let isToday   = cal.isDateInToday(date)

        return (isToday || isLearned || isFreezed) ? .bold : .regular
    }

    private func fontSize(for date: Date) -> CGFloat {
        let cal = Calendar.current
        guard let goal = goalManager.currentGoal else { return 19 }

        let isLearned = goal.learnedDates.contains { cal.isDate($0, inSameDayAs: date) }
        let isFreezed = goal.freezedDates.contains { cal.isDate($0, inSameDayAs: date) }
        let isToday   = cal.isDateInToday(date)

        return (isLearned || isFreezed || isToday) ? 21 : 19
    }
}

#Preview {
    NavigationStack {
        CalendarFullView(viewModel: CalendarViewModel())
            .environmentObject(GoalManager.shared)
            .preferredColorScheme(.dark)
    }
}
