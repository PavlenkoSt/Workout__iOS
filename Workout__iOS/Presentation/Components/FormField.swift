//
//  FormField.swift
//  Workout__iOS
//
//  Created by Stanislav Pavlenko on 09.12.2025.
//

import SwiftUI

struct FormField: View {
    let placeholder: String
    @Binding var text: String
    @Binding var error: String?
    var keyboardType: UIKeyboardType = .default
    var inputFilter: (String) -> String = { $0 }
    var onValueChange: (String) -> Void = { _ in }
    
    var body: some View {
        VStack {
            TextField(
                placeholder,
                text: $text
            )
            .onChange(of: text) { oldValue, newValue in
                text = inputFilter(newValue)
                onValueChange(text)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .frame(minHeight: 50)
            .keyboardType(keyboardType)
            .background(.white)
            .roundedBorder()

            Text(error ?? " ")
                .font(.caption)
                .foregroundColor(.red)
                .opacity(error != nil ? 1 : 0)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
