//
//  MonetizationViewModel.swift
//  Workout__iOS
//

import Combine
import Foundation
import RevenueCat

@MainActor
final class MonetizationViewModel: ObservableObject {
    @Published private(set) var state: MonetizationState

    private let billingRepository: RevenueCatBillingRepository
    private var customerInfoTask: Task<Void, Never>?

    init() {
        self.billingRepository = RevenueCatBillingRepository()
        self.state = MonetizationViewModel.makeInitialState(
            billingRepository: billingRepository
        )
        startObservingCustomerInfo()
    }

    init(billingRepository: RevenueCatBillingRepository) {
        self.billingRepository = billingRepository
        self.state = MonetizationViewModel.makeInitialState(
            billingRepository: billingRepository
        )
        startObservingCustomerInfo()
    }

    deinit {
        customerInfoTask?.cancel()
    }

    private static func makeInitialState(
        billingRepository: RevenueCatBillingRepository
    ) -> MonetizationState {
        // Instant correct state on launch: use the last confirmed result
        // from RevenueCat (persisted locally) so we don't flash "locked"
        // before the customerInfoStream emits.
        let instantIsPro = billingRepository.isConfirmedProFromPurchase
        return MonetizationState(
            isLoading: false,
            isPro: instantIsPro,
            isRevenueCatConfigured: billingRepository.isConfigured
                || MonetizationConfig.hasRevenueCatAPIKey
        )
    }

    func refresh() {
        RevenueCatInitializer.configure()
        state.message = nil
        state.isRevenueCatConfigured = billingRepository.isConfigured
            || MonetizationConfig.hasRevenueCatAPIKey
        if billingRepository.isConfirmedProFromPurchase {
            state.isPro = true
        }
        startObservingCustomerInfo()
    }

    func restore() {
        Task {
            do {
                let customerInfo = try await billingRepository.restorePurchases()
                applyCustomerInfo(customerInfo)
                state.message = state.isPro ? "Purchase restored" : "No Pro purchase found"
            } catch {
                state.message = billingRepository.errorMessage(error)
            }
        }
    }

    @discardableResult
    func applyCustomerInfo(_ customerInfo: CustomerInfo?) -> Bool {
        let backendPro = billingRepository.isProFromCustomerInfo(customerInfo)
        billingRepository.setConfirmedProFromPurchase(backendPro)
        state.isRevenueCatConfigured = billingRepository.isConfigured
            || MonetizationConfig.hasRevenueCatAPIKey
        state.isPro = backendPro
        return state.isPro
    }

    private func startObservingCustomerInfo() {
        customerInfoTask?.cancel()
        guard Purchases.isConfigured else {
            customerInfoTask = nil
            return
        }
        customerInfoTask = Task { [weak self] in
            for await customerInfo in Purchases.shared.customerInfoStream {
                self?.applyCustomerInfo(customerInfo)
            }
        }
    }
}
