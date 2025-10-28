//
//  CalendarViewModel.swift
//  Learning Challeng App
//
//  Created by Maram on 28/04/1447 AH.
//

import Foundation
import Combine

@MainActor
final class CalendarViewModel: ObservableObject {
    @Published var currentWeekStart: Date = Date()
    @Published var selectedDate: Date = Date()
    @Published var selectedMonth: Int
    @Published var selectedYear: Int
    @Published var monthDates: [Date] = []

    private let calendar = Calendar.current

    init() {
        let current = Date()
        selectedMonth = calendar.component(.month, from: current)
        selectedYear = calendar.component(.year, from: current)
        generateMonths()
    }

    var currentMonthYear: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: currentWeekStart)
    }

    var daysOfWeek: [Day] {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: currentWeekStart) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: week.start) }
            .map { Day(date: $0) }
    }

    func nextWeek() {
        if let next = calendar.date(byAdding: .weekOfYear, value: 1, to: currentWeekStart) {
            currentWeekStart = next
            objectWillChange.send()
        }
    }

    func previousWeek() {
        if let prev = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeekStart) {
            currentWeekStart = prev
            objectWillChange.send()
        }
    }

    func selectDate(_ date: Date) {
        selectedDate = date
    }

    func updateToSelectedMonthYear() {
        var comps = DateComponents(
            year: selectedYear,
            month: selectedMonth,
            day: Calendar.current.component(.day, from: Date())
        )
        if let newDate = calendar.date(from: comps) {
            currentWeekStart = newDate
            objectWillChange.send()
        }
    }

    func generateMonths() {
        let now = Date()
        var dates: [Date] = []
        let currentYear = calendar.component(.year, from: now)
        for month in 1...12 {
            if let date = calendar.date(from: DateComponents(year: currentYear, month: month)) {
                dates.append(date)
            }
        }
        self.monthDates = dates
    }

    func days(for month: Date) -> [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: month) else { return [] }
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: month)
        }
    }
}
