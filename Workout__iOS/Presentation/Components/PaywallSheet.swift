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

    var body: some View {
        ZStack {
            PaywallView()
                .safeAreaPadding(.bottom, 16)
                .onPurchaseCompleted { customerInfo in
                    dismissIfPro(customerInfo)
                }
                .onRestoreCompleted { customerInfo in
                    dismissIfPro(customerInfo)
                }

            VStack {
                HStack {
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
                    .padding(.top, 12)
                    .padding(.trailing, 16)
                }

                Spacer()
            }
            .safeAreaPadding(.top, 8)
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
