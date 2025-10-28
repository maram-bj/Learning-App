//
//  Duration.swift
//  L- New
//
//  Created by Maram on 02/05/1447 AH.
//
import Foundation
// Supported goal durations and their rules.
// Why needed: central source for required days and max freeze per duration.

public enum DurationType: String, CaseIterable, Codable {
    case weekly = "Week"
    case monthly = "Month"
    case yearly = "Year"

    public func maxFreezeDays() -> Int {
        switch self {
        case .weekly: return 2
        case .monthly: return 8
        case .yearly: return 96
        }
    }
    
    public func requiredDays() -> Int {
        switch self {
        case .weekly: return 7
        case .monthly: return 30
        case .yearly: return 365
        }
    }
}
