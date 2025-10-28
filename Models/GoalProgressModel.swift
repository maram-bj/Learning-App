//
//  GoalProgressModel.swift
//  L- New
//
//  Created by Maram on 04/05/1447 AH.
//
import Foundation

@MainActor
struct GoalProgressModel {

    let goal: GoalModel

   
    var learnedCount: Int {
        goal.learnedDates.count
    }

    var freezedCount: Int {
        goal.freezedDates.count
    }

    var totalActiveDays: Int {
        learnedCount + freezedCount
    }

    //  requiredDays
    var requiredDays: Int {
        goal.duration.requiredDays()
    }

    var maxFreezeDays: Int {
        goal.duration.maxFreezeDays()
    }

    // Computed Values
    var isGoalCompleted: Bool {
        totalActiveDays >= requiredDays
//        code for test the well done
      //  return totalActiveDays >= 1

    }

    var progressPercentage: Double {
        min(Double(totalActiveDays) / Double(requiredDays), 1.0)
    }

    var remainingDays: Int {
        max(0, requiredDays - totalActiveDays)
    }


}
