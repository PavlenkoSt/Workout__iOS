import SwiftUI

struct FormField: View {
    let placeholder: String
    @Binding var text: String
    @Binding var error: String?
    var keyboardType: UIKeyboardType = .default
    var inputFilter: (String) -> String = { $0 }
    var onValueChange: (String) -> Void = { _ in }

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                // Invisible rectangle to capture all taps
                Rectangle()
                    .fill(.white)
                    .frame(minHeight: 50)
                    .onTapGesture {
                        isFocused = true
                    }

                TextField(
                    placeholder,
                    text: $text
                )
                .onChange(of: text) { oldValue, newValue in
                    text = inputFilter(newValue)
                    onValueChange(text)
                }
                .keyboardType(keyboardType)
                .focused($isFocused)
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
            }
            .frame(maxWidth: .infinity)
            .roundedBorder()

            Text(error ?? " ")
                .font(.caption)
                .foregroundColor(.red)
                .opacity(error != nil ? 1 : 0)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
