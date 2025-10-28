//
//  CelandarView.swift
//  Learning Challeng App
//
//  Created by Maram on 28/04/1447 AH.
//


import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @Binding var showPicker: Bool
    @EnvironmentObject private var goalManager: GoalManager

    var body: some View {
        VStack(spacing: 12) {

            // MARK: - Header
            HStack {
                HStack(spacing: 4) {
                    Text(viewModel.currentMonthYear)
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.white)

                    Button {
                        withAnimation(.spring()) { showPicker.toggle() }
                    } label: {
                        Image(systemName: showPicker ? "chevron.down" : "chevron.right")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.orange)
                    }
                }
                Spacer()

                HStack(spacing: 14) {
                    Button(action: viewModel.previousWeek) {
                        Image(systemName: "chevron.left").foregroundColor(.orange)
                    }
                    Button(action: viewModel.nextWeek) {
                        Image(systemName: "chevron.right").foregroundColor(.orange)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 6)

            // MARK: - Days
            if !viewModel.daysOfWeek.isEmpty {
                HStack(spacing: 6) {
                    ForEach(viewModel.daysOfWeek) { day in
                        VStack(spacing: 6) {
                            Text(day.dayName)
                                .font(.caption)
                                .foregroundColor(.gray)

                            let circleColor = colorForDate(day.date)
                            let textColor = textColorForDate(day.date)
                            let weight = fontWeightForDate(day.date)
                            let fontSize = fontSizeForDate(day.date)

                            Text(day.dayNumber)
                                .font(.system(size: fontSize, weight: weight))
                                .frame(width: 40, height: 40)
                                .background(Circle().fill(circleColor))
                                .foregroundColor(textColor)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        viewModel.selectDate(day.date)
                                    }
                                }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
            } else {
                // حالة التحميل أو البيانات الفارغة
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                    .padding(.top, 40)
            }
        }
    }

    // MARK: - Circle Color Logic
    private func colorForDate(_ date: Date) -> Color {
        let cal = Calendar.current
        let goal = goalManager.currentGoal
        let isLearned = goal?.learnedDates.contains { cal.isDate($0, inSameDayAs: date) } ?? false
        let isFreezed = goal?.freezedDates.contains { cal.isDate($0, inSameDayAs: date) } ?? false
        let isToday = cal.isDateInToday(date)

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

    // MARK: - Text Color Logic
    private func textColorForDate(_ date: Date) -> Color {
        let cal = Calendar.current
        let goal = goalManager.currentGoal
        let isLearned = goal?.learnedDates.contains { cal.isDate($0, inSameDayAs: date) } ?? false
        let isFreezed = goal?.freezedDates.contains { cal.isDate($0, inSameDayAs: date) } ?? false
        let isToday = cal.isDateInToday(date)

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

    // MARK: - Font Weight Logic
    private func fontWeightForDate(_ date: Date) -> Font.Weight {
        let cal = Calendar.current
        let goal = goalManager.currentGoal
        let isLearned = goal?.learnedDates.contains { cal.isDate($0, inSameDayAs: date) } ?? false
        let isFreezed = goal?.freezedDates.contains { cal.isDate($0, inSameDayAs: date) } ?? false
        let isToday = cal.isDateInToday(date)

        return (isToday || isLearned || isFreezed) ? .bold : .regular
    }

    // MARK: - Font Size Logic
    private func fontSizeForDate(_ date: Date) -> CGFloat {
        let cal = Calendar.current
        let goal = goalManager.currentGoal
        let isLearned = goal?.learnedDates.contains { cal.isDate($0, inSameDayAs: date) } ?? false
        let isFreezed = goal?.freezedDates.contains { cal.isDate($0, inSameDayAs: date) } ?? false
        let isToday = cal.isDateInToday(date)

        return (isLearned || isFreezed || isToday) ? 21 : 19
    }
}

#Preview {
    CalendarView(viewModel: CalendarViewModel(), showPicker: .constant(false))
        .environmentObject(GoalManager.shared)
        .preferredColorScheme(.dark)
}
