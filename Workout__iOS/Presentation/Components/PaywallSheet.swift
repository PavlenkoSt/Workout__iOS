//
//  PaywallSheet.swift
//  Workout__iOS
//

import RevenueCat
import RevenueCatUI
import SwiftUI

struct PaywallSheet: View {
    @ObservedObject var viewModel: MonetizationViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var isShowingAccessCode = false
    @State private var accessCode = ""
    @State private var accessCodeError: String?

    var body: some View {
        ZStack {
            PaywallView()
                .onPurchaseCompleted { customerInfo in
                    dismissIfPro(customerInfo)
                }
                .onRestoreCompleted { customerInfo in
                    dismissIfPro(customerInfo)
                }

            VStack {
                HStack {
                    Button("Access code") {
                        accessCode = ""
                        accessCodeError = nil
                        isShowingAccessCode = true
                    }
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .frame(height: 36)
                    .background(.black.opacity(0.45))
                    .clipShape(Capsule())
                    .padding(.top, 8)
                    .padding(.leading, 12)

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .background(.black.opacity(0.45))
                            .clipShape(Circle())
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 12)
                }

                Spacer()
            }
        }
        .alert("Access code", isPresented: $isShowingAccessCode) {
            TextField("Code", text: $accessCode)
            Button("Unlock") {
                if viewModel.unlockWithCode(accessCode) {
                    dismiss()
                } else {
                    accessCodeError = "Invalid code"
                    isShowingAccessCode = true
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            if let accessCodeError {
                Text(accessCodeError)
            }
        }
        .onDisappear {
            viewModel.refresh()
        }
    }

    private func dismissIfPro(_ customerInfo: CustomerInfo) {
        if viewModel.applyCustomerInfo(customerInfo) {
            dismiss()
        }
    }
}
