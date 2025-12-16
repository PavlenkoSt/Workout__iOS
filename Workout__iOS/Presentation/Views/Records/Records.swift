//
//  Goals.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 29.11.2025.
//

import SwiftUI
import _SwiftData_SwiftUI

enum SortDirection {
    case asc
    case desc
}

enum FieldsSort {
    case exercise
    case count
    case date
}

struct RecordsSorting {
    var field: FieldsSort
    var order: SortDirection
}

struct Records: View {
    @ObservedObject var viewModel: RecordsViewModel

    @Query var records: [RecordModel]

    @State var sort: RecordsSorting = RecordsSorting(
        field: FieldsSort.date,
        order: SortDirection.desc
    )

    @State var recordToUpdate: RecordModel? = nil

    var sortedRecords: [RecordModel] {
        records.sorted { record1, record2 in
            let comparisonResult: Bool

            switch sort.field {
            case .exercise:
                comparisonResult = record1.exercise < record2.exercise

            case .count:
                comparisonResult = record1.count < record2.count

            case .date:
                comparisonResult = record1.date < record2.date
            }

            return sort.order == .asc ? comparisonResult : !comparisonResult
        }
    }

    var body: some View {
        RecordsContent(
            records: sortedRecords,
            sort: $sort,
            recordToUpdate: $recordToUpdate,
            addRecord: { record in
                viewModel.addRecord(record)
            },
            updateRecord: { recordToUpdate, formResult in
                viewModel.updateRecord(
                    recordToUpdate: recordToUpdate,
                    submitedForm: formResult
                )
            },
            deleteExercise: { record in
                viewModel.deleteRecord(record)
            }
        )
    }
}

struct RecordsContent: View {
    var records: [RecordModel]

    @Binding var sort: RecordsSorting
    @Binding var recordToUpdate: RecordModel?

    @State var isShowingSheet: Bool = false
    @State private var detentHeight: CGFloat = 0

    var addRecord: (RecordModel) -> Void = { _ in }
    var updateRecord: (RecordModel, RecordSubmitResult) -> Void = { _, _ in }
    var deleteExercise: (RecordModel) -> Void = { _ in }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    RecordsHeader(sort: $sort)
                    if !records.isEmpty {
                        List(records, id: \.id) { record in
                            RecordItem(record: record).swipeActions(
                                edge: .trailing,
                                allowsFullSwipe: false
                            ) {
                                Button(role: .destructive) {
                                    deleteExercise(record)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(
                                edge: .leading,
                                allowsFullSwipe: false
                            ) {
                                Button {
                                    recordToUpdate = record
                                    isShowingSheet = true
                                } label: {
                                    Label("Edit", systemImage: "square.and.pencil")
                                }.tint(.blue)
                            }
                        }.safeAreaInset(edge: .bottom) {
                            Spacer().frame(height: geometry.safeAreaInsets.bottom + 80)
                        }
                    } else {
                        Text("No records yet")
                            .padding(30)
                        Spacer()
                    }
                }

                Button {
                    isShowingSheet = true
                } label: {
                    FloatingBtn()
                }
                .padding()
            }.sheet(isPresented: $isShowingSheet) {
                RecordSheet(
                    onSubmit: { result in
                        if let recordToUpdate = self.recordToUpdate {
                            self.updateRecord(recordToUpdate, result)
                        } else {
                            self.addRecord(
                                RecordModel(
                                    exercise: result.exercise,
                                    count: result.count,
                                    unit: result.units,
                                    date: Date()
                                )
                            )
                        }
                        isShowingSheet = false
                    },
                    recordToUpdate: recordToUpdate
                )
                .presentationDragIndicator(.visible).presentationDetents([
                    .height(detentHeight)
                ])
                .readAndBindHeight(to: $detentHeight)
                .onDisappear {
                    recordToUpdate = nil
                }
            }.ignoresSafeArea(.container, edges: .bottom)
        }
    }
}

#Preview {
    @Previewable @State var sort: RecordsSorting = .init(
        field: .exercise,
        order: .desc
    )
    @Previewable @State var recordToUpdate: RecordModel? = nil

    RecordsContent(
        records: [
            RecordModel(
                exercise: "Pull ups",
                count: 10,
                unit: RecordUnit.reps,
                date: Date()
            ),
            RecordModel(
                exercise: "Push ups",
                count: 20,
                unit: RecordUnit.reps,
                date: Date()
            ),
        ],
        sort: $sort,
        recordToUpdate: $recordToUpdate
    )
}
