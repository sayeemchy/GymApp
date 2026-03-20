//
//  GymAppApp.swift
//  GymApp
//
//  Created by Sayeem Chowdhury on 10/03/2026.
//

import SwiftData
import SwiftUI

@main
struct GymAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
        .modelContainer(for: [ExerciseEntry.self, ExerciseType.self, ExerciseDayExercise.self])
    }
}
