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
        DateUtils.daysInMonth(month)
    }

    private func monthName(for date: Date) -> String {
        DateUtils.monthName(for: date)
    }

    private func year(for date: Date) -> Int {
        DateUtils.year(for: date)
    }


    private func circleColor(for date: Date) -> Color {
        GoalStatusUtils.getCircleColor(for: date, goal: goalManager.currentGoal)
    }

    private func textColor(for date: Date) -> Color {
        GoalStatusUtils.getTextColor(for: date, goal: goalManager.currentGoal)
    }

    private func fontWeight(for date: Date) -> Font.Weight {
        GoalStatusUtils.getFontWeight(for: date, goal: goalManager.currentGoal)
    }

    private func fontSize(for date: Date) -> CGFloat {
        let status = GoalStatusUtils.getDateStatus(for: date, goal: goalManager.currentGoal)
        return (status.isToday || status.isLearned || status.isFreezed) ? 21 : 19
    }
}

#Preview {
    NavigationStack {
        CalendarFullView(viewModel: CalendarViewModel())
            .environmentObject(GoalManager.shared)
            .preferredColorScheme(.dark)
    }
}
