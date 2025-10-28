//
//  Day.swift
//  L- New
//
//  Created by Maram on 02/05/1447 AH.
//
import Foundation
// Lightweight view model for a calendar day (name and number only)

struct Day: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    
    

    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).uppercased()
    }

    var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}
