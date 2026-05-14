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

    init() {
        self.billingRepository = RevenueCatBillingRepository()
        self.state = MonetizationViewModel.makeInitialState(
            billingRepository: billingRepository
        )
    }

    init(billingRepository: RevenueCatBillingRepository) {
        self.billingRepository = billingRepository
        self.state = MonetizationViewModel.makeInitialState(
            billingRepository: billingRepository
        )
    }

    private static func makeInitialState(
        billingRepository: RevenueCatBillingRepository
    ) -> MonetizationState {
        MonetizationState(
            isPro: billingRepository.isLocalProUnlocked,
            isLocalProUnlocked: billingRepository.isLocalProUnlocked,
            isRevenueCatConfigured: billingRepository.isConfigured
                || MonetizationConfig.hasRevenueCatAPIKey
        )
    }

    func refresh() {
        Task {
            RevenueCatInitializer.configure()
            state.isLoading = true
            state.message = nil
            state.isRevenueCatConfigured = billingRepository.isConfigured
                || MonetizationConfig.hasRevenueCatAPIKey
            state.isLocalProUnlocked = billingRepository.isLocalProUnlocked
            state.isPro = billingRepository.isLocalProUnlocked || state.isPro

            do {
                let customerInfo = try await billingRepository.getCustomerInfo()
                state.isLoading = false
                state.isPro = billingRepository.isPro(customerInfo: customerInfo)
                state.isLocalProUnlocked = billingRepository.isLocalProUnlocked
                state.isRevenueCatConfigured = billingRepository.isConfigured
                    || MonetizationConfig.hasRevenueCatAPIKey
            } catch {
                state.isLoading = false
                state.message = billingRepository.errorMessage(error)
            }
        }
    }

    func restore() {
        Task {
            do {
                let customerInfo = try await billingRepository.restorePurchases()
                applyCustomerInfo(customerInfo)
                state.isLocalProUnlocked = billingRepository.isLocalProUnlocked
                state.message = state.isPro ? "Purchase restored" : "No Pro purchase found"
            } catch {
                state.message = billingRepository.errorMessage(error)
            }
        }
    }

    @discardableResult
    func applyCustomerInfo(_ customerInfo: CustomerInfo?) -> Bool {
        state.isPro = billingRepository.isPro(customerInfo: customerInfo)
        state.isLocalProUnlocked = billingRepository.isLocalProUnlocked
        state.isRevenueCatConfigured = billingRepository.isConfigured
            || MonetizationConfig.hasRevenueCatAPIKey
        return state.isPro
    }

    func unlockWithCode(_ code: String) -> Bool {
        let unlocked = billingRepository.unlockWithCode(code)
        state.isPro = billingRepository.isPro(customerInfo: nil)
        state.isLocalProUnlocked = billingRepository.isLocalProUnlocked
        state.message = unlocked ? "Pro unlocked" : "Invalid access code"
        return unlocked
    }
}
