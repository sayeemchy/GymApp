//
//  ContentView.swift
//  GymApp
//
//  Created by Sayeem Chowdhury on 10/03/2026.
//

import SwiftData
import SwiftUI

@Model
final class ExerciseEntry {
    var exerciseName: String
    var reps: String
    var weight: String

    init(exerciseName: String, reps: String, weight: String) {
        self.exerciseName = exerciseName
        self.reps = reps
        self.weight = weight
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.tint)

                Text("Welcome to the GymBuddy App")
                    .font(.title2.weight(.semibold))

                Spacer()

                NavigationLink("Let's work out") {
                    WorkoutOptionsView()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

struct WorkoutOptionsView: View {
    var body: some View {
        VStack(spacing: 20) {
            NavigationLink("Create a new exercise") {
                CreateExerciseView()
            }
            .buttonStyle(.borderedProminent)

            NavigationLink("Choose a existing exercise") {
                ExistingExercisesView()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Workout Options")
    }
}

struct CreateExerciseView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var exerciseName = ""
    @State private var reps = ""
    @State private var weight = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
                GridRow {
                    Text("Exercise name")
                        .font(.headline)
                    Text("Reps")
                        .font(.headline)
                    Text("Weight")
                        .font(.headline)
                }

                GridRow {
                    TextField("Bench press", text: $exerciseName)
                        .textFieldStyle(.roundedBorder)

                    TextField("10", text: $reps)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)

                    TextField("135", text: $weight)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                }
            }

            Button("Save") {
                let exercise = ExerciseEntry(
                    exerciseName: exerciseName.trimmingCharacters(in: .whitespacesAndNewlines),
                    reps: reps.trimmingCharacters(in: .whitespacesAndNewlines),
                    weight: weight.trimmingCharacters(in: .whitespacesAndNewlines)
                )

                modelContext.insert(exercise)

                exerciseName = ""
                reps = ""
                weight = ""
            }
            .buttonStyle(.borderedProminent)
            .disabled(exerciseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                reps.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                weight.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            Spacer()
        }
        .padding()
        .navigationTitle("New Exercise")
    }
}

struct ExistingExercisesView: View {
    @Query(sort: \ExerciseEntry.exerciseName) private var exercises: [ExerciseEntry]

    var body: some View {
        ScrollView {
            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
                GridRow {
                    Text("Exercise name")
                        .font(.headline)
                    Text("Reps")
                        .font(.headline)
                    Text("Weight")
                        .font(.headline)
                }

                ForEach(exercises) { exercise in
                    GridRow {
                        Text(exercise.exerciseName)
                        Text(exercise.reps)
                        Text(exercise.weight)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .navigationTitle("Existing Exercises")
    }
}

#Preview {
    ContentView()
        .modelContainer(for: ExerciseEntry.self, inMemory: true)
}
