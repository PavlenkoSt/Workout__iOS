//
//  RevenueCatBillingRepository.swift
//  Workout__iOS
//

import Foundation
import RevenueCat

final class RevenueCatBillingRepository {
    private let defaults: UserDefaults
    private let localProUnlockedKey = "local_pro_unlocked"
    private let confirmedProKey = "confirmed_pro_from_purchase"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var isConfigured: Bool {
        Purchases.isConfigured
    }

    var isLocalProUnlocked: Bool {
        defaults.bool(forKey: localProUnlockedKey)
    }

    var isConfirmedProFromPurchase: Bool {
        defaults.bool(forKey: confirmedProKey)
    }

    func setConfirmedProFromPurchase(_ value: Bool) {
        defaults.set(value, forKey: confirmedProKey)
    }

    func getCustomerInfo() async throws -> CustomerInfo? {
        guard isConfigured else { return nil }
        return try await Purchases.shared.customerInfo()
    }

    func restorePurchases() async throws -> CustomerInfo? {
        guard isConfigured else { return nil }
        return try await Purchases.shared.restorePurchases()
    }

    func isProFromCustomerInfo(_ customerInfo: CustomerInfo?) -> Bool {
        customerInfo?
            .entitlements[MonetizationConfig.proEntitlementID]?
            .isActive == true
    }

    func isPro(customerInfo: CustomerInfo?) -> Bool {
        if isLocalProUnlocked { return true }
        return isProFromCustomerInfo(customerInfo)
    }

    func unlockWithCode(_ code: String) -> Bool {
        let configuredCode = MonetizationConfig.proUnlockCode
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !configuredCode.isEmpty else { return false }
        guard code.trimmingCharacters(in: .whitespacesAndNewlines) == configuredCode
        else {
            return false
        }

        defaults.set(true, forKey: localProUnlockedKey)
        return true
    }

    func errorMessage(_ error: Error) -> String {
        error.localizedDescription
    }
}
