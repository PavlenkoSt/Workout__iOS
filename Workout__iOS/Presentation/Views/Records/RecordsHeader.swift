//
//  RecordsHeader.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 14.12.2025.
//

import SwiftUI

enum RecordsHeaderBtnStatus {
    case none
    case asc
    case desc
}

struct RecordsHeader: View {
    @Binding var sort: RecordsSorting

    var body: some View {
        HStack(spacing: 8) {
            RecordsHeaderBtn(
                title: "Exercise",
                onTap: {
                    changeSortOrder(for: .exercise)
                },
                alignment: Alignment.leading,
                status: status(for: .exercise)
            )

            RecordsHeaderBtn(
                title: "Result",
                onTap: {
                    changeSortOrder(for: .count)
                },
                status: status(for: .count)
            )

            RecordsHeaderBtn(
                title: "Date",
                onTap: {
                    changeSortOrder(for: .date)
                },
                alignment: Alignment.trailing,
                status: status(for: .date)
            )
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(.white.opacity(0.84), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .padding(.horizontal, 16)
        .padding(.top, 10)
    }

    private func changeSortOrder(for field: FieldsSort) {
        withAnimation {
            if sort.field == field {
                sort.order = (sort.order == .asc) ? .desc : .asc
            } else {
                sort.field = field
                sort.order = .desc
            }
        }
    }

    private func status(for field: FieldsSort) -> RecordsHeaderBtnStatus {
        guard sort.field == field else {
            return .none
        }

        return sort.order == .asc ? .asc : .desc
    }
}

struct RecordsHeaderBtn: View {
    var title: String
    var onTap: () -> Void = {}
    var alignment: Alignment = Alignment.center
    var status: RecordsHeaderBtnStatus

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 4) {
                Text(title)
                    .font(.caption.weight(.bold))
                if status != .none {
                    Image(systemName: status == .asc ? "arrow.up" : "arrow.down")
                        .font(.caption2.weight(.bold))
                }
            }
            .foregroundColor(status == .none ? Color.secondary : Color.indigo)
            .frame(maxWidth: .infinity, alignment: alignment)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var sort = RecordsSorting(
        field: .exercise,
        order: .asc
    )

    RecordsHeader(
        sort: $sort
    )
}
