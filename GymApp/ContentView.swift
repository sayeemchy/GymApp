//
//  ContentView.swift
//  GymApp
//
//  Created by Sayeem Chowdhury on 10/03/2026.
//

import Charts
import SwiftData
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

private let appBackgroundColor = Color(red: 1.0, green: 235 / 255, blue: 214 / 255)
private let workoutOptionButtonColor = Color(red: 1.0, green: 163 / 255, blue: 92 / 255)
private let historyDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
private let calendarMonthFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM yyyy"
    return formatter
}()
private let calendarWeekdaySymbols = ["S", "M", "T", "W", "T", "F", "S"]
private let cardioExerciseTypes: Set<String> = [
    "Bike Sprint",
    "Burpee",
    "Elliptical Sprint",
    "Jump Rope",
    "Mountain Climber",
    "Rowing Machine",
    "Sled Pull",
    "Sled Push",
    "Treadmill Run"
]
private let topExerciseTypes: [String] = [
    "Arnold Press",
    "Bike Sprint",
    "Back Extension",
    "Barbell Back Squat",
    "Barbell Bench Press",
    "Barbell Row",
    "Battle Rope Slam",
    "Bicycle Crunch",
    "Bent-Over Row",
    "Biceps Curl",
    "Box Jump",
    "Bulgarian Split Squat",
    "Burpee",
    "Cable Chest Fly",
    "Cable Curl",
    "Cable Kickback",
    "Cable Lateral Raise",
    "Cable Row",
    "Cable Wood Chop",
    "Chest Dip",
    "Chin-Up",
    "Close-Grip Bench Press",
    "Concentration Curl",
    "Conventional Deadlift",
    "Crunch",
    "Dead Hang",
    "Decline Bench Press",
    "Dumbbell Bench Press",
    "Dumbbell Fly",
    "Dumbbell Shoulder Press",
    "Elliptical Sprint",
    "Face Pull",
    "Farmer's Carry",
    "Front Raise",
    "Front Squat",
    "Glute Bridge",
    "Glute Kickback",
    "Goblet Squat",
    "Hack Squat",
    "Hammer Curl",
    "Hamstring Curl",
    "Handstand Push-Up",
    "Hanging Leg Raise",
    "Hip Abduction Machine",
    "Hip Adduction Machine",
    "Hip Thrust",
    "Incline Bench Press",
    "Incline Push-Up",
    "Inverted Row",
    "Jump Rope",
    "Jump Squat",
    "Kettlebell Swing",
    "Landmine Press",
    "Landmine Row",
    "Landmine Squat",
    "Lat Pulldown",
    "Leg Extension",
    "Leg Press",
    "Machine Chest Press",
    "Machine Row",
    "Machine Shoulder Press",
    "Medicine Ball Slam",
    "Mountain Climber",
    "Overhead Triceps Extension",
    "Pec Deck",
    "Plank",
    "Preacher Curl",
    "Pull-Over",
    "Pull-Up",
    "Push Press",
    "Push-Up",
    "Rear Delt Fly",
    "Reverse Lunge",
    "Romanian Deadlift",
    "Rowing Machine",
    "Russian Twist",
    "Seated Cable Row",
    "Seated Calf Raise",
    "Seated Leg Curl",
    "Shoulder Press",
    "Shrug",
    "Side Plank",
    "Single-Arm Dumbbell Row",
    "Sit-Up",
    "Skull Crusher",
    "Sled Pull",
    "Sled Push",
    "Smith Machine Bench Press",
    "Smith Machine Squat",
    "Standing Calf Raise",
    "Step-Up",
    "Straight-Arm Pulldown",
    "Sumo Deadlift",
    "T-Bar Row",
    "Treadmill Run",
    "Triceps Dip",
    "Triceps Pushdown",
    "Upright Row",
    "Walking Lunge"
]

@Model
final class ExerciseEntry {
    var exerciseName: String
    var reps: String
    var weight: String
    var duration: String
    var exerciseDate: Date

    init(exerciseName: String, reps: String, weight: String, duration: String = "", exerciseDate: Date) {
        self.exerciseName = exerciseName
        self.reps = reps
        self.weight = weight
        self.duration = duration
        self.exerciseDate = exerciseDate
    }
}

@Model
final class ExerciseType {
    var name: String

    init(name: String) {
        self.name = name
    }
}

@Model
final class ExerciseDayExercise {
    var dayType: String
    var exerciseName: String

    init(dayType: String, exerciseName: String) {
        self.dayType = dayType
        self.exerciseName = exerciseName
    }
}

private struct DraftExerciseEntry: Identifiable {
    let id = UUID()
    let exerciseName: String
    var reps = ""
    var weight = ""
    var duration = ""
}

private struct ExerciseLogInput {
    var reps = ""
    var weight = ""
    var duration = ""
}

private func dismissKeyboard() {
#if canImport(UIKit)
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
#endif
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                appBackgroundColor
                    .ignoresSafeArea()

                VStack {
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.tint)

                    Text("Welcome to the GymBuddy App")
                        .font(.title2.weight(.semibold))

                    Spacer()

                    NavigationLink {
                        WorkoutOptionsView()
                    } label: {
                        Text("Let's work out")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(workoutOptionButtonColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
        }
    }
}

struct WorkoutOptionsView: View {
    var body: some View {
        ZStack {
            appBackgroundColor
                .ignoresSafeArea()

            VStack(spacing: 20) {
                optionButton("Let's exercise", destination: CreateExerciseView())
                optionButton("Customise new exercise type", destination: CreateExerciseTypeView())
                optionButton("Set Exercise Day", destination: SetExerciseDayView())
                optionButton("Past Exercise Data", destination: PastExerciseDataView())
                optionButton("Progress Graph", destination: ProgressGraphView())
            }
            .padding()
        }
        .navigationTitle("Workout Options")
    }

    private func optionButton<Destination: View>(_ title: String, destination: Destination) -> some View {
        NavigationLink {
            destination
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(workoutOptionButtonColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .foregroundStyle(.black)
        }
        .buttonStyle(.plain)
    }
}

struct SetExerciseDayView: View {
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack {
            appBackgroundColor
                .ignoresSafeArea()

            LazyVGrid(columns: columns, spacing: 16) {
                exerciseDayButton(title: "Push", systemImage: "figure.strengthtraining.traditional")
                exerciseDayButton(title: "Pull", systemImage: "figure.rower")
                exerciseDayButton(title: "Leg", systemImage: "figure.walk")
            }
            .padding()
        }
        .navigationTitle("Set Exercise Day")
    }

    private func exerciseDayButton(title: String, systemImage: String) -> some View {
        NavigationLink {
            ExerciseDayDetailView(dayType: title)
        } label: {
            VStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 34))

                Text(title)
                    .font(.headline)
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .background(workoutOptionButtonColor, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct ExerciseDayDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ExerciseType.name) private var exerciseTypes: [ExerciseType]

    let dayType: String

    @State private var exerciseDate = Date()
    @State private var exerciseSearchText = ""
    @State private var visibleExercises: [String] = []
    @State private var exerciseInputs: [String: ExerciseLogInput] = [:]
    @State private var isDatePickerPresented = false

    private var searchableExerciseTypes: [String] {
        let customTypes = exerciseTypes.map(\.name)
        var seen = Set<String>()

        return (customTypes + topExerciseTypes).filter { exerciseName in
            let normalizedName = exerciseName.lowercased()
            return seen.insert(normalizedName).inserted
        }
    }

    private var matchingExerciseTypes: [String] {
        let trimmedQuery = exerciseSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            return []
        }

        return searchableExerciseTypes.filter { exerciseName in
            exerciseName.localizedCaseInsensitiveContains(trimmedQuery)
        }
        .prefix(100)
        .map { $0 }
    }

    private var storedExerciseKey: String {
        "exercise-day-\(dayType.lowercased())"
    }

    private func storedExerciseNames() -> [String] {
        UserDefaults.standard.stringArray(forKey: storedExerciseKey) ?? []
    }

    private func saveStoredExerciseNames(_ exerciseNames: [String]) {
        UserDefaults.standard.set(exerciseNames, forKey: storedExerciseKey)
    }

    private func reloadVisibleExercises() {
        visibleExercises = storedExerciseNames().sorted {
            $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
        }
    }

    private func syncInputsWithVisibleExercises() {
        let visibleExerciseNames = Set(visibleExercises)

        for exerciseName in visibleExerciseNames {
            ensureInputExists(for: exerciseName)
        }

        exerciseInputs = exerciseInputs.filter { visibleExerciseNames.contains($0.key) }
    }

    private func isCardioExercise(_ exerciseName: String) -> Bool {
        cardioExerciseTypes.contains(exerciseName)
    }

    private func isValidNumber(_ value: String) -> Bool {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else {
            return false
        }

        return Double(trimmedValue) != nil
    }

    private func showsNumberError(for value: String) -> Bool {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedValue.isEmpty && !isValidNumber(trimmedValue)
    }

    private func ensureInputExists(for exerciseName: String) {
        if exerciseInputs[exerciseName] == nil {
            exerciseInputs[exerciseName] = ExerciseLogInput()
        }
    }

    private func binding(for exerciseName: String, keyPath: WritableKeyPath<ExerciseLogInput, String>) -> Binding<String> {
        Binding(
            get: {
                exerciseInputs[exerciseName]?[keyPath: keyPath] ?? ""
            },
            set: { newValue in
                ensureInputExists(for: exerciseName)
                exerciseInputs[exerciseName]?[keyPath: keyPath] = newValue
            }
        )
    }

    private var canSaveExercises: Bool {
        !visibleExercises.isEmpty && visibleExercises.allSatisfy { exerciseName in
            let input = exerciseInputs[exerciseName] ?? ExerciseLogInput()

            if isCardioExercise(exerciseName) {
                return isValidNumber(input.duration)
            }

            return isValidNumber(input.reps) && isValidNumber(input.weight)
        }
    }

    private func saveLoggedExercises() {
        for exerciseName in visibleExercises {
            let input = exerciseInputs[exerciseName] ?? ExerciseLogInput()
            let entry = ExerciseEntry(
                exerciseName: exerciseName,
                reps: isCardioExercise(exerciseName) ? "" : input.reps.trimmingCharacters(in: .whitespacesAndNewlines),
                weight: isCardioExercise(exerciseName) ? "" : input.weight.trimmingCharacters(in: .whitespacesAndNewlines),
                duration: isCardioExercise(exerciseName) ? input.duration.trimmingCharacters(in: .whitespacesAndNewlines) : "",
                exerciseDate: exerciseDate
            )
            modelContext.insert(entry)
        }

        try? modelContext.save()
        exerciseInputs.removeAll()
    }

    private func addExercise(_ exerciseName: String) {
        guard !visibleExercises.contains(where: { $0.localizedCaseInsensitiveCompare(exerciseName) == .orderedSame }) else {
            exerciseSearchText = ""
            dismissKeyboard()
            return
        }

        visibleExercises.append(exerciseName)
        visibleExercises.sort { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
        syncInputsWithVisibleExercises()
        saveStoredExerciseNames(visibleExercises)
        exerciseSearchText = ""
        dismissKeyboard()
    }

    private func deleteExercise(named exerciseName: String) {
        visibleExercises.removeAll { $0.localizedCaseInsensitiveCompare(exerciseName) == .orderedSame }
        syncInputsWithVisibleExercises()
        saveStoredExerciseNames(visibleExercises)
    }

    var body: some View {
        ZStack {
            appBackgroundColor
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                Button {
                    isDatePickerPresented = true
                } label: {
                    HStack {
                        Text("Date")
                        Spacer()
                        Text(historyDateFormatter.string(from: exerciseDate))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .foregroundStyle(.black)
                }
                .buttonStyle(.plain)

                TextField("Seach exercise type", text: $exerciseSearchText)
                    .textFieldStyle(.roundedBorder)

                if !matchingExerciseTypes.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(matchingExerciseTypes, id: \.self) { exerciseName in
                                Button {
                                    addExercise(exerciseName)
                                } label: {
                                    Text(exerciseName)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .frame(maxHeight: 220)
                }

                if !visibleExercises.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(visibleExercises, id: \.self) { exerciseName in
                                VStack(alignment: .leading, spacing: 8) {
                                    Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
                                        GridRow {
                                            Text(exerciseName)
                                                .font(.headline)

                                            if isCardioExercise(exerciseName) {
                                                TextField("Duration", text: binding(for: exerciseName, keyPath: \.duration))
                                                    .textFieldStyle(.roundedBorder)
                                            } else {
                                                HStack(spacing: 12) {
                                                    TextField("Reps", text: binding(for: exerciseName, keyPath: \.reps))
                                                        .textFieldStyle(.roundedBorder)

                                                    TextField("Weight", text: binding(for: exerciseName, keyPath: \.weight))
                                                        .textFieldStyle(.roundedBorder)
                                                }
                                            }
                                        }
                                    }

                                    if isCardioExercise(exerciseName) {
                                        if showsNumberError(for: exerciseInputs[exerciseName]?.duration ?? "") {
                                            Text("Only number allowed")
                                                .font(.caption)
                                                .foregroundStyle(.red)
                                        }
                                    } else if showsNumberError(for: exerciseInputs[exerciseName]?.reps ?? "") || showsNumberError(for: exerciseInputs[exerciseName]?.weight ?? "") {
                                        Text("Only number allowed")
                                            .font(.caption)
                                            .foregroundStyle(.red)
                                    }

                                    HStack {
                                        Spacer()

                                        Button("Delete", role: .destructive) {
                                            deleteExercise(named: exerciseName)
                                        }
                                        .buttonStyle(.bordered)
                                        .controlSize(.small)
                                        .tint(.red)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.white.opacity(0.6), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                        }
                    }
                }

                Spacer()

                Button {
                    saveLoggedExercises()
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!canSaveExercises)
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                dismissKeyboard()
            }
        }
        .navigationTitle(dayType)
        .onAppear {
            reloadVisibleExercises()
            syncInputsWithVisibleExercises()
        }
        .sheet(isPresented: $isDatePickerPresented) {
            NavigationStack {
                VStack(alignment: .center, spacing: 0) {
                    DatePicker("Date", selection: $exerciseDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .scaleEffect(0.88)
                        .frame(maxHeight: 320, alignment: .top)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .navigationTitle("Select Date")
            }
            .presentationDetents([.fraction(0.56)])
            .onChange(of: exerciseDate) {
                isDatePickerPresented = false
            }
        }
    }
}

struct CreateExerciseView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ExerciseType.name) private var exerciseTypes: [ExerciseType]

    @State private var exerciseDate = Date()
    @State private var exerciseSearchText = ""
    @State private var draftEntries: [DraftExerciseEntry] = []
    @State private var isDatePickerPresented = false

    private var searchableExerciseTypes: [String] {
        let customTypes = exerciseTypes.map(\.name)
        var seen = Set<String>()

        return (customTypes + topExerciseTypes).filter { exerciseName in
            let normalizedName = exerciseName.lowercased()
            return seen.insert(normalizedName).inserted
        }
    }

    private var matchingExerciseTypes: [String] {
        let trimmedQuery = exerciseSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            return []
        }

        return searchableExerciseTypes.filter { exerciseName in
            exerciseName.localizedCaseInsensitiveContains(trimmedQuery)
        }
        .prefix(100)
        .map { $0 }
    }

    private func isCardioExercise(_ exerciseName: String) -> Bool {
        cardioExerciseTypes.contains(exerciseName)
    }

    private func isValidNumber(_ value: String) -> Bool {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else {
            return false
        }
        return Double(trimmedValue) != nil
    }

    private func showsNumberError(for value: String) -> Bool {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedValue.isEmpty && !isValidNumber(trimmedValue)
    }

    private var canSaveDraftEntries: Bool {
        !draftEntries.isEmpty && draftEntries.allSatisfy { entry in
            if isCardioExercise(entry.exerciseName) {
                return isValidNumber(entry.duration)
            }
            return isValidNumber(entry.reps) && isValidNumber(entry.weight)
        }
    }

    private func addExerciseLine(named exerciseName: String) {
        draftEntries.append(DraftExerciseEntry(exerciseName: exerciseName))
        exerciseSearchText = ""
        dismissKeyboard()
    }

    private func saveDraftEntries() {
        for entry in draftEntries {
            let exercise = ExerciseEntry(
                exerciseName: entry.exerciseName,
                reps: isCardioExercise(entry.exerciseName) ? "" : entry.reps.trimmingCharacters(in: .whitespacesAndNewlines),
                weight: isCardioExercise(entry.exerciseName) ? "" : entry.weight.trimmingCharacters(in: .whitespacesAndNewlines),
                duration: isCardioExercise(entry.exerciseName) ? entry.duration.trimmingCharacters(in: .whitespacesAndNewlines) : "",
                exerciseDate: exerciseDate
            )
            modelContext.insert(exercise)
        }

        draftEntries.removeAll()
        exerciseSearchText = ""
    }

    var body: some View {
        ZStack {
            appBackgroundColor
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                Button {
                    isDatePickerPresented = true
                } label: {
                    HStack {
                        Text("Date")
                        Spacer()
                        Text(historyDateFormatter.string(from: exerciseDate))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .foregroundStyle(.black)
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 12) {
                    TextField("Seach exercise type", text: $exerciseSearchText)
                        .textFieldStyle(.roundedBorder)

                    if !matchingExerciseTypes.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(matchingExerciseTypes, id: \.self) { exerciseName in
                                    Button {
                                        addExerciseLine(named: exerciseName)
                                    } label: {
                                        Text(exerciseName)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .frame(maxHeight: 220)
                    }
                }

                if !draftEntries.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
                                GridRow {
                                    Text("Exercise")
                                        .font(.headline)
                                    Text("Entry")
                                        .font(.headline)
                                }
                            }
                            .padding(.bottom, 4)

                            ForEach(draftEntries.indices, id: \.self) { index in
                                VStack(alignment: .leading, spacing: 8) {
                                    Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
                                        GridRow {
                                            Text(draftEntries[index].exerciseName)
                                                .font(.headline)

                                            if isCardioExercise(draftEntries[index].exerciseName) {
                                                TextField("Duration", text: $draftEntries[index].duration)
                                                    .textFieldStyle(.roundedBorder)
                                            } else {
                                                HStack(spacing: 12) {
                                                    TextField("Reps", text: $draftEntries[index].reps)
                                                        .textFieldStyle(.roundedBorder)

                                                    TextField("Weight", text: $draftEntries[index].weight)
                                                        .textFieldStyle(.roundedBorder)
                                                }
                                            }
                                        }
                                    }

                                    if isCardioExercise(draftEntries[index].exerciseName) {
                                        if showsNumberError(for: draftEntries[index].duration) {
                                            Text("Only number allowed")
                                                .font(.caption)
                                                .foregroundStyle(.red)
                                        }
                                    } else if showsNumberError(for: draftEntries[index].reps) || showsNumberError(for: draftEntries[index].weight) {
                                        Text("Only number allowed")
                                            .font(.caption)
                                            .foregroundStyle(.red)
                                    }

                                    HStack {
                                        Spacer()

                                        Button("Delete", role: .destructive) {
                                            draftEntries.remove(at: index)
                                        }
                                        .buttonStyle(.bordered)
                                        .controlSize(.small)
                                        .tint(.red)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.white.opacity(0.6), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }

                Spacer()

                Button {
                    saveDraftEntries()
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!canSaveDraftEntries)
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                dismissKeyboard()
            }
        }
        .sheet(isPresented: $isDatePickerPresented) {
            NavigationStack {
                VStack(alignment: .center, spacing: 0) {
                    DatePicker("Date", selection: $exerciseDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .scaleEffect(0.88)
                        .frame(maxHeight: 320, alignment: .top)
                        .padding(.horizontal)
                        .padding(.top, 8)

                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .navigationTitle("Select Date")
            }
            .presentationDetents([.fraction(0.56)])
            .onChange(of: exerciseDate) {
                isDatePickerPresented = false
            }
        }
        .navigationTitle("New Exercise")
    }
}

struct CreateExerciseTypeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ExerciseType.name) private var exerciseTypes: [ExerciseType]
    @Query private var exerciseEntries: [ExerciseEntry]

    @State private var exerciseTypeName = ""
    @FocusState private var isExerciseTypeFieldFocused: Bool

    private var trimmedExerciseTypeName: String {
        exerciseTypeName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func deleteExerciseType(_ exerciseType: ExerciseType) {
        let relatedEntries = exerciseEntries.filter { entry in
            entry.exerciseName == exerciseType.name
        }

        for entry in relatedEntries {
            modelContext.delete(entry)
        }

        modelContext.delete(exerciseType)
    }

    var body: some View {
        ZStack {
            appBackgroundColor
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                TextField("Exercise name", text: $exerciseTypeName)
                    .textFieldStyle(.roundedBorder)
                    .focused($isExerciseTypeFieldFocused)

                Button("Save") {
                    let exerciseType = ExerciseType(name: trimmedExerciseTypeName)
                    modelContext.insert(exerciseType)
                    exerciseTypeName = ""
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    trimmedExerciseTypeName.isEmpty ||
                    exerciseTypes.contains { existingType in
                        existingType.name.localizedCaseInsensitiveCompare(trimmedExerciseTypeName) == .orderedSame
                    }
                )

                if !exerciseTypes.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(exerciseTypes) { exerciseType in
                                HStack {
                                    Text(exerciseType.name)

                                    Spacer()

                                    Button("Delete", role: .destructive) {
                                        deleteExerciseType(exerciseType)
                                    }
                                    .buttonStyle(.bordered)
                                    .controlSize(.small)
                                    .tint(.red)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                isExerciseTypeFieldFocused = false
            }
        }
        .navigationTitle("Exercise Type")
    }
}

struct PastExerciseDataView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ExerciseEntry.exerciseDate, order: .reverse) private var exerciseEntries: [ExerciseEntry]

    @State private var selectedDate = Calendar.current.startOfDay(for: Date())
    @State private var displayedMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date())) ?? Date()

    private var calendar: Calendar {
        Calendar.current
    }

    private var workoutDates: Set<Date> {
        Set(exerciseEntries.map { calendar.startOfDay(for: $0.exerciseDate) })
    }

    private var monthDates: [Date?] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
            let firstWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start)
        else {
            return []
        }

        let leadingDays = calendar.dateComponents([.day], from: firstWeekInterval.start, to: monthInterval.start).day ?? 0
        let dayCount = calendar.range(of: .day, in: .month, for: displayedMonth)?.count ?? 0

        var dates = Array(repeating: Optional<Date>.none, count: leadingDays)
        for dayOffset in 0..<dayCount {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: monthInterval.start) {
                dates.append(date)
            }
        }

        while dates.count % 7 != 0 {
            dates.append(nil)
        }

        return dates
    }

    private var entriesForSelectedDate: [ExerciseEntry] {
        exerciseEntries.filter { entry in
            calendar.isDate(entry.exerciseDate, inSameDayAs: selectedDate)
        }
    }

    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) {
            displayedMonth = newMonth
        }
    }

    private func isWorkoutDate(_ date: Date) -> Bool {
        workoutDates.contains(calendar.startOfDay(for: date))
    }

    private func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    private func isSelectedDate(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }

    private func deleteExerciseEntry(_ entry: ExerciseEntry) {
        modelContext.delete(entry)
    }

    var body: some View {
        ZStack {
            appBackgroundColor
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                VStack(spacing: 12) {
                    HStack {
                        Button {
                            changeMonth(by: -1)
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.black)
                                .frame(width: 36, height: 36)
                                .background(.white.opacity(0.6), in: Circle())
                        }
                        .buttonStyle(.plain)

                        Spacer()

                        Text(calendarMonthFormatter.string(from: displayedMonth))
                            .font(.headline)

                        Spacer()

                        Button {
                            changeMonth(by: 1)
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.black)
                                .frame(width: 36, height: 36)
                                .background(.white.opacity(0.6), in: Circle())
                        }
                        .buttonStyle(.plain)
                    }

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                        ForEach(calendarWeekdaySymbols, id: \.self) { symbol in
                            Text(symbol)
                                .font(.caption.weight(.semibold))
                                .frame(maxWidth: .infinity)
                        }

                        ForEach(Array(monthDates.enumerated()), id: \.offset) { _, date in
                            if let date {
                                Button {
                                    selectedDate = calendar.startOfDay(for: date)
                                } label: {
                                    Text("\(calendar.component(.day, from: date))")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle((isWorkoutDate(date) || isToday(date)) ? .white : .black)
                                        .frame(width: 36, height: 36)
                                        .background(
                                            Group {
                                                if isToday(date) {
                                                    Circle().fill(Color.blue)
                                                } else if isWorkoutDate(date) {
                                                    Circle().fill(Color.red)
                                                } else if isSelectedDate(date) {
                                                    Circle().stroke(Color.black.opacity(0.5), lineWidth: 1)
                                                }
                                            }
                                        )
                                }
                                .buttonStyle(.plain)
                            } else {
                                Color.clear
                                    .frame(height: 36)
                            }
                        }
                    }
                }

                Text(historyDateFormatter.string(from: selectedDate))
                    .font(.headline)

                if !entriesForSelectedDate.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(entriesForSelectedDate) { entry in
                                HStack(alignment: .top, spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(entry.exerciseName)
                                            .font(.headline)

                                        if entry.duration.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                            Text("Reps: \(entry.reps)  Weight: \(entry.weight)")
                                        } else {
                                            Text("Duration: \(entry.duration)")
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                    Button("Delete", role: .destructive) {
                                        deleteExerciseEntry(entry)
                                    }
                                    .buttonStyle(.bordered)
                                    .controlSize(.small)
                                    .tint(.red)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.white.opacity(0.6), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                } else {
                    Text("You haven't worked out on this date")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 12)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Past Exercise Data")
        .onAppear {
            if let latestEntryDate = exerciseEntries.first?.exerciseDate {
                selectedDate = calendar.startOfDay(for: latestEntryDate)
            }
            displayedMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate)) ?? displayedMonth
        }
        .onChange(of: exerciseEntries.count) {
            displayedMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate)) ?? displayedMonth
        }
    }
}

struct ProgressGraphView: View {
    @Query(sort: \ExerciseType.name) private var exerciseTypes: [ExerciseType]
    @Query(sort: \ExerciseEntry.exerciseDate) private var exerciseEntries: [ExerciseEntry]

    @State private var exerciseSearchText = ""
    @State private var selectedExerciseName = ""

    private var calendar: Calendar {
        Calendar.current
    }

    private var searchableExerciseTypes: [String] {
        let customTypes = exerciseTypes.map(\.name)
        var seen = Set<String>()

        return (customTypes + topExerciseTypes).filter { exerciseName in
            let normalizedName = exerciseName.lowercased()
            return seen.insert(normalizedName).inserted
        }
    }

    private var matchingExerciseTypes: [String] {
        let trimmedQuery = exerciseSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            return []
        }

        return searchableExerciseTypes.filter { exerciseName in
            exerciseName.localizedCaseInsensitiveContains(trimmedQuery)
        }
        .prefix(100)
        .map { $0 }
    }

    private var currentYearEntries: [ExerciseEntry] {
        let currentYear = calendar.component(.year, from: Date())

        return exerciseEntries.filter { entry in
            entry.exerciseName == selectedExerciseName &&
            calendar.component(.year, from: entry.exerciseDate) == currentYear
        }
    }

    private var graphData: [(month: Int, monthName: String, weight: Double)] {
        let monthlyEntries = Dictionary(grouping: currentYearEntries) { entry in
            calendar.component(.month, from: entry.exerciseDate)
        }

        return (1...12).compactMap { month in
            let highestWeight = monthlyEntries[month]?.compactMap { entry -> Double? in
                let trimmedWeight = entry.weight.trimmingCharacters(in: .whitespacesAndNewlines)
                return Double(trimmedWeight)
            }
            .max()

            guard let highestWeight else {
                return nil
            }

            return (month, calendarMonthFormatter.monthSymbols[month - 1], highestWeight)
        }
    }

    private var invalidWeightEntriesExist: Bool {
        currentYearEntries.contains { entry in
            let trimmedWeight = entry.weight.trimmingCharacters(in: .whitespacesAndNewlines)
            return !trimmedWeight.isEmpty && Double(trimmedWeight) == nil
        }
    }

    private func selectExerciseName(_ exerciseName: String) {
        selectedExerciseName = exerciseName
        exerciseSearchText = exerciseName
        dismissKeyboard()
    }

    var body: some View {
        ZStack {
            appBackgroundColor
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Seach exercise type", text: $exerciseSearchText)
                        .textFieldStyle(.roundedBorder)

                    if !matchingExerciseTypes.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(matchingExerciseTypes, id: \.self) { exerciseName in
                                    Button {
                                        selectExerciseName(exerciseName)
                                    } label: {
                                        Text(exerciseName)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 12)
                                            .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .frame(maxHeight: 220)
                    }
                }

                if !selectedExerciseName.isEmpty {
                    Text(selectedExerciseName)
                        .font(.headline)
                }

                if !selectedExerciseName.isEmpty && !graphData.isEmpty {
                    Chart(graphData, id: \.month) { item in
                        LineMark(
                            x: .value("Month", item.monthName),
                            y: .value("Weight", item.weight)
                        )
                        .interpolationMethod(.catmullRom)
                        .lineStyle(StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                        .foregroundStyle(.orange)

                        PointMark(
                            x: .value("Month", item.monthName),
                            y: .value("Weight", item.weight)
                        )
                        .symbolSize(90)
                        .foregroundStyle(.red)
                    }
                    .frame(height: 360)
                    .chartPlotStyle { plotArea in
                        plotArea
                            .background(alignment: .leading) {
                                Rectangle()
                                    .fill(.black)
                                    .frame(width: 2)
                            }
                            .background(alignment: .bottom) {
                                Rectangle()
                                    .fill(.black)
                                    .frame(height: 2)
                            }
                            .padding(.bottom, 2)
                    }
                    .chartXAxis {
                        AxisMarks(values: graphData.map(\.monthName)) { value in
                            AxisValueLabel {
                                if let monthName = value.as(String.self) {
                                    Text(monthName)
                                        .font(.caption)
                                        .rotationEffect(.degrees(-90))
                                        .frame(height: 44)
                                        .fixedSize()
                                }
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading) {
                            AxisTick()
                            AxisValueLabel()
                        }
                    }
                    .chartXAxisLabel(position: .bottom, alignment: .leading, spacing: 0) {
                        Text("Month")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(x: -8, y: 0)
                    }
                    .chartYAxisLabel("Weight")
                }

                Spacer()
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                dismissKeyboard()
            }
        }
        .navigationTitle("Progress Graph")
        .overlay {
            if exerciseEntries.isEmpty {
                ContentUnavailableView(
                    "No Exercise Data Yet",
                    systemImage: "chart.xyaxis.line",
                    description: Text("Save some exercise sessions first to build a progress graph.")
                )
            } else if selectedExerciseName.isEmpty && exerciseSearchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ContentUnavailableView(
                    "Choose an Exercise Type",
                    systemImage: "chart.xyaxis.line",
                    description: Text("Search and select an exercise type to see the highest monthly weight for the current year.")
                )
            } else if graphData.isEmpty {
                ContentUnavailableView(
                    "No Data for This Year",
                    systemImage: "chart.line.downtrend.xyaxis",
                    description: Text("There is no numeric weight data for this exercise in the current year.")
                )
            } else if invalidWeightEntriesExist {
                VStack {
                    Spacer()

                    Text("Only numeric weights are plotted on the graph.")
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.white.opacity(0.7), in: Capsule())
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [ExerciseEntry.self, ExerciseType.self], inMemory: true)
}
