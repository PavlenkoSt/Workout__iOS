//
//  ExerciseItem.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 30.11.2025.
//

import SwiftUI

struct ExerciseItem: View {
    var exercise: TrainingExercise
    var index: Int

    var onIncrement: (TrainingExercise) -> Void = { _ in }
    var onDecrement: (TrainingExercise) -> Void = { _ in }

    @State private var showCheckmark = false

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text(String(index + 1))
                    Text(getExerciseName(exercise: exercise))
                }
                Spacer()
                if exercise.type == .dynamic
                    || exercise.type == .staticType
                    || exercise.type == .ladder
                {
                    HStack {
                        StatItem(title: "Reps", value: String(exercise.reps))
                        StatItem(title: "Sets", value: String(exercise.sets))
                        StatItem(title: "Rest", value: "\(exercise.rest) sec.")
                    }
                } else {
                    Spacer().frame(height: 40)
                }
            }

            HStack {
                CounterBtn(
                    text: "-",
                    action: { onDecrement(exercise) }
                )
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.green)
                        .scaleEffect(showCheckmark ? 1 : 0.3)
                        .opacity(showCheckmark ? 1 : 0)
                        .offset(x: 4, y: -12)

                    VStack {
                        Text("\(exercise.setsDone)/\(exercise.sets)")
                        ProgressView(
                            value: Float(exercise.setsDone) / Float(exercise.sets)
                        )
                    }.padding(.bottom, 8)
                        .onAppear(perform: {
                            if exercise.setsDone >= exercise.sets {
                                withAnimation(
                                    .spring(response: 0.4, dampingFraction: 0.7)
                                ) {
                                    showCheckmark = true
                                }
                            }
                        })
                        .onChange(
                            of: exercise.setsDone,
                            perform: {
                                newValue in
                                if newValue >= exercise.sets {
                                    withAnimation(
                                        .spring(
                                            response: 0.4,
                                            dampingFraction: 0.7
                                        )
                                    ) {
                                        showCheckmark = true
                                    }
                                } else if newValue < exercise.sets {
                                    // Hide checkmark if user “rolls back”
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        showCheckmark = false
                                    }
                                }

                            }
                        )
                }

                CounterBtn(
                    text: "+",
                    action: { onIncrement(exercise) }
                )
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .border(Color(.systemGray4), width: 1)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

private struct StatItem: View {
    var title: String
    var value: String

    var body: some View {
        VStack {
            Text(title)
            Text(value)
        }.padding(8).font(.system(size: 12))
    }
}

private struct CounterBtn: View {
    var text: String
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Text(text)
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.system(size: 24, weight: Font.Weight.medium))
        }
        .padding(.vertical, 6)
        .background(Color.blue)
        .cornerRadius(CGFloat(8))
        .foregroundStyle(.white)
        .buttonStyle(.borderless)
    }
}

#Preview {
    ExerciseItem(
        exercise: TrainingExercise(
            name: "Push ups",
            sets: 4,
            reps: 12,
            rest: 120,
            trainingDay: TrainingDay(date: Date()),
            type: ExerciseType.dynamic
        ),
        index: 0
    )
}
