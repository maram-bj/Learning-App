//
//  New_learningApp.swift
//  New learning
//
//  Created by Maram on 05/05/1447 AH.
//

import SwiftUI
import SwiftData

@main
struct New_learningApp: App {
        var body: some Scene {
            WindowGroup {
                RootView()
                    .environmentObject(GoalManager.shared)
                    .modelContainer(for: GoalModel.self)
            }
        }
    }
